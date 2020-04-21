//
//  HomeViewController.swift
//  Vers
//
//  Created by sagar.gupta on 14/02/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit


class HomeViewController: UIViewController {
    @IBOutlet weak var tblHome: UITableView!
    var discoverVW:DiscoveryView!
    @IBOutlet weak var homeblacklipeImgVW: UIImageView!
    @IBOutlet weak var discoveryblacklipeImgVW: UIImageView!
 //   let playerViewController = AVPlayerViewController()
    var reciverVideopath:URL!
    var voteVW:VersVoteView!
    var seletedIdxPath:IndexPath!
    var activeDiscovey:Discovery.ChallengeDetails!
    var activeFollowerchallenges:GetChallenges.FollowerChallenges!
    var activeFollowingchallenges:GetChallenges.FollowingUserChallenges!
    var videoId : Int!
    var videoUrl : URL!

    var homeLischallenges : HomeList.ChallengeDetails!
    var challenge_id:Int!
    var voted_by_userid:Int!
    var voted_to_userid:Int!
    var voted_to_videoid:Int!
    var reportedChallenge_id : Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.navigationController?.navigationBar.isTranslucent = true
       // self.discoverVW.label_Message.isHidden = true
                featchReplyversApiCall()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                    self.getChallengesApiCall()
                })
        configuration()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        self.navigationItem.title = "Home"
        self.addMenuButton(image: "menu")
        self.addNotificationButton(image: "notification")

        VersManager.share.isChangeRecipent = false
        VersManager.share.istryagain = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        voteVW.imageLayer(imgViewProfile: voteVW.imgViewUse1)
        voteVW.imageLayer(imgViewProfile: voteVW.imgViewUse2)

    }
    
    func timinghours (howrPassesd : String) {
        let attributes = [
            NSAttributedStringKey.font : UIFont(name: "Rubik-Medium", size: 10.0)!,
            NSAttributedStringKey.foregroundColor : UIColor(red: 255/255.0, green: 56/255.0, blue: 77/255.0, alpha: 1.0)] as [NSAttributedStringKey : Any]
        
        let attributes1 = [
            NSAttributedStringKey.font : UIFont(name: "Rubik-Medium", size: 10.0)!,
            NSAttributedStringKey.foregroundColor : UIColor(red: 107/255.0, green: 107/255.0, blue: 107/255.0, alpha: 1.0)] as [NSAttributedStringKey : Any]
        
        let atriString1 = NSAttributedString(string: "\\24", attributes: attributes1)
        
        
        let atriString = NSAttributedString(string: "\(howrPassesd)", attributes: attributes)
        let commonString = NSMutableAttributedString()
        commonString.append(atriString)
        commonString.append(atriString1)
        voteVW.lbl_Hourstiming.attributedText = commonString
    }
    
    func configuration()  {
        
        tblHome.register(UINib(nibName: HomeTableViewCell.stringRepresentation, bundle: nil), forCellReuseIdentifier: HomeTableViewCell.stringRepresentation)
        discoverVW = DiscoveryView.instanceFromNib() as? DiscoveryView
        let window = UIApplication.shared.keyWindow
        let topPadding = window?.safeAreaInsets.top ?? CGFloat(0)
        
        let yPosition = (self.navigationController?.navigationBar.frame.height ?? CGFloat(0)) + 60 + topPadding
        
        discoverVW.frame = CGRect(x: 0, y: yPosition, width: self.view.frame.size.width, height: self.view.frame.size.height-yPosition)
      
//        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
//            //iPhone X
//            discoverVW.frame = CGRect(x: 0, y: 150, width: self.view.frame.size.width, height: self.view.frame.size.height-100)
//
//        //    voteVW.frame = CGRect(x: 0, y: 150, width: self.view.frame.size.width, height: self.view.frame.size.height-100)
//        }
     //
        discoverVW.btn_viewprofile.addTarget(self, action: #selector(navigateProfile), for: UIControlEvents.touchUpInside)
        discoverVW.isHidden = true
        self.view.addSubview(discoverVW)
        discoverVW.delegate = self
        discoveryblacklipeImgVW.isHidden = true
        homeblacklipeImgVW.isHidden = false
        
        voteVW = (VersVoteView.instanceFromNib() as! VersVoteView)
        voteVW.btnDone.layer.cornerRadius = 10
        voteVW.frame = self.view.bounds
        voteVW.backgroundColor = UIColor.clear
        voteVW.isHidden = true
        voteVW.btnDone.addTarget(self, action: #selector(btndoneaction), for: .touchUpInside)
        voteVW.btnUser1.addTarget(self, action: #selector(btnUser1Action(sender:)), for: .touchUpInside)
        voteVW.btnUser2.addTarget(self, action: #selector(btnUser2Action(sender:)), for: .touchUpInside)
        voteVW.btnReplay.addTarget(self, action: #selector(btnreplayaction(sender:)), for: .touchUpInside)
    //    self.playerViewController.view.frame = self.view.bounds
    //    self.playerViewController.view.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height)
        
        
     //   self.playerViewController.view.addSubview(voteVW)
        self.view.addSubview(voteVW)
        
      //  discoverVW.view_content.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height * 0.25)
    }
    
    
    @IBAction func button_report(sender:UIButton) {

        
    }
    
    @IBAction func btnVideoRecoding(sender:UIButton) {
        let vc = VideoRecordingController(nibName: "VideoRecordingController", bundle: nil)
        vc.view.frame = self.view.bounds
        VersManager.share.isAcceptScreen = false
        self.navigationController?.pushViewController(vc, animated: true)
        //self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func discoveryBtnAction(sender:UIButton) {
        discoverVW.isHidden = false
        discoveryblacklipeImgVW.isHidden = false
        homeblacklipeImgVW.isHidden = true
        self.navigationItem.title = "Discovery"
        toptenstreaksApiCall()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            self.discoveryApiCall()
        })
        
    }
    
    @IBAction func homeBtnAction(sender:UIButton) {
        discoverVW.isHidden = true
        discoveryblacklipeImgVW.isHidden = true
        self.navigationItem.title = "Home"


        homeblacklipeImgVW.isHidden = false
        featchReplyversApiCall()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            self.getChallengesApiCall()
        })
    }
    func showSuccessAlert(message:String?)  {
        let alert = UIAlertController(title: "", message: message ?? "Ragistration successfully.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            VersManager.share.versReceived = nil
            VersManager.share.homeList = nil
            VersManager.share.versRepliedList = nil
            VersManager.share.versSent = nil
            UserDefaults.standard.removeObject(forKey: "userinfo")
            self.navigateToLoginScreen()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }
    
    fileprivate func logoutApiCall() {
        self.view.showHUD()
        let params = ["user_id":VersManager.share.userLogin?.data.first?.id ?? 0] as JSONDictionary
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.logout) { (JSON: Any?, _: URLResponse?, _: Error?) in
            self.view.hideHUD()
            if let json = JSON as? JSONDictionary {
                print(json)
                if let dictobj = json["meta"] as? JSONDictionary {
                    if dictobj["status"] as! Bool == false {
                        self.view.hideHUD()
                        self.showAlert(title: "Alert", message: dictobj["message"] as? String)
                    } else {
                        self.view.hideHUD()
                        print(json)
                        self.showSuccessAlert(message: dictobj["message"] as? String ?? "Logout successfully.")
                    }
                }else{
                    self.showSuccessAlert(message: json["message"] as? String ?? "Logout successfully.")
                }
                
            }else{
                self.showAlert(title: "", message: "Data is not in correct format.")
            }
        }
    }
    
    fileprivate func featchReplyversApiCall() {
        self.view.showHUD()
        let params = ["user_id":VersManager.share.userLogin?.data.first?.id ?? 0] as JSONDictionary
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.homechallenges) { (JSON: Any?, _: URLResponse?, _: Error?) in
            self.view.hideHUD()
            if let json = JSON as? JSONDictionary {
                print(json)
                if let dictobj = json["meta"] as? JSONDictionary {
                    if dictobj["status"] as! Bool == false {
                        self.view.hideHUD()
                       
                        VersManager.share.homeList = nil
                        self.tblHome.reloadData()
                        if dictobj["message"] as? String == "Unauthorized" {
                        
                           self.showUnauthorizedAlert(title: "Alert", message: dictobj["message"] as? String)
                        }else{
                          
                           self.showAlert(title: "Alert", message: dictobj["message"] as? String)
                        }
                    } else {
                        self.view.hideHUD()
                        print(json)
                        VersManager.share.homeList = HomeList(json: json)
                        self.tblHome.reloadData()
                    }
                }else{
                    self.showAlert(title: "Alert", message: json["message"] as? String)
                }
            }else{
                self.showAlert(title: "", message: "Data not found.")
            }
        }
    }
    
    fileprivate func getChallengesApiCall() {
        self.view.showHUD()
        let params = ["user_id":VersManager.share.userLogin?.data.first?.id ?? 0] as JSONDictionary
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.challenges) { (JSON: Any?, _: URLResponse?, _: Error?) in
            self.view.hideHUD()
            if let json = JSON as? JSONDictionary {
                print(json)
                if let dictobj = json["meta"] as? JSONDictionary {
                    if dictobj["status"] as! Bool == false {
                        self.view.hideHUD()
                        VersManager.share.homeList = nil
                        self.tblHome.reloadData()
                        if dictobj["message"] as? String == "Unauthorized" {
                            self.showUnauthorizedAlert(title: "Alert", message: dictobj["message"] as? String)
                        }else{
                            self.showAlert(title: "Alert", message: dictobj["message"] as? String)
                        }
                    } else {
                        self.view.hideHUD()
                        print(json)
                        VersManager.share.getchallenge = GetChallenges(json: json)
                        self.tblHome.reloadData()
                    }
                }else{
                   self.showAlert(title: "Alert", message: json["message"] as? String)
                }
            }else{
             // self.showAlert(title: "", message: "Data not found.")
            }
        }
    }
    
    
    fileprivate func discoveryApiCall() {
        self.view.showHUD()
        let params = [:] as JSONDictionary
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.discovery) { (JSON: Any?, _: URLResponse?, _: Error?) in
            self.view.hideHUD()
            if let json = JSON as? JSONDictionary {
                print(json)
                if let dictobj = json["meta"] as? JSONDictionary {
                    if dictobj["status"] as! Bool == false {
                        
                        if dictobj["message"] as? String == "Unauthorized" {
                          self.showUnauthorizedAlert(title: "Alert", message: dictobj["message"] as? String)
                        }else{
                            self.showAlert(title: "Alert", message: dictobj["message"] as? String)
           
                        }
                    } else {
                        self.view.hideHUD()
                        print(json)
                        VersManager.share.discoveryList = Discovery(json: json)
                        
                        self.discoverVW.tblDiscovery.reloadData()
                    }
                }else{
              

                   // self.showAlert(title: "Alert", message: json["message"] as? String)
                }
            }else{

              self.showAlert(title: "", message: "Data not found.")
            }
        }
    }
    
    fileprivate func toptenstreaksApiCall() {
        self.view.showHUD()
        let params = ["user_id":VersManager.share.userLogin?.data.first?.id ?? 0] as JSONDictionary
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.toptenStreaks) { (JSON: Any?, _: URLResponse?, _: Error?) in
            self.view.hideHUD()
            if let json = JSON as? JSONDictionary {
                print(json)
                if let dictobj = json["meta"] as? JSONDictionary {
                    if dictobj["status"] as! Bool == false {
                     //   self.discoverVW.topHeightConstraint.constant = 0
                        if dictobj["message"] as? String == "Unauthorized" {
                            self.showUnauthorizedAlert(title: "Alert", message: dictobj["message"] as? String)
                        }else{
                            self.discoverVW.label_Message.isHidden = false
                            
                            self.discoverVW.label_Message.text = "No Streaks Available"
                        //    self.showAlert(title: "Alert", message: dictobj["message"] as? String)
                        }
                    } else {
                  //      self.discoverVW.topHeightConstraint.constant = 150
                         self.discoverVW.label_Message.isHidden = true
                        self.view.hideHUD()
                        print(json)
                        VersManager.share.toptenstrkes = TopTenStreaks(json: json)
                        self.discoverVW.collectionVW.reloadData()
                    }
                }else{
                    self.discoverVW.label_Message.isHidden = false
                    
                    self.discoverVW.label_Message.text = "No Streaks Available"
                   // self.showAlert(title: "Alert", message: json["message"] as? String)
                }
            }else{
                self.discoverVW.label_Message.isHidden = false
                
                self.discoverVW.label_Message.text = "No Streaks Available"
               
            }
        }
    }
    
}


