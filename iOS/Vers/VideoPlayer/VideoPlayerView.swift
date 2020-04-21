//
//  VideoPlayerView.swift
//  Vers
//
//  Created by Nishant.Tiwari on 16/04/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

protocol VideoPlayerViewDelegate {
    func callagain(isreciver:Bool)
  
}

class VideoPlayerView: UIViewController,AVPlayerViewControllerDelegate{
    
    @IBOutlet weak var custom_view : UIView!
    @IBOutlet weak var Report_view : UIView!
    @IBOutlet weak var ReportReason_view : UIView!
    @IBOutlet weak var ReportChallange_view : UIView!
    @IBOutlet weak var Details_view : UIView!
    @IBOutlet weak var button_Report : UIButton!
    @IBOutlet weak var button_challange : UIButton!
    @IBOutlet weak var label_title : UILabel!
    @IBOutlet weak var label_description : UILabel!
    @IBOutlet weak var label_details : UILabel!
    @IBOutlet weak var label_senderName : UILabel!
    @IBOutlet weak var imageview_senderName : UIImageView!
    @IBOutlet weak var imageview_receiverName : UIImageView!
    @IBOutlet weak var label_ReceiverName : UILabel!
    @IBOutlet weak var button_senderFollow : UIButton!
    @IBOutlet weak var button_receiverFOllow : UIButton!

    @IBOutlet weak var view_Report : UIView!

    
    
    var reportedChallenge_id : Int!
    
    private var imageView: UIImageView!
    var isSender:Bool!
    var videoUrl:URL!
    var videoID : Int!
    
