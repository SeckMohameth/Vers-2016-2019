//
//  ReceivedTableViewCell.swift
//  Vers
//
//  Created by sagar.gupta on 23/02/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit

class ReceivedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contentVW:UIView!
    @IBOutlet weak var imgViewProfile:UIImageView!
    @IBOutlet weak var imgViewChallengeTypIcon:UIImageView!
    @IBOutlet weak var lblChallengeTypTitle:UILabel!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblTime:UILabel!
    @IBOutlet weak var lblTitleVersReplied:UILabel!
    @IBOutlet weak var btnChallengeTyp:UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentVW.showShadow()
        imgViewProfile.layer.cornerRadius = imgViewProfile.frame.size.height/2
        imgViewProfile.layer.masksToBounds = true
        imgViewProfile.layer.borderWidth = 2
        imgViewProfile.layer.borderColor = UIColor(red: 255.0/255.0, green: 56/255.0, blue: 57/255.0, alpha: 1.0).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
