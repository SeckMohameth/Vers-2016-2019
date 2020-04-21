//
//  SentVersView.swift
//  Vers
//
//  Created by sagar.gupta on 26/02/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit

protocol SentVersViewDelegate {
    func changeRecipient(index:IndexPath)
    func tryAgain(index:IndexPath)
}

class SentVersView: UIView {
    
    @IBOutlet weak var tblSent:UITableView!
    var delegate:SentVersViewDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tblSent.register(UINib(nibName: ReceivedTableViewCell.stringRepresentation, bundle: nil), forCellReuseIdentifier: ReceivedTableViewCell.stringRepresentation)
    }
    
    internal func reloadSentVers() {
        tblSent.reloadData()
    }
    
    @objc func btnChangeRecipient(sender:UIButton) {
        guard let cell = sender.superview?.superview?.superview as? ReceivedTableViewCell else {
            return // or fatalError() or whatever
        }
        let indexPath = tblSent.indexPath(for: cell) ?? [1,0]
        print(indexPath)
        delegate.changeRecipient(index: indexPath)
    }
    
    @objc func btnTryAgaing(sender:UIButton) {
        guard let cell = sender.superview?.superview?.superview as? ReceivedTableViewCell else {
            return // or fatalError() or whatever
        }
        let indexPath = tblSent.indexPath(for: cell) ?? [1,0]
        print(indexPath)
        delegate.tryAgain(index: indexPath)
        
    }
}

extension SentVersView:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblSent.dequeueReusableCell(withIdentifier: ReceivedTableViewCell.stringRepresentation) as! ReceivedTableViewCell
        if indexPath.section == 0  {
            cell.lblTitleVersReplied.isHidden = true
            cell.imgViewProfile.sd_setImage(with: URL(string: VersManager.share.versSent.data[indexPath.row].userProfileImagePath.absoluteString), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            cell.lblTitle.text = VersManager.share.versSent.data[indexPath.row].recievername
            cell.lblTime.text =  "Sent \(VersManager.share.versSent.data[indexPath.row].timeElapsed)"
             cell.lblTitleVersReplied.text = VersManager.share.versSent.data[indexPath.row].challenegeTitle
            cell.btnChallengeTyp.tag = indexPath.row
            if VersManager.share.versSent.data[indexPath.row].challengeStatus == "pending" {
                cell.lblChallengeTypTitle.text = VersManager.share.versSent.data[indexPath.row].challengeStatus.capitalized
                cell.imgViewChallengeTypIcon.image = #imageLiteral(resourceName: "pending")
                cell.btnChallengeTyp.setTitle("Try again?", for: .normal)
                cell.btnChallengeTyp.addTarget(self, action: #selector(btnTryAgaing(sender:)), for: .touchUpInside)
                cell.btnChallengeTyp.isHidden = true
            }else if VersManager.share.versSent.data[indexPath.row].challengeStatus == "declined"{
                cell.lblChallengeTypTitle.text = VersManager.share.versSent.data[indexPath.row].challengeStatus.capitalized
                cell.btnChallengeTyp.setTitle("Change Recipient?", for: .normal)
                cell.imgViewChallengeTypIcon.image = #imageLiteral(resourceName: "Decline")
                cell.btnChallengeTyp.addTarget(self, action: #selector(btnChangeRecipient(sender:)), for: .touchUpInside)
                cell.btnChallengeTyp.isHidden = false
            }else if VersManager.share.versSent.data[indexPath.row].challengeStatus == "expired" {
                cell.lblChallengeTypTitle.text = VersManager.share.versSent.data[indexPath.row].challengeStatus.capitalized
                cell.imgViewChallengeTypIcon.image = #imageLiteral(resourceName: "expired")
                cell.btnChallengeTyp.setTitle("Try again?", for: .normal)
                cell.btnChallengeTyp.addTarget(self, action: #selector(btnChangeRecipient(sender:)), for: .touchUpInside)
                cell.btnChallengeTyp.isHidden = false
            }
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 1 {
            cell.lblTitleVersReplied.isHidden = true
            cell.imgViewProfile.sd_setImage(with: URL(string: VersManager.share.reactVers.data[indexPath.row].senderProfileImagePath.absoluteString), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            cell.lblTitle.text = VersManager.share.reactVers.data[indexPath.row].senderuserName
           cell.lblTime.text =  "Sent \(VersManager.share.reactVers.data[indexPath.row].timeElapsed)"
            cell.btnChallengeTyp.tag = indexPath.row
            if VersManager.share.reactVers.data[indexPath.row].challengePostStatus == "vetoed" {
                cell.lblChallengeTypTitle.text = VersManager.share.reactVers.data[indexPath.row].challengePostStatus.capitalized
                cell.imgViewChallengeTypIcon.image = #imageLiteral(resourceName: "Decline")
                cell.btnChallengeTyp.setTitle("Try again?", for: .normal)
                cell.btnChallengeTyp.addTarget(self, action: #selector(btnTryAgaing(sender:)), for: .touchUpInside)
                cell.btnChallengeTyp.isHidden = false
            }else if VersManager.share.reactVers.data[indexPath.row].challengePostStatus == "pending"{
                cell.lblChallengeTypTitle.text = VersManager.share.reactVers.data[indexPath.row].challengePostStatus.capitalized
                cell.btnChallengeTyp.setTitle("Change Recipient?", for: .normal)
                cell.imgViewChallengeTypIcon.image = #imageLiteral(resourceName: "pending")
                cell.btnChallengeTyp.addTarget(self, action: #selector(btnChangeRecipient(sender:)), for: .touchUpInside)
                cell.btnChallengeTyp.isHidden = true
            }else if VersManager.share.reactVers.data[indexPath.row].challengePostStatus == "expired" {
                cell.lblChallengeTypTitle.text = VersManager.share.reactVers.data[indexPath.row].challengePostStatus.capitalized
                cell.imgViewChallengeTypIcon.image = #imageLiteral(resourceName: "expired")
                cell.btnChallengeTyp.setTitle("Try again?", for: .normal)
                cell.btnChallengeTyp.addTarget(self, action: #selector(btnChangeRecipient(sender:)), for: .touchUpInside)
            }else if VersManager.share.reactVers.data[indexPath.row].challengePostStatus == "posted" {
                cell.lblChallengeTypTitle.text = VersManager.share.reactVers.data[indexPath.row].challengePostStatus.capitalized
                cell.imgViewChallengeTypIcon.isHidden = true
                cell.btnChallengeTyp.isHidden = true
                cell.lblChallengeTypTitle.text = "Challange Posted"
            }
            cell.selectionStyle = .none
            return cell
        }else{
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if VersManager.share.versSent != nil {
                return VersManager.share.versSent.data.count
            }else{
                return 0
            }
        }else if section == 1{
            if VersManager.share.reactVers != nil {
                return VersManager.share.reactVers.data.count
            }else{
                return 0
            }
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
