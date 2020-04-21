//
//  SendToTableViewCell.swift
//  Vers
//
//  Created by sagar.gupta on 21/02/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit

class USerDetailCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var markImageVW: UIView!
    @IBOutlet weak var markVW: UIImageView!
    @IBOutlet weak var profileImageVW: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSubName: UILabel!
    @IBOutlet weak var btnFollow: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageVW.layer.cornerRadius = profileImageVW.frame.size.height/2
        profileImageVW.layer.masksToBounds = true
        profileImageVW.layer.borderWidth = 2
        markImageVW.layer.cornerRadius = 5
        profileImageVW.layer.borderColor = UIColor.white.cgColor
        markImageVW.backgroundColor = UIColor(red: 255.0/255.0, green: 56/255.0, blue: 57/255.0, alpha: 1.0)
        markVW.image = #imageLiteral(resourceName: "select")
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
    func setPendingBotton()  {
        btnFollow.setTitle("Pending", for: .normal)
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


