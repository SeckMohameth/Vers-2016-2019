//
//  ReceivedView.swift
//  Vers
//
//  Created by sagar.gupta on 23/02/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit

protocol ReceivedViewDelegate {
    func seletedUser(indx:IndexPath)
}

class ReceivedView: UIView {
    
    @IBOutlet weak var tblReceived:UITableView!
    var delegate: ReceivedViewDelegate!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tblReceived.register(UINib(nibName: ReceivedTableViewCell.stringRepresentation, bundle: nil), forCellReuseIdentifier: ReceivedTableViewCell.stringRepresentation)
    }
    
    internal func reloadReceivedVers() {
        tblReceived.reloadData()
    }

}

extension ReceivedView:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tblReceived.dequeueReusableCell(withIdentifier: ReceivedTableViewCell.stringRepresentation) as! ReceivedTableViewCell
            cell.selectionStyle = .none
            cell.imgViewProfile.sd_setImage(with: URL(string: VersManager.share.versRepliedList.data[indexPath.row].senderProfileImage.absoluteString), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            cell.lblTitle.isHidden = true
            cell.lblTitle.text = VersManager.share.versRepliedList.data[indexPath.row].sendername

            cell.lblTitleVersReplied.isHidden = false
            cell.lblTitleVersReplied.text = "\(VersManager.share.versRepliedList.data[indexPath.row].sendername) replied to your Vers"
            cell.lblTime.text = "Recieved\(VersManager.share.versRepliedList.data[indexPath.row].timeElapsed)"
            cell.btnChallengeTyp.isHidden = true
            cell.imgViewChallengeTypIcon.isHidden = true
            cell.lblChallengeTypTitle.isHidden = true
            return cell
           
        }else{

            let cell = tblReceived.dequeueReusableCell(withIdentifier: ReceivedTableViewCell.stringRepresentation) as! ReceivedTableViewCell
            cell.selectionStyle = .none
            cell.imgViewProfile.sd_setImage(with: URL(string: VersManager.share.versReceived.data[indexPath.row].senderProfileImage.absoluteString), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            cell.lblTitleVersReplied.text = VersManager.share.versReceived.data[indexPath.row].challenegeTitle
            cell.lblTitle.text = VersManager.share.versReceived.data[indexPath.row].sendername
            cell.lblTime.text = "Recieved \(VersManager.share.versReceived.data[indexPath.row].timeElapsed)"
            cell.btnChallengeTyp.isHidden = true
            cell.imgViewChallengeTypIcon.isHidden = true
           cell.lblChallengeTypTitle.isHidden = true
         //  cell.lblTitle.isHidden = true
            cell.lblTitleVersReplied.isHidden = false
            return cell
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if VersManager.share.versRepliedList != nil {
                return VersManager.share.versRepliedList.data.count
            }else{
                return 0
            }
        }else if section == 1{
            if VersManager.share.versReceived != nil {
                return VersManager.share.versReceived.data.count
            }else{
                return 0
            }
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.seletedUser(indx: indexPath)
    }
}