    var reciverVideopath:URL?
    var senderVideopath:URL?
    var activeDiscovey:Discovery.ChallengeDetails!
    var activeFollowerchallenges:GetChallenges.FollowerChallenges!
    var homelist:HomeList.ChallengeDetails!
    var voteVW:VersVoteView!
    var delegate:VideoPlayerViewDelegate!
    //    var avPlayerLayer = AVPlayerLayer()
    var profiledata :Activevers.ChallengeDetails!
    var report_type : Int!
    var reported_by_userid : Int!
    var report_reason : String!
    var playerViewController:AVPlayerViewController!
    let data = HomeViewController()
    var reported_user_id : Int!
    var reported_challenge_id : Int!
    var reported_video_id : Int!
    var avPlayer : AVPlayer!
     var reciverId:Int!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Report_view.isHidden = true
        ReportReason_view.isHidden = true
        ReportChallange_view.isHidden = true
        Details_view.isHidden = true
        Details_view.layer.cornerRadius = 10
        view_Report.layer.cornerRadius = 10
        ReportReason_view.layer.cornerRadius = 10
        ReportChallange_view.layer.cornerRadius = 10
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    //    apiCalling ()
        AvplayerCustom()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpDtailsViewData()
    }
    
    func setUpDtailsViewData()  {
        
        if activeDiscovey != nil {
         
          label_title.text = activeDiscovey.challenegeTitle
           label_senderName.text = activeDiscovey.senderVideoDetails.first?.name
            let stringimage = activeDiscovey.senderVideoDetails.first?.userProfileImagePath.absoluteString ?? ""
            imageview_senderName.sd_setImage(with: URL(string: stringimage), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            
            let stringImage1 = activeDiscovey.receiverVideoDetails.first?.userProfileImagePath.absoluteString ?? ""
            imageview_receiverName.sd_setImage(with: URL(string: stringImage1), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            imageview_senderName.layer.cornerRadius = imageview_senderName.frame.size.width / 2
            imageview_senderName.clipsToBounds = true
            
            imageview_receiverName.layer.cornerRadius = imageview_senderName.frame.size.width / 2
            imageview_receiverName.clipsToBounds = true
            label_description.text = activeDiscovey.challengeDescription
            label_senderName.text = activeDiscovey.senderVideoDetails.first?.name
            label_ReceiverName.text = activeDiscovey.receiverVideoDetails.first?.name
            label_details.text! = "\(String(describing: activeDiscovey.senderVideoDetails.first?.name ?? ""))? vers \(String(describing: activeDiscovey.receiverVideoDetails.first?.name ?? ""))?"
            reciverId = activeDiscovey.receiverVideoDetails.first?.id
        }
         if self.activeFollowerchallenges != nil {
          label_title.text = activeFollowerchallenges.challenegeTitle
             label_description.text = activeFollowerchallenges.challengeDescription
            let stringimage = activeFollowerchallenges.senderVideoDetails.first?.userProfileImagePath.absoluteString ?? ""
            imageview_senderName.sd_setImage(with: URL(string: stringimage), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            label_senderName.text = activeFollowerchallenges.senderVideoDetails.first?.name
            label_ReceiverName.text = activeFollowerchallenges.receiverVideoDetails.first?.name
            label_details.text = "\(activeFollowerchallenges.senderVideoDetails.first?.name ?? "") vers \(activeFollowerchallenges.receiverVideoDetails.first?.name ?? "")"
            imageview_receiverName.layer.cornerRadius = imageview_senderName.frame.size.width / 2
            imageview_receiverName.clipsToBounds = true
            
            imageview_senderName.layer.cornerRadius = imageview_senderName.frame.size.width / 2
            imageview_senderName.clipsToBounds = true
            let stringImage1 = activeFollowerchallenges.receiverVideoDetails.first?.userProfileImagePath.absoluteString ?? ""
             imageview_receiverName.sd_setImage(with: URL(string: stringImage1), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            reciverId = activeFollowerchallenges.receiverVideoDetails.first?.id

        }
        if self.homelist != nil {
            label_title.text = homelist.challenegeTitle
            label_description.text = homelist.challengeDescription
            let stringimage = homelist.senderVideoDetails.first?.userProfileImagePath.absoluteString ?? ""
            imageview_senderName.sd_setImage(with: URL(string: stringimage), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            
            imageview_senderName.layer.cornerRadius = imageview_senderName.frame.size.width / 2
            imageview_senderName.clipsToBounds = true
            
            imageview_receiverName.layer.cornerRadius = imageview_senderName.frame.size.width / 2
            imageview_receiverName.clipsToBounds = true
            let stringImage1 = homelist.receiverVideoDetails.first?.userProfileImagePath.absoluteString ?? ""
            imageview_receiverName.sd_setImage(with: URL(string: stringImage1), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            label_senderName.text = homelist.senderVideoDetails.first?.name
            label_ReceiverName.text = homelist.receiverVideoDetails.first?.name
              label_details?.text? = "\(homelist.senderVideoDetails.first?.name ?? "")? vers \(homelist.receiverVideoDetails.first?.name ?? "")?"
            reciverId = homelist.receiverVideoDetails.first?.id

        }
        
        if profiledata != nil {
            
            label_title.text = profiledata.challenegeTitle
            label_description.text = profiledata.challengeDescription
            let stringimage = profiledata.senderVideoDetails.first?.userProfileImagePath.absoluteString ?? ""
            imageview_senderName.sd_setImage(with: URL(string: stringimage), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            
            imageview_senderName.layer.cornerRadius = imageview_senderName.frame.size.width / 2
            imageview_senderName.clipsToBounds = true
            
            imageview_receiverName.layer.cornerRadius = imageview_senderName.frame.size.width / 2
            imageview_receiverName.clipsToBounds = true
            let stringImage1 = profiledata.receiverVideoDetails.first?.userProfileImagePath.absoluteString ?? ""
            imageview_receiverName.sd_setImage(with: URL(string: stringImage1), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            label_senderName.text = profiledata.senderVideoDetails.first?.name
            label_ReceiverName.text = profiledata.receiverVideoDetails.first?.name
            label_details?.text? = "\(profiledata.senderVideoDetails.first?.name ?? "")? vers \(profiledata.receiverVideoDetails.first?.name ?? "")?"
            reciverId = profiledata.receiverVideoDetails.first?.id
        }
        
    }
    
}
extension VideoPlayerView {
    
    func AvplayerCustom() {
//        if reciverVideopath != nil {
//            videoUrl = reciverVideopath
//        }else{
//            videoUrl = senderVideopath
//        }0
        avPlayer = AVPlayer()
        avPlayer = AVPlayer(url: videoUrl)
        playerViewController = AVPlayerViewController()
        playerViewController.player = avPlayer
        playerViewController.player!.play()
        if #available(iOS 11.0, *) {
            playerViewController.entersFullScreenWhenPlaybackBegins = true
        } else {
            // Fallback on earlier versions
        }

        self.addChildViewController(playerViewController)
        self.view.addSubview(playerViewController.view)
        playerViewController.view.frame = self.custom_view.frame
        self.addChildViewController(playerViewController)
        self.custom_view.superview?.addSubview(playerViewController.view)
        NotificationCenter.default.addObserver(self, selector: #selector(didfinis),
                                                                  name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
        avPlayer.play()
    }
    
    @objc func didfinis () {
        if isSender {
            delegate.callagain(isreciver: false)

        }else{
            delegate.callagain(isreciver: true)
            
        }
    }
    
    @objc func voteView() {
        if self.activeDiscovey != nil {
         
            if VersManager.share.userLogin?.data.first?.id != self.activeDiscovey.receiverVideoDetails.first?.id {
                self.videoViewApiCall(challenge_id: self.activeDiscovey.challengeId, user_id: (VersManager.share.userLogin?.data.first?.id)!, video_id: (self.activeDiscovey.receiverVideoDetails.first?.videoId)!)
            }
        }
        
        if self.activeFollowerchallenges != nil {
            if VersManager.share.userLogin?.data.first?.id != self.activeFollowerchallenges.receiverVideoDetails.first?.id {
                self.videoViewApiCall(challenge_id: self.activeFollowerchallenges.challengeId, user_id: (VersManager.share.userLogin?.data.first?.id)!, video_id: (self.activeFollowerchallenges.receiverVideoDetails.first?.videoId)!)
            }
        }
        
        voteVW.isHidden = false
    }
    
//    func apiCalling () {
//        videoUrl = VersManager.share.homeList.challengeDetails[0].senderVideoDetails.first?.videoPath
//
//        reciverVideopath = VersManager.share.homeList.challengeDetails[0].receiverVideoDetails.first?.videoPath
//        print(videoUrl)
//
//    }
    
    
}

extension VideoPlayerView {
    
    @IBAction func button_FollowSender(_ sender : UIButton) {
       
        let senderId:Int!
        
        senderId = VersManager.share.userLogin?.data.first?.id
     //   revicerId = carValues[(indexPath?.row)!].id
      //  reciverId = activeDiscovey.receiverVideoDetails.first?.userId
        self.followRequestApiCall(follow_request_senderid: senderId, follow_request_receiverid: reciverId)
        
    }
    
    
    @IBAction func button_FollowReceiver(_ sender : UIButton) {
        let senderId:Int!
        senderId = VersManager.share.userLogin?.data.first?.id
  self.followRequestApiCall(follow_request_senderid: senderId, follow_request_receiverid: reciverId)
    }
    
    
      @IBAction func button_Details(_ sender : UIButton) {
        
        setUpDtailsViewData()
        Details_view .isHidden = false
        Details_view.layer.cornerRadius = 10
        Report_view.isHidden = true
        ReportReason_view.isHidden = true
        playerViewController.view.isHidden = true
        button_senderFollow.layer.cornerRadius = 10
        button_receiverFOllow.layer.cornerRadius = 10

        ReportChallange_view.isHidden = true
        avPlayer.pause()
    }
    
       @IBAction func button_cancelDetails(_ sender : UIButton) {
         playerViewController.view.isHidden = false
        avPlayer.play()
        Details_view .isHidden = true
        
    }
    
    
    @IBAction func button_back (_ sender : UIButton) {
        
        self.dismiss(animated: true) {
        }
    }
    
    @IBAction func button_cancel (_ sender : UIButton) {
        Report_view.isHidden = true
        ReportReason_view.isHidden = true
        ReportChallange_view.isHidden = true
        playerViewController.view.isHidden = false
        avPlayer.play()
    }
    
    @IBAction func button_inappropirate (_ sender : UIButton) {
      
           ReportViewApiCall1()
        ReportReason_view.isHidden = true
        
    }
    
    @IBAction func button_spam (_ sender : UIButton) {
       
             ReportViewApiCall()
        ReportReason_view.isHidden = true
    }
    @IBAction func button_spamChallange (_ sender : UIButton) {
        
        ReportChallangeViewApiCall()
        
    }
    
     @IBAction func button_spamInappropirate (_ sender : UIButton) {
           ReportChallangeViewApiCall1()
    }
    
    @IBAction func button_options (_ sender : UIButton) {
        Details_view .isHidden = true

        Report_view.isHidden = false
        playerViewController.view.isHidden = true
        avPlayer.pause()
    }
    
    @IBAction func button_report(_ sender : UIButton) {
      
        ReportReason_view.isHidden = false
    }
    
    @IBAction func button_reportChallange(_ sender : UIButton) {
       ReportChallange_view.isHidden = false
        
    }
    
     @IBAction func button_senderFollow(_ sender : UIButton) {
        
    }
    
    @IBAction func button_receieverFollow(_ sender : UIButton) {
        
    }
    
}
//Api Calling
extension VideoPlayerView {
    
    internal func ReportViewApiCall() {
        let params = ["report_type":VersManager.share.changeReportParams.reportType,"reported_by_userid":VersManager.share.userLogin?.data.first?.id ?? 0,"report_reason":VersManager.share.changeReportParams.reportReason,"reported_user_id":VersManager.share.changeReportParams.reported_user_id, "reported_video_id": videoID, "reported_challenge_id" : VersManager.share.changeReportParams.reported_challenge_id] as [String : Any]
        
        print(params)
        
        self.view.showHUD()
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.reports) { (JSON: Any?, _: URLResponse?, _: Error?) in
            self.view.hideHUD()
            if let json = JSON as? JSONDictionary {
                print(json)
                if let dictobj = json["meta"] as? JSONDictionary {
                    if dictobj["status"] as! Bool == false {
                        self.view.hideHUD()
                        if dictobj["message"] as? String == "Unauthorized" {
                            self.showUnauthorizedAlert(title: "Alert", message: dictobj["message"] as? String)
                        }else{
                            self.showAlert(title: "Alert", message: dictobj["message"] as? String)
                            
                        }
                    } else {
                        let actionSheetController: UIAlertController = UIAlertController(title: "Alert", message: "Report details inserted successfully.", preferredStyle: .alert)
                        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
                            self.ReportReason_view.isHidden = true
                            self.Report_view.isHidden = true
                            
                            self.dismiss(animated: true, completion: nil)
                        }
                        actionSheetController.addAction(cancelAction)
                        self.present(actionSheetController, animated: true, completion: nil)
                        self.view.hideHUD()
                        print(json)
                        //    self.showAlert(title: "Alert", message: json["message"] as? String)
                        
                    }
                }else{
                    self.showAlert(title: "Alert", message: json["message"] as? String)
                }
            }else{
                self.showAlert(title: "", message: "Data not found.")
            }
        }
    }
    
    internal func ReportViewApiCall1() {
        let params = ["report_type":VersManager.share.changeReportParams.reportType,"reported_by_userid":VersManager.share.userLogin?.data.first?.id ?? 0,"report_reason":VersManager.share.changeReportParams1.reportReason,"reported_user_id":VersManager.share.changeReportParams.reported_user_id, "reported_video_id": videoID, "reported_challenge_id" : VersManager.share.changeReportParams.reported_challenge_id] as [String : Any]
        
        print(params)
        
        self.view.showHUD()
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.reports) { (JSON: Any?, _: URLResponse?, _: Error?) in
            self.view.hideHUD()
            if let json = JSON as? JSONDictionary {
                print(json)
                if let dictobj = json["meta"] as? JSONDictionary {
                    if dictobj["status"] as! Bool == false {
                        self.view.hideHUD()
                        if dictobj["message"] as? String == "Unauthorized" {
                            self.showUnauthorizedAlert(title: "Alert", message: dictobj["message"] as? String)
                        }else{
                            self.showAlert(title: "Alert", message: dictobj["message"] as? String)
                        }
                    } else {
                        let actionSheetController: UIAlertController = UIAlertController(title: "Alert", message: "Report details inserted successfully.", preferredStyle: .alert)
                        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
                            self.ReportReason_view.isHidden = true
                            self.Report_view.isHidden = true
                            
                            self.dismiss(animated: true, completion: nil)
                        }
                        actionSheetController.addAction(cancelAction)
                        self.present(actionSheetController, animated: true, completion: nil)
                        self.view.hideHUD()
                        print(json)
                        // self.showAlert(title: "Alert", message: json["message"] as? String)
                        //     self.dismiss(animated: true, completion: nil)
                        
                        
                    }
                }else{
                    self.showAlert(title: "Alert", message: json["message"] as? String)
                }
            }else{
                self.showAlert(title: "", message: "Data not found.")
            }
        }
    }
    /* Report Challange */
    
    internal func ReportChallangeViewApiCall() {
        if (self.activeFollowerchallenges != nil) {
         reportedChallenge_id =  self.activeFollowerchallenges.challengeId
        }; if (self.activeDiscovey != nil) {
            reportedChallenge_id =  self.activeDiscovey.challengeId
        }
        
        let params = ["report_type":VersManager.share.changeReportParamsChallange.reportType,"reported_by_userid":VersManager.share.userLogin?.data.first?.id ?? 0,"report_reason":VersManager.share.changeReportParams.reportReason,"reported_user_id":VersManager.share.changeReportParams.reported_user_id, "reported_video_id": "", "reported_challenge_id" : reportedChallenge_id] as [String : Any]
        
        
        
        print(params)
        
        self.view.showHUD()
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.reports) { (JSON: Any?, _: URLResponse?, _: Error?) in
            self.view.hideHUD()
            if let json = JSON as? JSONDictionary {
                print(json)
                if let dictobj = json["meta"] as? JSONDictionary {
                    if dictobj["status"] as! Bool == false {
                        self.view.hideHUD()
                        if dictobj["message"] as? String == "Unauthorized" {
                            self.showUnauthorizedAlert(title: "Alert", message: dictobj["message"] as? String)
                        }else{
                            self.showAlert(title: "Alert", message: dictobj["message"] as? String)
                            
                        }
                    } else {
                        let actionSheetController: UIAlertController = UIAlertController(title: "Alert", message: "Report Challenge details inserted successfully.", preferredStyle: .alert)
                        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
                            self.ReportReason_view.isHidden = true
                            self.Report_view.isHidden = true
                            
                            self.dismiss(animated: true, completion: nil)
                        }
                        actionSheetController.addAction(cancelAction)
                        self.present(actionSheetController, animated: true, completion: nil)
                        self.view.hideHUD()
                        print(json)
                        //    self.showAlert(title: "Alert", message: json["message"] as? String)
                        
                    }
                }else{
                    self.showAlert(title: "Alert", message: json["message"] as? String)
                }
            }else{
                self.showAlert(title: "", message: "Data not found.")
            }
        }
    }
    
    internal func ReportChallangeViewApiCall1() {
        
        if (self.activeFollowerchallenges != nil) {
            reportedChallenge_id =  self.activeFollowerchallenges.challengeId
        }; if (self.activeDiscovey != nil) {
            reportedChallenge_id =  self.activeDiscovey.challengeId
        }
        let params = ["report_type":VersManager.share.changeReportParamsChallange1.reportType,"reported_by_userid":VersManager.share.userLogin?.data.first?.id ?? 0,"report_reason":VersManager.share.changeReportParamsChallange1.reportReason,"reported_user_id":VersManager.share.changeReportParams.reported_user_id, "reported_video_id": "", "reported_challenge_id" : reportedChallenge_id] as [String : Any]
        
        print(params)
        
        self.view.showHUD()
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.reports) { (JSON: Any?, _: URLResponse?, _: Error?) in
            self.view.hideHUD()
            if let json = JSON as? JSONDictionary {
                print(json)
                if let dictobj = json["meta"] as? JSONDictionary {
                    if dictobj["status"] as! Bool == false {
                        self.view.hideHUD()
                        if dictobj["message"] as? String == "Unauthorized" {
                            self.showUnauthorizedAlert(title: "Alert", message: dictobj["message"] as? String)
                        }else{
                            self.showAlert(title: "Alert", message: dictobj["message"] as? String)
                        }
                    } else {
                        let actionSheetController: UIAlertController = UIAlertController(title: "Alert", message: "Report Challenge details inserted successfully.", preferredStyle: .alert)
                        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
                            self.ReportReason_view.isHidden = true
                            self.Report_view.isHidden = true
                            
                            self.dismiss(animated: true, completion: nil)
                        }
                        actionSheetController.addAction(cancelAction)
                        self.present(actionSheetController, animated: true, completion: nil)
                        self.view.hideHUD()
                        print(json)
                        // self.showAlert(title: "Alert", message: json["message"] as? String)
                        //     self.dismiss(animated: true, completion: nil)
                        
                        
                    }
                }else{
                    self.showAlert(title: "Alert", message: json["message"] as? String)
                }
            }else{
                self.showAlert(title: "", message: "Data not found.")
            }
        }
        
      
}
}
