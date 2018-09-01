//
//  CustomFavCell.swift
//  SLNewsReader
//
//  Created by SAKSHI TIWARI on 01/09/18.
//  Copyright © 2018 SAKSHI TIWARI. All rights reserved.
//

import UIKit

class CustomFavCell: UICollectionViewCell {
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    var buttonDidClickBlock:(CustomFavCell,UIButton)->Void = {_,_ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
    }
    
    @IBAction func buttonDidClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        buttonDidClickBlock(self,sender)
    }
}
