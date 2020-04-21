//
//  VersVoteView.swift
//  Vers
//
//  Created by pawan.sharma on 27/03/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit

class VersVoteView: UIView {
    
    @IBOutlet weak var btnUser1: UIButton!
    @IBOutlet weak var btnUser2: UIButton!
    @IBOutlet weak var lbl1Name: UILabel!
    @IBOutlet weak var lbl2Name: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnReplay: UIButton!
    @IBOutlet weak var lbl_Votes: UILabel!
    @IBOutlet weak var lbl_Hourstiming: UILabel!
    @IBOutlet weak var lbl_Totalviews: UILabel!
    @IBOutlet weak var imgViewUse1: UIImageView!
    @IBOutlet weak var imgViewUse2: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageLayer(imgViewProfile: imgViewUse1)
        imageLayer(imgViewProfile: imgViewUse2)
    }
    
    func imageLayer(imgViewProfile:UIImageView)  {
        imgViewProfile.layer.cornerRadius = imgViewProfile.frame.size.height/2
        imgViewProfile.layer.masksToBounds = true
       // imgViewProfile.layer.borderWidth = 2
       // imgViewProfile.layer.borderColor = UIColor(red: 255.0/255.0, green: 56/255.0, blue: 57/255.0, alpha: 1.0).cgColor
    }

}
