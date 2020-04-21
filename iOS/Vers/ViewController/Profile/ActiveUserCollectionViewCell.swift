//
//  ActiveUserCollectionViewCell.swift
//  Vers
//
//  Created by sagar.gupta on 15/02/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit

class ActiveUserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgViewProfile:UIImageView!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblWin:UILabel!
    @IBOutlet weak var button_otheruser:UIButton!
    @IBOutlet weak var button_video:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgViewProfile.layer.cornerRadius = imgViewProfile.frame.size.height/2
        imgViewProfile.layer.masksToBounds = true
        imgViewProfile.layer.borderWidth = 2
        imgViewProfile.layer.borderColor = UIColor(red: 255.0/255.0, green: 56/255.0, blue: 57/255.0, alpha: 1.0).cgColor
    }

}
