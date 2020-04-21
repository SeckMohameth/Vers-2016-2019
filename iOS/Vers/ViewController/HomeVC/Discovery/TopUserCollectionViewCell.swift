//
//  TopUserCollectionViewCell.swift
//  Vers
//
//  Created by pawan.sharma on 26/03/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit

class TopUserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var lblNum:UILabel!
    @IBOutlet weak var lblName:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgView.layer.cornerRadius = imgView.frame.size.height/2
        imgView.layer.masksToBounds = true
        imgView.layer.borderWidth = 2
        imgView.layer.borderColor = UIColor(red: 255.0/255.0, green: 56/255.0, blue: 57/255.0, alpha: 1.0).cgColor
    }

}
