//
//  SimpleNotificationTbCell.swift
//  Vers
//
//  Created by sagar.gupta on 08/03/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit

class SimpleNotificationTbCell: UITableViewCell {
    
    @IBOutlet weak var shadowVW: UIView!
    @IBOutlet weak var contentVW: UIView!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shadowVW.showShadow()
        contentVW.layer.cornerRadius = 10
        contentVW.layer.borderWidth = 1
        contentVW.layer.borderColor = UIColor.clear.cgColor
        imgVwUser.layer.cornerRadius = imgVwUser.frame.size.height/2
        imgVwUser.layer.masksToBounds = true
        imgVwUser.layer.borderWidth = 2
        imgVwUser.layer.borderColor = UIColor(red: 255.0/255.0, green: 56/255.0, blue: 57/255.0, alpha: 1.0).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
