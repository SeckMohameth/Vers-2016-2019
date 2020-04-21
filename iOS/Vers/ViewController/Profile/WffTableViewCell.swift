//
//  WffTableViewCell.swift
//  Vers
//
//  Created by pawan.sharma on 29/03/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit

class WffTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shadowVW: UIView!
    @IBOutlet weak var contentVW: UIView!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblDefeted: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnFollow: UIButton!

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
    
    func setFollowingBotton()  {
        btnFollow.setTitle("Following", for: .normal)
        btnFollow.backgroundColor = UIColor.lightGray
        btnFollow.setTitleColor(UIColor.white, for: .normal)
        btnFollow.isUserInteractionEnabled = false
    }
    
    func setFollowBotton()  {
        btnFollow.setTitle("Follow", for: .normal)
        btnFollow.backgroundColor = UIColor(red: 255/255.0, green: 56/255.0, blue: 77/255.0, alpha: 1.0)
        btnFollow.setTitleColor(UIColor.white, for: .normal)
        btnFollow.isUserInteractionEnabled = true
    }
    
}