extension HomeViewController {
    @objc func btndoneaction(sender:UIButton)  {
       
     
        if ((voteVW.btnUser1.isSelected == true)  || ( voteVW.btnUser2.isSelected  == true)  ) {
          
            if ( VersManager.share.userLogin?.data.first?.id == voted_to_userid) {
                self.showAlert(title: "Alert", message: "You can not vote your self")
            //    voteVW.isHidden = false
                return
            }
            
            voteVW.isHidden = true
            voteVW.btnUser1.isSelected = false
            voteVW.btnUser2.isSelected = false
            voteVW.imgViewUse2.layer.borderWidth = 0
            voteVW.imgViewUse1.layer.borderWidth = 0
            self.videoVoteApiCall(challenge_id: challenge_id, voted_by_userid: voted_by_userid, voted_to_userid: voted_to_userid, voted_to_videoid: voted_to_videoid)
            
        }  else {
            self.showAlert(title: "Alert", message: "Please Select the User")

        }
    }
    
    @objc func btnUser1Action(sender:UIButton)  {
        
        
         voteVW.imgViewUse2.layer.borderWidth = 0
         voteVW.imgViewUse1.layer.borderWidth = 2
         voteVW.imgViewUse1.layer.borderColor = UIColor(red: 255.0/255.0, green: 56/255.0, blue: 57/255.0, alpha: 1.0).cgColor
        
        voteVW.btnUser1.isSelected = true
         voteVW.btnUser2.isSelected = false
         voted_by_userid = VersManager.share.userLogin?.data.first?.id
        if self.activeDiscovey != nil {
            if VersManager.share.userLogin?.data.first?.id != self.activeDiscovey.senderVideoDetails.first?.id {
                voted_to_userid = self.activeDiscovey.senderVideoDetails.first?.userId
                challenge_id = self.activeDiscovey.challengeId
                voted_to_videoid = self.activeDiscovey.senderVideoDetails.first?.videoId
            }
        }else if (self.activeFollowerchallenges != nil){
            
            voted_to_userid = self.activeFollowerchallenges.senderVideoDetails.first?.userId
            challenge_id = self.activeFollowerchallenges.challengeId
            voted_to_videoid = self.activeFollowerchallenges.senderVideoDetails.first?.videoId
            
        }  else if (activeFollowingchallenges != nil) {
            voted_to_userid = self.activeFollowingchallenges.senderVideoDetails.first?.userId
            challenge_id = self.activeFollowingchallenges.challengeId
            voted_to_videoid = self.activeFollowingchallenges.senderVideoDetails.first?.videoId
            
            
        } else {
            voted_to_userid = VersManager.share.homeList.challengeDetails[seletedIdxPath.row].senderVideoDetails.first?.id
            challenge_id = VersManager.share.homeList.challengeDetails[seletedIdxPath.row].challengeId
            voted_to_videoid = VersManager.share.homeList.challengeDetails[seletedIdxPath.row].senderVideoDetails.first?.videoId
        }
        
    }
    
