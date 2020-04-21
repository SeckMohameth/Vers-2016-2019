//
//  HomeTableViewCell.swift
//  Vers
//
//  Created by sagar.gupta on 16/02/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containterView: UIView!
    @IBOutlet weak var imgViewUser1: UIImageView!
    @IBOutlet weak var lblUser1Name: UILabel!
    @IBOutlet weak var imgViewUser2: UIImageView!
    @IBOutlet weak var imgVersImage: UIImageView!

    @IBOutlet weak var lblUser2Name: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnViews:UIButton!
    @IBOutlet weak var btnVote:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containterView.layer.shadowColor =  UIColor(red: 80.0/255.0, green: 102.0/255.0, blue: 138.0/255.0, alpha: 0.6).cgColor
        containterView.layer.shadowOffset = CGSize.zero
        containterView.layer.shadowOpacity = 0.5
        containterView.layer.shadowRadius = 5
        containterView.backgroundColor = UIColor.white
        containterView.layer.cornerRadius = 3.3
        self.imageLayer(imgViewProfile: imgViewUser1)
        self.imageLayer(imgViewProfile: imgViewUser2)
        
    }
    
    func imageLayer(imgViewProfile:UIImageView)  {
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
