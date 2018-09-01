//
//  DetailsVC.swift
//  SLNewsReader
//
//  Created by SAKSHI TIWARI on 31/08/18.
//  Copyright © 2018 SAKSHI TIWARI. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController {
    var selectedObj : ResponseObject?
    @IBOutlet weak var imageContent: UIImageView!
    @IBOutlet weak var txtViewDetails: UITextView!
    @IBOutlet weak var lblHeader: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblHeader.text = selectedObj?.title
        self.imageContent.kf.setImage(with: URL(string: (selectedObj?.urlToImage) ?? ""))
        self.txtViewDetails.text = selectedObj?.description
        let dateStr = selectedObj?.publishedAt ?? "NA"
        self.navigationItem.title =  "Published at-" + dateStr

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