     @objc func btnreplayaction(sender:UIButton)  {
      //  var  videoUrl:URL!
       // var videoId : Int
        
        if self.activeDiscovey != nil {
            videoUrl = activeDiscovey.senderVideoDetails.first?.videoPath
            videoId = (activeDiscovey.senderVideoDetails.first?.videoId)!
            
        } else if (self.activeFollowerchallenges != nil ){
            
            videoUrl = activeFollowerchallenges.senderVideoDetails.first?.videoPath
            videoId = (activeFollowerchallenges.senderVideoDetails.first?.videoId)!
            
        } else if (self.activeFollowingchallenges != nil ){
            
            videoUrl = activeFollowingchallenges.senderVideoDetails.first?.videoPath
            videoId = (activeFollowingchallenges.senderVideoDetails.first?.videoId)!
            
        } else if (self.homeLischallenges != nil)  {
            videoUrl = VersManager.share.homeList.challengeDetails[seletedIdxPath.row].senderVideoDetails.first?.videoPath
            videoId = (VersManager.share.homeList.challengeDetails[seletedIdxPath.row].senderVideoDetails.first?.videoId)!
        }
        
        
       
        self.openVideoplayer(vidoUrl: videoUrl, isSender: false, videoID: videoId, reportedChallenge_id: reportedChallenge_id)
      
    }
    
