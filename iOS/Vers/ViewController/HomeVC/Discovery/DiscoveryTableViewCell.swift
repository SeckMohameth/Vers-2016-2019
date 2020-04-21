//
//  DiscoveryTableViewCell.swift
//  Vers
//
//  Created by pawan.sharma on 26/03/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit

class DiscoveryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var user1imgVw:UIImageView!
    @IBOutlet weak var user1LblName:UILabel!
    @IBOutlet weak var user1Videothub:UIImageView!
    @IBOutlet weak var user1VidePlay:UIButton!
    
    @IBOutlet weak var user2imgVw:UIImageView!
    @IBOutlet weak var user2LblName:UILabel!
    @IBOutlet weak var user2Videothub:UIImageView!
    @IBOutlet weak var user2VidePlay:UIButton!
    @IBOutlet weak var winImageView:UIImageView!

    @IBOutlet weak var btnViews:UIButton!
    @IBOutlet weak var btnVote:UIButton!
    
    @IBOutlet weak var lblTime:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        seBoardWithRedius(imgView: user2imgVw)
        seBoardWithRedius(imgView: user1imgVw)
        setBoard(imgView: user1Videothub)
        setBoard(imgView: user2Videothub)
        btnPlayBoard(btnplay: user2VidePlay)
        btnPlayBoard(btnplay: user1VidePlay)
        
        if DeviceType.IS_IPHONE_5 {
            lblTime.font = UIFont.systemFont(ofSize: 12)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func seBoardWithRedius(imgView:UIImageView)  {
        imgView.layer.cornerRadius = imgView.frame.size.height/2
        imgView.layer.masksToBounds = true
        imgView.layer.borderWidth = 2
        imgView.layer.borderColor = UIColor(red: 255.0/255.0, green: 56/255.0, blue: 57/255.0, alpha: 1.0).cgColor
    }
    
    func setBoard(imgView:UIImageView)  {
        imgView.layer.masksToBounds = true
        imgView.layer.borderWidth = 2
        imgView.layer.borderColor = UIColor(red: 255.0/255.0, green: 56/255.0, blue: 57/255.0, alpha: 1.0).cgColor
    }
    
    func btnPlayBoard(btnplay:UIButton)  {
        btnplay.layer.cornerRadius = btnplay.frame.size.height/2
        btnplay.layer.masksToBounds = true
        btnplay.layer.borderWidth = 5
        btnplay.layer.borderColor = UIColor(white: 1.0, alpha: 0.1).cgColor
    }
    
    func setSenderData(senderdata: Discovery.ChallengeDetails.SenderVideoDetails) {
        user1LblName.text = senderdata.name
        user1imgVw.sd_setImage(with: senderdata.userProfileImagePath, placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
        user1Videothub.sd_setImage(with: URL(string: senderdata.thumbImagePath), placeholderImage: #imageLiteral(resourceName: "ImageNotAvailable"), options: .cacheMemoryOnly)
    }
    
    func setReciverData(reciverdata: Discovery.ChallengeDetails.ReceiverVideoDetails) {
        user2LblName.text = reciverdata.name
        user2imgVw.sd_setImage(with: reciverdata.userProfileImagePath, placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
        user2Videothub.sd_setImage(with: URL(string: reciverdata.thumbImagePath), placeholderImage: #imageLiteral(resourceName: "ImageNotAvailable"), options: .cacheMemoryOnly)
    }
    
}
