//
//  SummaryVC.swift
//  SLNewsReader
//
//  Created by SAKSHI TIWARI on 30/08/18.
//  Copyright © 2018 SAKSHI TIWARI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import RealmSwift

// Model definition
class NewsData: Object {
    @objc dynamic var urlToImage = ""
    @objc dynamic var publishedAt = ""
    @objc dynamic var title = ""
    @objc dynamic var descriptionData = ""
    @objc dynamic var author = ""
    @objc dynamic var url = ""
    @objc dynamic var source:SourceData?
    
}
class SourceData: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""

}

enum StringConstants: String {
    case cellReuseItentifier = "cellSummary"
    case cellReuseItentifier2 = "cellFav"
    case tabOneHeader = "News Feeds"
    case tabTwoHeader = "Your Choices"
    case favouriteStorage = "FavouritesData"
}

class SummaryVC: UIViewController {
    @IBOutlet weak var cvSummary: UICollectionView!
    @IBOutlet weak var tabBar: UITabBar!
    var reuseIdentifier = StringConstants.cellReuseItentifier.rawValue
    var arrRes = [ResponseObject]()
    var arrFav = [ResponseObject]()

    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        //Tab bar initial set up
        tabBar.delegate = self
        tabBar.selectedItem = tabBar.items?[0]
        self.navigationItem.title = StringConstants.tabOneHeader.rawValue
        //CV register cell
        let nibFile : UINib =  UINib(nibName: "CustomCVCell", bundle: nil)
        self.cvSummary.register(nibFile, forCellWithReuseIdentifier: StringConstants.cellReuseItentifier.rawValue)
        let nibFile2 : UINib =   UINib(nibName: "CustomFavCell", bundle: nil)
        self.cvSummary.register(nibFile2, forCellWithReuseIdentifier: StringConstants.cellReuseItentifier2.rawValue)
        
        if #available(iOS 10.0, *) {
            self.cvSummary.refreshControl = refreshControl
        } else {
            self.cvSummary.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        refreshControl.attributedTitle  = NSAttributedString.init(string: "fetching feeds")
        refreshControl.tintColor = UIColor.white
        //Initial Set up
        self.initialSetUp()
        //Fetching data
        self.getAPIContent(isFavourite: false)
    }
    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Data
        switch tabBar.selectedItem?.tag {
        case 1:
            self.getAPIContent(isFavourite: false)
        default:
            break
        }
    }
   
    func initialSetUp() -> Void {
        if let patternImage = UIImage(named: "Pattern") {
            view.backgroundColor = UIColor(patternImage: patternImage)
        }
        self.cvSummary.backgroundColor = UIColor.clear
        self.cvSummary.contentInset = UIEdgeInsets(top: 23, left: 10, bottom: 10, right: 10)
        // Set the PinterestLayout delegate
        if let layout = self.cvSummary.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }

    }
    func getAPIContent(isFavourite:Bool) -> Void {
        let url = isFavourite == true ? EVERYTHING_DOMAIN : TOP_HEADLINES
        print(url)
        Alamofire.request(url).responseJSON { (responseData) -> Void in
            self.refreshControl.endRefreshing()
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                if let resData = swiftyJsonVar["articles"].arrayObject {
                    isFavourite == true ? self.arrFav.removeAll() : self.arrRes.removeAll()
                    resData.forEach({ (data) in
                        let dic = data as! NSDictionary
                        let resObj = ResponseObject.init(dictionary: dic)!
                        if isFavourite{
                            self.arrFav.append(resObj)
                        }
                        else{
                        self.arrRes.append(resObj)
                        }
                    })
                }
                if self.arrRes.count > 0 || self.arrFav.count > 0{
                    self.cvSummary.delegate = self
                    self.cvSummary.dataSource = self
                    self.cvSummary.reloadData()
                }
            }
        }
        
    }
}
//MARK:-  Tab Bar Delegate
extension SummaryVC : UITabBarDelegate{
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 1:
            self.getAPIContent(isFavourite: false)
            reuseIdentifier = StringConstants.cellReuseItentifier.rawValue
            self.navigationItem.title = StringConstants.tabOneHeader.rawValue
        case 2:
            var arrData = self.getInfoById()
            
            self.getAPIContent(isFavourite: true)
            reuseIdentifier = StringConstants.cellReuseItentifier2.rawValue
            self.navigationItem.title = StringConstants.tabTwoHeader.rawValue
        default:
            break
        }
    }
}
//MARK:-  Collection View Delegate
extension SummaryVC : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC
        detailsVC.selectedObj = self.arrRes[indexPath.item]
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
//MARK:-  Collection View Datasource
extension SummaryVC : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  tabBar.selectedItem?.tag == 1 ? self.arrRes.count : self.arrFav.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch tabBar.selectedItem?.tag {
        case 1:
            let cell:CustomCVCell  = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomCVCell
            let objData  = self.arrRes[indexPath.item]
            cell.captionLabel.text = objData.title
            cell.imageView.kf.setImage(with: URL(string: objData.urlToImage))
            return cell
        case 2:
         let cell:CustomFavCell  = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomFavCell
           let objData  = self.arrFav[indexPath.item]
            cell.captionLabel.text = objData.title
            cell.imageView.kf.setImage(with: URL(string: objData.urlToImage))
            cell.btnFavourite.isSelected = true
            cell.buttonDidClickBlock = {(button,cell)  in
            button.isSelected = !button.isSelected
            if !button.isSelected{
                self.arrFav.remove(at: indexPath.item)
                self.cvSummary.reloadData()
            }
         }
         return cell
        default:
          return UICollectionViewCell()
        }
    }
}
//MARK: - PINTEREST LAYOUT DELEGATE
extension SummaryVC : PinterestLayoutDelegate {
    
    // 1. Returns the photo height
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        return CGSize.init(width: 150, height: 200).height //photos[indexPath.item].image.size.height
    }
    
}
//MARK: - Insert into database

extension SummaryVC{
    func insertDataWithObject(obj:ResponseObject) -> Void {
        let configuration = Realm.Configuration(encryptionKey: nil)
        let realm = try! Realm(configuration: configuration)
        let data = NewsData()
        data.author = obj.author
        data.urlToImage = obj.urlToImage
        data.publishedAt = obj.publishedAt
        data.title = obj.title
        data.url = obj.url
        data.descriptionData = obj.description
        data.author = obj.author
        data.source?.id = obj.source.id
        data.source?.name = obj.source.name
        try! realm.write {
            realm.add(data)
        }
    }
     func getInfoById() -> Results<NewsData> {
        let realm = try! Realm()
        let arrData = realm.objects(NewsData.self)
        return arrData
    }
    func removeData(dataObj:ResponseObject) -> Void {
        
    }
}