    @objc func btnUser2Action(sender:UIButton)  {
         voteVW.imgViewUse1.layer.borderWidth = 0
        voteVW.imgViewUse2.layer.borderWidth = 2
        voteVW.imgViewUse2.layer.borderColor = UIColor(red: 255.0/255.0, green: 56/255.0, blue: 57/255.0, alpha: 1.0).cgColor
        voteVW.btnUser1.layer.borderWidth = 0
        voteVW.btnUser1.isSelected = false
        voteVW.btnUser2.isSelected = true
        voted_by_userid = VersManager.share.userLogin?.data.first?.id
        if self.activeDiscovey != nil {
            if VersManager.share.userLogin?.data.first?.id != self.activeDiscovey.recieverId {
                voted_to_userid = self.activeDiscovey.recieverId
                challenge_id = self.activeDiscovey.challengeId
                voted_to_videoid = self.activeDiscovey.receiverVideoDetails.first?.videoId
            }
        } else if (self.activeFollowingchallenges != nil) {
            voted_to_userid = self.activeFollowingchallenges.recieverId
            challenge_id = self.activeFollowingchallenges.challengeId
            voted_to_videoid = self.activeFollowingchallenges.receiverVideoDetails.first?.videoId
            
        } else if (self.activeFollowerchallenges != nil) {
            voted_to_userid = self.activeFollowerchallenges.recieverId
            challenge_id = self.activeFollowerchallenges.challengeId
            voted_to_videoid = self.activeFollowerchallenges.receiverVideoDetails.first?.videoId
            
        }
        else{
            voted_to_userid = VersManager.share.homeList.challengeDetails[seletedIdxPath.row].receiverVideoDetails.first?.id
            challenge_id = VersManager.share.homeList.challengeDetails[seletedIdxPath.row].challengeId
            voted_to_videoid = VersManager.share.homeList.challengeDetails[seletedIdxPath.row].receiverVideoDetails.first?.videoId
        }
        
    }
    
    @objc func navigateProfile() {
        let userDetailVC = UsersDetailsVC(nibName: "UsersDetailsVC", bundle: nil)
        userDetailVC.status = "send_challenge"
     
        self.navigationController?.pushViewController(userDetailVC, animated: true)
        
    }
    
    func showVoteViewDiscovery() {
        let stringImage1 = activeDiscovey.senderVideoDetails.first?.userProfileImagePath
        let stringImage2 = activeDiscovey.receiverVideoDetails.first?.userProfileImagePath
        voteVW.imgViewUse1.sd_setImage(with: stringImage1?.absoluteURL, placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
        voteVW.imgViewUse2.sd_setImage(with:stringImage2?.absoluteURL , placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
        voteVW.lbl1Name.text =  activeDiscovey.senderVideoDetails.first?.name
        voteVW.lbl2Name.text =  activeDiscovey.receiverVideoDetails.first?.name
        
        
        let attributes = [
            NSAttributedStringKey.font : UIFont(name: "Rubik-Medium", size: 10.0)!,
            NSAttributedStringKey.foregroundColor : UIColor(red: 255/255.0, green: 56/255.0, blue: 77/255.0, alpha: 1.0)] as [NSAttributedStringKey : Any]
        
        let attributes1 = [
            NSAttributedStringKey.font : UIFont(name: "Rubik-Medium", size: 12.0)!,
            NSAttributedStringKey.foregroundColor : UIColor(red: 107/255.0, green: 107/255.0, blue: 107/255.0, alpha: 1.0)] as [NSAttributedStringKey : Any]
        
        let atriString1 = NSAttributedString(string: "\\24", attributes: attributes1)
        
        
        let atriString = NSAttributedString(string: activeDiscovey.hoursPassed, attributes: attributes)
        let commonString = NSMutableAttributedString()
        commonString.append(atriString)
        commonString.append(atriString1)
        voteVW.lbl_Hourstiming.attributedText = commonString
        
    }
    
    func openVideoplayer(vidoUrl:URL,isSender:Bool,videoID : Int, reportedChallenge_id : Int)  {
        let vc = VideoPlayerView()
        vc.videoUrl = vidoUrl
        vc.isSender = isSender
        vc.delegate = self
        vc.videoID = videoID
        vc.homelist = homeLischallenges
        vc.reportedChallenge_id = reportedChallenge_id
        vc.activeDiscovey = activeDiscovey//discoverVW.activeDiscoveychallenge
        vc.activeFollowerchallenges = activeFollowerchallenges
        self.present(vc, animated: false)
    }
}

extension HomeViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if VersManager.share.homeList != nil {
                return VersManager.share.homeList.challengeDetails.count
            }else{
                return 0
            }
        }else{
            if VersManager.share.getchallenge != nil {
                return VersManager.share.getchallenge?.followerChallenges.count ?? 0
            }else{
                return 0
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.stringRepresentation) as!
        HomeTableViewCell
        cell.selectionStyle = .none
         cell.imgVersImage.image = UIImage(named: "vs")
        if indexPath.section == 0 {
            setHomeListData(cell: cell, indexPath: indexPath)
        }else{
            setChallangeData(cell: cell, indexPath: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var videoUrl:URL!
        
        seletedIdxPath = indexPath
        if indexPath.section == 0 {
            videoUrl = VersManager.share.homeList.challengeDetails[indexPath.row].senderVideoDetails.first?.videoPath
            videoId = (VersManager.share.homeList.challengeDetails[indexPath.row].senderVideoDetails.first?.videoId)!
            reportedChallenge_id  = VersManager.share.homeList.challengeDetails[indexPath.row].challengeId
            reciverVideopath =   VersManager.share.homeList.challengeDetails[indexPath.row].receiverVideoDetails.first?.videoPath
            let stringImage1 = VersManager.share.homeList.challengeDetails[indexPath.row].senderVideoDetails.first?.userProfileImagePath
            let stringImage2 = VersManager.share.homeList.challengeDetails[indexPath.row].receiverVideoDetails.first?.userProfileImagePath
            voteVW.imgViewUse1.sd_setImage(with: stringImage1?.absoluteURL, placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            voteVW.imgViewUse2.sd_setImage(with:stringImage2?.absoluteURL , placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            voteVW.lbl1Name.text =  VersManager.share.homeList.challengeDetails[indexPath.row].senderVideoDetails.first?.name
            voteVW.lbl2Name.text = VersManager.share.homeList.challengeDetails[indexPath.row].receiverVideoDetails.first?.name
            
            let attributes = [
                NSAttributedStringKey.font : UIFont(name: "Rubik-Medium", size: 10.0)!,
                NSAttributedStringKey.foregroundColor : UIColor(red: 255/255.0, green: 56/255.0, blue: 77/255.0, alpha: 1.0)] as [NSAttributedStringKey : Any]
            
            let attributes1 = [
                NSAttributedStringKey.font : UIFont(name: "Rubik-Medium", size: 12.0)!,
                NSAttributedStringKey.foregroundColor : UIColor(red: 107/255.0, green: 107/255.0, blue: 107/255.0, alpha: 1.0)] as [NSAttributedStringKey : Any]
            
            let atriString1 = NSAttributedString(string: "\\24", attributes: attributes1)
            
            
            let atriString = NSAttributedString(string: "\(VersManager.share.homeList.challengeDetails[indexPath.row].hoursPassed)", attributes: attributes)
            let commonString = NSMutableAttributedString()
            commonString.append(atriString)
            commonString.append(atriString1)
            voteVW.lbl_Hourstiming.attributedText = commonString
            
            let sendervote = VersManager.share.homeList.challengeDetails[indexPath.row].senderVideoDetails.first?.senderVideoVotesCount ?? 0
            let recivervote = VersManager.share.homeList.challengeDetails[indexPath.row].receiverVideoDetails.first?.recieverVideoVotesCount ?? 0
            let voteCount = recivervote + sendervote
  //          voteVW.btnVote.setTitle("\(voteCount) Votes", for: .normal)
             voteVW.lbl_Votes.text = "\(voteCount) votes"
            
            let senderview = VersManager.share.homeList.challengeDetails[indexPath.row].senderVideoDetails.first?.senderVideoViewsCount ?? 0
            let reciverview = VersManager.share.homeList.challengeDetails[indexPath.row].receiverVideoDetails.first?.recieverVideoViewsCount ?? 0
            let viewCount = senderview + reciverview
            voteVW.lbl_Totalviews.text = "\(viewCount) "
            
            homeLischallenges = VersManager.share.homeList.challengeDetails[indexPath.row]
            
            self.openVideoplayer(vidoUrl: videoUrl, isSender: false, videoID:videoId, reportedChallenge_id: reportedChallenge_id )
       //     let player = AVPlayer(url: videoUrl!)
        //    NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying),
                                //                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
          //  playerViewController.delegate = self
         //   playerViewController.player = player
          //  playerViewController.view.frame = CGRect(x: 10, y: 64, width: 400, height: 500)
          //  self.view.addSubview(playerViewController.view)
           // self.addChildViewController(playerViewController)


//            self.present(vc, animated: true) {
//
//                self.playerViewController.player!.play()
//
//            }
        }else {
            videoUrl = VersManager.share.getchallenge?.followerChallenges[indexPath.row].senderVideoDetails.first?.videoPath
            videoId = (VersManager.share.getchallenge?.followerChallenges[indexPath.row].senderVideoDetails.first?.videoId)!
            reciverVideopath =  VersManager.share.getchallenge?.followerChallenges[indexPath.row].senderVideoDetails.first?.videoPath
           // reportedChallenge_id  = VersManager.share.homeList.challengeDetails[seletedIdxPath.row].challengeId
           
          reportedChallenge_id = VersManager.share.getchallenge?.followerChallenges[indexPath.row].challengeId
            activeFollowerchallenges = VersManager.share.getchallenge?.followerChallenges[indexPath.row]
            
            let stringImage1 = VersManager.share.getchallenge?.followerChallenges[indexPath.row].senderVideoDetails.first?.userProfileImagePath
            let stringImage2 = VersManager.share.getchallenge?.followerChallenges[indexPath.row].receiverVideoDetails.first?.userProfileImagePath
            voteVW.imgViewUse1.sd_setImage(with: stringImage1?.absoluteURL, placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            voteVW.imgViewUse2.sd_setImage(with:stringImage2?.absoluteURL , placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
           voteVW.lbl1Name.text =  VersManager.share.getchallenge?.followerChallenges[indexPath.row].senderVideoDetails.first?.userName
            voteVW.lbl2Name.text = VersManager.share.getchallenge?.followerChallenges[indexPath.row].receiverVideoDetails.first?.userName
            
            let senderview = VersManager.share.getchallenge?.followerChallenges[indexPath.row].senderVideoDetails.first?.senderVideoViewsCount ?? 0
            let reciverview = VersManager.share.getchallenge?.followerChallenges[indexPath.row].receiverVideoDetails.first?.recieverVideoViewsCount ?? 0
            let viewCount = senderview + reciverview
            voteVW.lbl_Totalviews.text = "\(viewCount) "
            
            let sendervote = VersManager.share.getchallenge?.followerChallenges[indexPath.row].senderVideoDetails.first?.senderVideoVotesCount ?? 0
            let recivervote = VersManager.share.getchallenge?.followerChallenges[indexPath.row].receiverVideoDetails.first?.recieverVideoVotesCount ?? 0
            let voteCount = recivervote + sendervote
            //          voteVW.btnVote.setTitle("\(voteCount) Votes", for: .normal)
            voteVW.lbl_Votes.text = "\(voteCount) votes"
//            let player = AVPlayer(url: videoUrl!)
//            NotificationCenter.default.addObserver(self, selector: #selector(followerPlayerDidFinishPlaying),
//                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
//            playerViewController.delegate = self
//            playerViewController.player = player
//            playerViewController.view.frame = CGRect(x: 0, y: 64, width: self.view.bounds.width , height: self.view.bounds.height)
//
//              self.view.addSubview(playerViewController.view)
//            self.addChildViewController(playerViewController)

            self.openVideoplayer(vidoUrl: videoUrl, isSender: false, videoID: videoId, reportedChallenge_id: reportedChallenge_id) //{
              //  self.playerViewController.player!.play()
            //}
        }
       
    }

    @objc func playerDidFinishPlaying()  {
     //   playerViewController.dismiss(animated: false, completion: nil)
        let player = AVPlayer(url: reciverVideopath!)
        if seletedIdxPath.section == 1 {
            NotificationCenter.default.addObserver(self, selector: #selector(voteView),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        }
    //    playerViewController.delegate = self
    //    playerViewController.player = player
    //    self.present(playerViewController, animated: false) {
    //        self.playerViewController.player!.play()
    //    }
    }
    
    @objc func followerPlayerDidFinishPlaying()  {
        
        if  VersManager.share.userLogin?.data.first?.id != self.activeFollowerchallenges.senderVideoDetails.first?.id {
            self.videoViewApiCall(challenge_id: self.activeFollowerchallenges.challengeId, user_id: (VersManager.share.userLogin?.data.first?.id)!, video_id: (self.activeFollowerchallenges.senderVideoDetails.first?.videoId)!)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
         //   self.playerViewController.dismiss(animated: false, completion: nil)
            let player = AVPlayer(url: (self.activeFollowerchallenges.receiverVideoDetails.first?.videoPath)!)
            if self.seletedIdxPath.section == 1 {
                NotificationCenter.default.addObserver(self, selector: #selector(self.voteView),
                                                       name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
            }
//            self.playerViewController.delegate = self
//            self.playerViewController.player = player
//            self.present(self.playerViewController, animated: false) {
//                self.playerViewController.player!.play()
//            }
        })
    }
    
    @objc func discoveryPlayerDidFinishPlaying()  {
        
        if VersManager.share.userLogin?.data.first?.id != self.activeDiscovey.senderVideoDetails.first?.id {
            self.videoViewApiCall(challenge_id: self.activeDiscovey.challengeId, user_id: (VersManager.share.userLogin?.data.first?.id)!, video_id: (self.activeDiscovey.senderVideoDetails.first?.videoId)!)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
          //  self.playerViewController.dismiss(animated: false, completion: nil)
            let player = AVPlayer(url: (self.activeDiscovey.receiverVideoDetails.first?.videoPath)!)
            NotificationCenter.default.addObserver(self, selector: #selector(self.voteView),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
           // self.playerViewController.delegate = self
          //  self.playerViewController.player = player
          //  self.present(self.playerViewController, animated: false) {
          //      self.playerViewController.player!.play()
          //  }
        })
        
    }
    
    @objc func voteView() {
        if self.activeDiscovey != nil {
            showVoteViewDiscovery()
            if VersManager.share.userLogin?.data.first?.id != self.activeDiscovey.receiverVideoDetails.first?.id {
                self.videoViewApiCall(challenge_id: self.activeDiscovey.challengeId, user_id: (VersManager.share.userLogin?.data.first?.id)!, video_id: (self.activeDiscovey.receiverVideoDetails.first?.videoId)!)
                //timinghours (howrPassesd: (VersManager.share.discoveryList?.challengeDetails[0].hoursPassed)!)
            }
        }
        
        if self.activeFollowerchallenges != nil {
          //  showVoteViewDiscovery()
            if VersManager.share.userLogin?.data.first?.id != self.activeFollowerchallenges.receiverVideoDetails.first?.id {
                self.videoViewApiCall(challenge_id: self.activeFollowerchallenges.challengeId, user_id: (VersManager.share.userLogin?.data.first?.id)!, video_id: (self.activeFollowerchallenges.receiverVideoDetails.first?.videoId)!)
                timinghours (howrPassesd: (activeFollowerchallenges.hoursPassed))
            }
        }
    
        voteVW.isHidden = false
    }
    
    func setHomeListData(cell:HomeTableViewCell,indexPath:IndexPath)  {
        
        let strimg1 = VersManager.share.homeList.challengeDetails[indexPath.row].senderVideoDetails.first?.userProfileImagePath.absoluteString ?? ""
        
        let strimg2 = VersManager.share.homeList.challengeDetails[indexPath.row].receiverVideoDetails.first?.userProfileImagePath.absoluteString ?? ""
        
        

        cell.imgViewUser1.sd_setImage(with: URL(string: strimg1), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
        cell.imgViewUser2.sd_setImage(with: URL(string: strimg2), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
        cell.lblUser1Name.text = VersManager.share.homeList.challengeDetails[indexPath.row].senderVideoDetails.first?.userName
        cell.lblUser2Name.text = VersManager.share.homeList.challengeDetails[indexPath.row].receiverVideoDetails.first?.userName
        let attributes = [
            NSAttributedStringKey.font : UIFont(name: "Rubik-Medium", size: 10.0)!,
            NSAttributedStringKey.foregroundColor : UIColor(red: 255/255.0, green: 56/255.0, blue: 77/255.0, alpha: 1.0)] as [NSAttributedStringKey : Any]
        
        let attributes1 = [
            NSAttributedStringKey.font : UIFont(name: "Rubik-Medium", size: 10.0)!,
            NSAttributedStringKey.foregroundColor : UIColor(red: 107/255.0, green: 107/255.0, blue: 107/255.0, alpha: 1.0)] as [NSAttributedStringKey : Any]
        
        let atriString1 = NSAttributedString(string: "\\24", attributes: attributes1)
        
        
        let atriString = NSAttributedString(string: "\(VersManager.share.homeList.challengeDetails[indexPath.row].hoursPassed)", attributes: attributes)
        let commonString = NSMutableAttributedString()
        commonString.append(atriString)
        commonString.append(atriString1)
        cell.lblTime.attributedText = commonString
       
        let sendervote = VersManager.share.homeList.challengeDetails[indexPath.row].senderVideoDetails.first?.senderVideoVotesCount ?? 0
        let recivervote = VersManager.share.homeList.challengeDetails[indexPath.row].receiverVideoDetails.first?.recieverVideoVotesCount ?? 0
        let voteCount = recivervote + sendervote
        cell.btnVote.setTitle("\(voteCount) Votes", for: .normal)
        
        let senderview = VersManager.share.homeList.challengeDetails[indexPath.row].senderVideoDetails.first?.senderVideoViewsCount ?? 0
        let reciverview = VersManager.share.homeList.challengeDetails[indexPath.row].receiverVideoDetails.first?.recieverVideoViewsCount ?? 0
        let viewCount = senderview + reciverview
        cell.btnViews.setTitle("\(viewCount) Views", for: .normal)
        
        if VersManager.share.homeList.challengeDetails[indexPath.row].postExpiryStatus == "expired" {
            if (VersManager.share.homeList.challengeDetails[indexPath.row].wonStatus == "won_by_sender") {
                if (VersManager.share.homeList.challengeDetails[indexPath.row].wonBy ==  VersManager.share.homeList.challengeDetails[indexPath.row].senderId) {
                    cell.imgVersImage.image = UIImage(named: "left-arrow (3)")
                }
                
            } else if (VersManager.share.homeList.challengeDetails[indexPath.row].wonStatus == "won_by_receiver") {
                if (VersManager.share.homeList.challengeDetails[indexPath.row].wonBy ==  VersManager.share.homeList.challengeDetails[indexPath.row].recieverId) {
                    cell.imgVersImage.image = UIImage(named: "Right-arrow (3) 2")
                }
                
                
                
            } else if (VersManager.share.homeList.challengeDetails[indexPath.row].wonStatus == "tied") {
                //      cell.imgVersImage.sd_setImage(with: URL(string: "equality-sign"), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
                cell.imgVersImage.image = UIImage(named: "equality-sign")
            }
            
        }
        
    }
    
    func setChallangeData(cell:HomeTableViewCell,indexPath:IndexPath)  {
        
        
        
        let strimg1 = VersManager.share.getchallenge?.followerChallenges[indexPath.row].senderVideoDetails.first?.userProfileImagePath.absoluteString ?? ""
        
        let strimg2 = VersManager.share.getchallenge?.followerChallenges[indexPath.row].receiverVideoDetails.first?.userProfileImagePath.absoluteString ?? ""
        
        cell.imgViewUser1.sd_setImage(with: URL(string: strimg1), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
        cell.imgViewUser2.sd_setImage(with: URL(string: strimg2), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
        cell.lblUser1Name.text = VersManager.share.getchallenge?.followerChallenges[indexPath.row].senderVideoDetails.first?.userName
        cell.lblUser2Name.text = VersManager.share.getchallenge?.followerChallenges[indexPath.row].receiverVideoDetails.first?.userName
       
    
        
        let attributes = [
            NSAttributedStringKey.font : UIFont(name: "Rubik-Medium", size: 10.0)!,
            NSAttributedStringKey.foregroundColor : UIColor(red: 255/255.0, green: 56/255.0, blue: 77/255.0, alpha: 1.0)] as [NSAttributedStringKey : Any]
        
        let attributes1 = [
            NSAttributedStringKey.font : UIFont(name: "Rubik-Medium", size: 10.0)!,
            NSAttributedStringKey.foregroundColor : UIColor(red: 107/255.0, green: 107/255.0, blue: 107/255.0, alpha: 1.0)] as [NSAttributedStringKey : Any]
        
        let atriString1 = NSAttributedString(string: "\\24", attributes: attributes1)
        
        
        let atriString = NSAttributedString(string: "\(VersManager.share.getchallenge?.followerChallenges[indexPath.row].hoursPassed ?? "0")", attributes: attributes)
        let commonString = NSMutableAttributedString()
        commonString.append(atriString)
        commonString.append(atriString1)
        cell.lblTime.attributedText = commonString
        
        let sendervote = VersManager.share.getchallenge?.followerChallenges[indexPath.row].senderVideoDetails.first?.senderVideoVotesCount ?? 0
        let recivervote = VersManager.share.getchallenge?.followerChallenges[indexPath.row].receiverVideoDetails.first?.recieverVideoVotesCount ?? 0
        let voteCount = recivervote + sendervote
        cell.btnVote.setTitle("\(voteCount) Votes", for: .normal)
        
        let senderview = VersManager.share.getchallenge?.followerChallenges[indexPath.row].senderVideoDetails.first?.senderVideoViewsCount ?? 0
        let reciverview = VersManager.share.getchallenge?.followerChallenges[indexPath.row].receiverVideoDetails.first?.recieverVideoViewsCount ?? 0
        let viewCount = senderview + reciverview
        cell.btnViews.setTitle("\(viewCount) Views", for: .normal)
        
        if VersManager.share.getchallenge?.followerChallenges[indexPath.row].postExpiryStatus == "expired" {
            if (VersManager.share.getchallenge?.followerChallenges[indexPath.row].wonStatus == "won_by_sender") {
                if (VersManager.share.getchallenge?.followerChallenges[indexPath.row].wonBy == VersManager.share.getchallenge?.followerChallenges[indexPath.row].senderId ) {
                    cell.imgVersImage.image = UIImage(named: "left-arrow (3)")
                }
                
            } else if (VersManager.share.getchallenge?.followerChallenges[indexPath.row].wonStatus == "won_by_receiver") {
              if (VersManager.share.getchallenge?.followerChallenges[indexPath.row].wonBy == VersManager.share.getchallenge?.followerChallenges[indexPath.row].recieverId) {
                    
                    cell.imgVersImage.image = UIImage(named: "Right-arrow (3) 2")
                }
                
            } else if (VersManager.share.getchallenge?.followerChallenges[indexPath.row].wonStatus == "tied") {
                //       cell.imgVersImage.sd_setImage(with: URL(string: "equality-sign"), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
                cell.imgVersImage.image = UIImage(named: "equality-sign")
            }
            
        }
    }
}

extension HomeViewController:DiscoveryViewDelegate {

    
    func seletedTopTenstrkes(streaks: TopTenStreaks.Data) {
        let vc = OtherUserProfileVC.init(nibName: OtherUserProfileVC.stringRepresentation, bundle: nil)
        vc.user_id = streaks.wonBy
        print(streaks.wonBy)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
   
    
    func playView(datadiscovry: Discovery.ChallengeDetails) {
        activeDiscovey = datadiscovry
        let videoURL = datadiscovry.senderVideoDetails.first?.videoPath
        videoId = datadiscovry.senderVideoDetails.first?.videoId
        reciverVideopath = datadiscovry.receiverVideoDetails.first?.videoPath
        voteVW.lbl1Name.text = datadiscovry.senderVideoDetails.first?.userName
        voteVW.lbl2Name.text = datadiscovry.receiverVideoDetails.first?.userName
        reportedChallenge_id  = datadiscovry.senderVideoDetails.first?.id
        print(reportedChallenge_id)
       let sendervote =   VersManager.share.discoveryList?.challengeDetails[0].senderVideoDetails.first?.senderVideoVotesCount ?? 0
           let recivervote = VersManager.share.discoveryList?.challengeDetails[0].receiverVideoDetails.first?.recieverVideoVotesCount ?? 0
       let voteCount = recivervote + sendervote
        voteVW.lbl_Votes.text = "\(voteCount) votes"
        let attributes = [
            NSAttributedStringKey.font : UIFont(name: "Rubik-Medium", size: 10.0)!,
            NSAttributedStringKey.foregroundColor : UIColor(red: 255/255.0, green: 56/255.0, blue: 77/255.0, alpha: 1.0)] as [NSAttributedStringKey : Any]
        
        let attributes1 = [
            NSAttributedStringKey.font : UIFont(name: "Rubik-Medium", size: 12.0)!,
            NSAttributedStringKey.foregroundColor : UIColor(red: 107/255.0, green: 107/255.0, blue: 107/255.0, alpha: 1.0)] as [NSAttributedStringKey : Any]
        
        let atriString1 = NSAttributedString(string: "\\24", attributes: attributes1)
        
        
        let atriString = NSAttributedString(string: "\(String(describing: VersManager.share.discoveryList?.challengeDetails[0].hoursPassed ?? "0"))", attributes: attributes)
        let commonString = NSMutableAttributedString()
        commonString.append(atriString)
        commonString.append(atriString1)
        voteVW.lbl_Hourstiming.attributedText = commonString
        
        let senderview = VersManager.share.discoveryList?.challengeDetails[0].senderVideoDetails.first?.senderVideoViewsCount ?? 0
        let reciverview = VersManager.share.discoveryList?.challengeDetails[0].receiverVideoDetails.first?.recieverVideoViewsCount ?? 0
        let viewCount = senderview + reciverview
        voteVW.lbl_Totalviews.text = "\(viewCount) "
        
        self.openVideoplayer(vidoUrl: videoURL!, isSender: false, videoID: videoId!, reportedChallenge_id: reportedChallenge_id)
    }
}

extension HomeViewController:AVPlayerViewControllerDelegate {
    
    
}

extension HomeViewController:VideoPlayerViewDelegate {
   
       func callagain(isreciver: Bool) {
        self.dismiss(animated: false, completion: nil)
        if isreciver {
            self.openVideoplayer(vidoUrl: reciverVideopath, isSender: true, videoID: videoId, reportedChallenge_id: reportedChallenge_id)
            
        }else{
            print(isreciver)
           print("Check")
           voteView()
        }
    }
}
