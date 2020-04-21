//
//  VersusViewController.swift
//  Vers
////  Created by sagar.gupta on 23/02/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VersusViewController: UIViewController {
    
    var received:ReceivedView!
    var sentView:SentVersView!
    
    @IBOutlet weak var btnSent: UIButton!
    @IBOutlet weak var btnSentBGImageVW: UIImageView!
    @IBOutlet weak var btnReceivedBGImageVW: UIImageView!
    @IBOutlet weak var btnRecived: UIButton!
    let playerViewController = AVPlayerViewController()
    var voteVW:UIView!
    var changeRecipientVW:UIView!
    var vetoRecipientVW:UIView!
    var challengeID:Int!
    var indxpath:IndexPath!
    var sentIndexPath:IndexPath!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configuration()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        self.navigationItem.title = "Versus"
        self.addMenuButton(image: "menu")
      //  let searchImg = UIImage(named: "search")
        navigationItem.hidesBackButton = true
//        let btnsearch = UIBarButtonItem(image: searchImg, style: UIBarButtonItemStyle.plain, target:
//            self, action: #selector(getCurrentDateTime))
//        btnsearch.tintColor = UIColor.white
//        navigationItem.rightBarButtonItem = btnsearch
        featchReceivedversApiCall()
        //featchReplyversApiCall()
    }
    
    func configuration() {
        received = (ReceivedView.instanceFromNib() as! ReceivedView)
        
        let window = UIApplication.shared.keyWindow
        let topPadding = window?.safeAreaInsets.top ?? CGFloat(0)
        let yPosition = (self.navigationController?.navigationBar.frame.height ?? CGFloat(0)) + 60 + topPadding
        
//         if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
//             received.frame = CGRect(x: 0, y: 250, width: self.view.frame.width, height: self.view.frame.height-250)
//        }
        received.frame = CGRect(x: 0, y: yPosition, width: self.view.frame.width, height: self.view.frame.height-yPosition)
        received.delegate = self
        self.view.addSubview(received)
        
        sentView = (SentVersView.instanceFromNib() as! SentVersView)
        
//        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
//            sentView.frame = CGRect(x: 0, y: 250, width: self.view.frame.width, height: self.view.frame.height-250)
//        }
        
        sentView.frame = CGRect(x: 0, y: yPosition, width: self.view.frame.width, height: self.view.frame.height-yPosition)
        sentView.isHidden = true
        sentView.delegate = self
        self.view.addSubview(sentView)
        btnSentBGImageVW.image = #imageLiteral(resourceName: "blackellipse")
        btnSentBGImageVW.isHidden = true
        btnReceivedBGImageVW.image = #imageLiteral(resourceName: "blackellipse")
    }
    
    @IBAction func btnSentAction(sender:UIButton) {
        btnSentBGImageVW.isHidden = false
        btnReceivedBGImageVW.isHidden = true
        received.isHidden = true
        sentView.isHidden = false
        featchSentversApiCall()
    }
    
    @IBAction func btnRecivedAction(sender:UIButton) {
        btnReceivedBGImageVW.isHidden = false
        btnSentBGImageVW.isHidden = true
        sentView.isHidden = true
        received.isHidden = false
        featchReceivedversApiCall()
        //featchReplyversApiCall()
    }
    
    fileprivate func featchSentversApiCall() {
        self.view.showHUD()
        let params = ["user_id":VersManager.share.userLogin?.data.first?.id ?? 0] as JSONDictionary
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.sentvers) { (JSON: Any?, _: URLResponse?, _: Error?) in
            self.view.hideHUD()
            if let json = JSON as? JSONDictionary {
                print(json)
                if let dictobj = json["meta"] as? JSONDictionary {
                    if dictobj["status"] as! Bool == false {
                        self.view.hideHUD()
                        VersManager.share.versSent = nil
                        self.featchReactedVersApiCall()
                        if dictobj["message"] as? String == "Unauthorized" {
                            self.showUnauthorizedAlert(title: "Alert", message: dictobj["message"] as? String)
                        }else{
                            self.showAlert(title: "Alert", message: dictobj["message"] as? String)
                        }
                    } else {
                        self.view.hideHUD()
                        print(json)
                        VersManager.share.versSent = VersSentList(json: json)
                        self.featchReactedVersApiCall()
                    }
                }else{
                    self.featchReactedVersApiCall()
                    self.showAlert(title: "Alert", message: json["message"] as? String)
                }
            }else{
                self.featchReactedVersApiCall()
                self.showAlert(title: "", message: "Data is not in correct format.")
            }
        }
    }
    
    
    fileprivate func featchReactedVersApiCall() {
        //self.view.showHUD()
        let params = ["user_id":VersManager.share.userLogin?.data.first?.id ?? 0] as JSONDictionary
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.reactedvers) { (JSON: Any?, _: URLResponse?, _: Error?) in
            self.view.hideHUD()
            if let json = JSON as? JSONDictionary {
                print(json)
                if let dictobj = json["meta"] as? JSONDictionary {
                    if dictobj["status"] as! Bool == false {
                        self.view.hideHUD()
                        VersManager.share.reactVers = nil
                        self.sentView.reloadSentVers()
                        if dictobj["message"] as? String == "Unauthorized" {
                            self.showUnauthorizedAlert(title: "Alert", message: dictobj["message"] as? String)
                        }else{
                            //self.showAlert(title: "Alert", message: dictobj["message"] as? String)
                        }
                    } else {
                        //self.view.hideHUD()
                        print(json)
                        VersManager.share.reactVers = SentReactvers(json: json)
                        self.sentView.reloadSentVers()
                    }
                }else{
                    self.sentView.reloadSentVers()
                    //self.showAlert(title: "Alert", message: json["message"] as? String)
                }
            }else{
                //self.showAlert(title: "", message: "Data is not in correct format.")
            }
        }
    }
    
    
    fileprivate func featchReceivedversApiCall() {
        self.view.showHUD()
        let params = ["user_id":VersManager.share.userLogin?.data.first?.id ?? 0] as JSONDictionary
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.receivedvers) { (JSON: Any?, _: URLResponse?, _: Error?) in
            self.view.hideHUD()
            if let json = JSON as? JSONDictionary {
                print(json)
                if let dictobj = json["meta"] as? JSONDictionary {
                    if dictobj["status"] as! Bool == false {
                        VersManager.share.versReceived = nil
                        self.featchReplyversApiCall()
                        self.view.hideHUD()
                        self.showAlert(title: "Alert", message: dictobj["message"] as? String)
                    } else {
                        self.view.hideHUD()
                        print(json)
                        VersManager.share.versReceived = VersReceivedList(json: json)
                        //self.received.reloadReceivedVers()
                        self.featchReplyversApiCall()
                    }
                }else{
                    self.showAlert(title: "Alert", message: json["message"] as? String)
                }
                
            }else{
                self.showAlert(title: "", message: "Data is not in correct format.")
            }
        }
       
    }
    
    fileprivate func featchReplyversApiCall() {
        //self.view.showHUD()
        let params = ["user_id":VersManager.share.userLogin?.data.first?.id ?? 0] as JSONDictionary
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.fetchVersReplies) { (JSON: Any?, _: URLResponse?, _: Error?) in
            self.view.hideHUD()
            if let json = JSON as? JSONDictionary {
                print(json)
                if let dictobj = json["meta"] as? JSONDictionary {
                    if dictobj["status"] as! Bool == false {
                        self.view.hideHUD()
                        VersManager.share.versRepliedList = nil
                        self.received.reloadReceivedVers()
                        //self.showAlert(title: "Alert", message: dictobj["message"] as? String)
                    } else {
                        //self.view.hideHUD()
                        print(json)
                        VersManager.share.versRepliedList = VersRepliedList(json: json)
                        self.received.reloadReceivedVers()
                    }
                }else{
                    //self.showAlert(title: "Alert", message: json["message"] as? String)
                }
                
            }else{
                //self.showAlert(title: "", message: "Data is not in correct format.")
            }
        }
    }
    
    fileprivate func postChallengeApiCall() {
        self.view.showHUD()
        let params = ["challenge_id":challengeID] as JSONDictionary
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.postchallenge) { (JSON: Any?, _: URLResponse?, _: Error?) in
            self.view.hideHUD()
            if let json = JSON as? JSONDictionary {
                print(json)
                let dictobj = json["meta"] as! JSONDictionary
                if dictobj["status"] as! Bool == false {
                    self.view.hideHUD()
                    if dictobj["message"] as? String == "Unauthorized" {
                        self.showUnauthorizedAlert(title: "Alert", message: dictobj["message"] as? String)
                    }else{
                        self.showAlert(title: "Alert", message: dictobj["message"] as? String)
                    }
                } else {
                    self.view.hideHUD()
                    print(json)
                }
            }else{
                self.showAlert(title: "", message: "Data is not in correct format.")
            }
        }
        //featchReceivedversApiCall()
    }
    
    fileprivate func vetoChallengeApiCall() {
        self.view.showHUD()
        let params = ["challenge_id":challengeID] as JSONDictionary
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.vetochallenge) { (JSON: Any?, _: URLResponse?, _: Error?) in
            self.view.hideHUD()
            if let json = JSON as? JSONDictionary {
                print(json)
                let dictobj = json["meta"] as! JSONDictionary
                if dictobj["status"] as! Bool == false {
                    self.view.hideHUD()
                    if dictobj["message"] as? String == "Unauthorized" {
                        self.showUnauthorizedAlert(title: "Alert", message: dictobj["message"] as? String)
                    }else{
                        self.showAlert(title: "Alert", message: dictobj["message"] as? String)
                    }
                } else {
                    self.view.hideHUD()
                    let alert = UIAlertController(title: "", message: dictobj["message"] as? String ?? "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                        self.navigateToBackScreen()
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion:nil)
                }
            }else{
                self.showAlert(title: "", message: "Data is not in correct format.")
            }
        }
    }
    
    fileprivate func declineChallengeApiCall() {
        self.view.showHUD()
        let params = ["challenge_id":challengeID,"challenge_status":"declined","receiver_id":VersManager.share.userLogin?.data.first?.id ?? 0] as JSONDictionary
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.declinechallenge) { (JSON: Any?, _: URLResponse?, _: Error?) in
            self.view.hideHUD()
            if let json = JSON as? JSONDictionary {
                print(json)
                let dictobj = json["meta"] as! JSONDictionary
                if dictobj["status"] as! Bool == false {
                    self.view.hideHUD()
                    if dictobj["message"] as? String == "Unauthorized" {
                        self.showUnauthorizedAlert(title: "Alert", message: dictobj["message"] as? String)
                    }else{
                        self.showAlert(title: "Alert", message: dictobj["message"] as? String)
                    }
                } else {
                    self.view.hideHUD()
                    print(json)
                    let alert = UIAlertController(title: "", message: dictobj["message"] as? String ?? "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                        self.navigateToBackScreen()
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion:nil)
                }
            }else{
                self.showAlert(title: "", message: "Data is not in correct format.")
            }
        }
    }
    
    
}

extension VersusViewController:ReceivedViewDelegate {
    func seletedUser(indx: IndexPath) {
        var videoUrl:URL!
        indxpath = indx
        if indx.section == 0 {
            videoUrl = VersManager.share.versRepliedList.data[indx.row].videoPath
            challengeID = VersManager.share.versRepliedList.data[indx.row].challengeId
            VersManager.share.acceptChallengeID = challengeID
        }else{
            videoUrl = VersManager.share.versReceived.data[indx.row].videoPath
            challengeID = VersManager.share.versReceived.data[indx.row].challengeId
            VersManager.share.acceptChallengeID = challengeID
        }
        let videoURL = URL(string: (videoUrl.absoluteString))
        let player = AVPlayer(url: videoURL!)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(note:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        playerViewController.delegate = self
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            self.playerViewController.player!.play()
        }
    }
    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("Video Finished")
        if indxpath.section == 0 {
            setupPostView()
        }else{
            setupAcceptView()
        }
        
    }
    
    func setupPostView() {
        let touchVoteVW = UITapGestureRecognizer(target: self, action: #selector(voteViewRemove))
        voteVW = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        voteVW.layer.cornerRadius = 10
        voteVW.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        let contentVW = UIView(frame: CGRect(x: (self.view.frame.width-200)/2, y: (self.view.frame.height-120)/2, width: 200, height: 120))
        contentVW.backgroundColor = UIColor.white
        contentVW.layer.cornerRadius = 10
        let btnPost = UIButton(frame: CGRect(x: 0, y:10, width: contentVW.frame.size.width, height: 50))
        btnPost.setTitle("Post", for: .normal)
        btnPost.setTitleColor(UIColor.lightGray, for: .normal)
        btnPost.titleLabel?.font = UIFont(name: "Rubik-Medium", size: 17.0)
        let bottomBorder1 = UIView(frame: CGRect(x: 0, y: btnPost.frame.size.height - 1.0, width: btnPost.frame.size.width, height: 1))
        btnPost.addTarget(self, action: #selector(postAction), for: .touchUpInside)
        bottomBorder1.backgroundColor = UIColor.lightGray
        btnPost.addSubview(bottomBorder1)
        contentVW.addSubview(btnPost)
        let btnVeto = UIButton(frame: CGRect(x: 0, y:btnPost.frame.size.height+10, width: contentVW.frame.size.width, height: 50))
        btnVeto.setTitle("Veto", for: .normal)
        btnVeto.addTarget(self, action: #selector(vetoAction), for: .touchUpInside)
        btnVeto.setTitleColor(UIColor.lightGray, for: .normal)
        btnVeto.titleLabel?.font = UIFont(name: "Rubik-Medium", size: 17.0)
        contentVW.addSubview(btnVeto)
        voteVW.addGestureRecognizer(touchVoteVW)
        voteVW.addSubview(contentVW)
        self.playerViewController.view.addSubview(voteVW)
    }
    
    func setupAcceptView() {
        let touchVoteVW = UITapGestureRecognizer(target: self, action: #selector(voteViewRemove))
        voteVW = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        voteVW.layer.cornerRadius = 10
        voteVW.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        let contentVW = UIView(frame: CGRect(x: (self.view.frame.width-250)/2, y: (self.view.frame.height-160)/2, width: 250, height: 160))
        contentVW.backgroundColor = UIColor.white
        contentVW.layer.cornerRadius = 10
        let btnAccept = UIButton(frame: CGRect(x: 0, y:10, width: contentVW.frame.size.width, height: 50))
        btnAccept.setTitle("Accept", for: .normal)
        btnAccept.setTitleColor(UIColor.lightGray, for: .normal)
        btnAccept.titleLabel?.font = UIFont(name: "Rubik-Medium", size: 17.0)
        let bottomBorder1 = UIView(frame: CGRect(x: 0, y: btnAccept.frame.size.height - 1.0, width: btnAccept.frame.size.width, height: 1))
        btnAccept.addTarget(self, action: #selector(acceptAction), for: .touchUpInside)
        bottomBorder1.backgroundColor = UIColor.lightGray
        btnAccept.addSubview(bottomBorder1)
        contentVW.addSubview(btnAccept)
        
        let btnDecline = UIButton(frame: CGRect(x: 0, y:btnAccept.frame.size.height+10, width: contentVW.frame.size.width, height: 50))
        btnDecline.setTitle("Decline", for: .normal)
        btnDecline.addTarget(self, action: #selector(declineAction), for: .touchUpInside)
        btnDecline.setTitleColor(UIColor.lightGray, for: .normal)
        btnDecline.titleLabel?.font = UIFont(name: "Rubik-Medium", size: 17.0)
        let bottomBorder2 = UIView(frame: CGRect(x: 0, y: btnDecline.frame.size.height - 1.0, width: btnDecline.frame.size.width, height: 1))
        bottomBorder2.backgroundColor = UIColor.lightGray
        btnDecline.addSubview(bottomBorder2)
        contentVW.addSubview(btnDecline)
        
        let btnClose = UIButton(frame: CGRect(x: 0, y:btnDecline.frame.size.height+btnDecline.frame.origin.y, width: contentVW.frame.size.width, height: 50))
        btnClose.setTitle("Close", for: .normal)
        btnClose.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        btnClose.setTitleColor(UIColor.lightGray, for: .normal)
        btnClose.titleLabel?.font = UIFont(name: "Rubik-Medium", size: 17.0)
        contentVW.addSubview(btnClose)
        voteVW.addGestureRecognizer(touchVoteVW)
        voteVW.addSubview(contentVW)
        self.playerViewController.view.addSubview(voteVW)
    }
    
    func setupVetoedView() {
        let touchVoteVW = UITapGestureRecognizer(target: self, action: #selector(vetoRecipientVWVWRemove))
        vetoRecipientVW = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        vetoRecipientVW.layer.cornerRadius = 10
      
        vetoRecipientVW.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        let contentVW = UIView(frame: CGRect(x: (self.view.frame.width-250)/2, y: (self.view.frame.height-160)/2, width: 250, height: 160))
        contentVW.backgroundColor = UIColor.white
        contentVW.layer.cornerRadius = 10
        let btnViewVideo = UIButton(frame: CGRect(x: 0, y:10, width: contentVW.frame.size.width, height: 50))
        btnViewVideo.setTitle("View Video", for: .normal)
        btnViewVideo.setTitleColor(UIColor.lightGray, for: .normal)
        btnViewVideo.titleLabel?.font = UIFont(name: "Rubik-Medium", size: 17.0)
        let bottomBorder1 = UIView(frame: CGRect(x: 0, y: btnViewVideo.frame.size.height - 1.0, width: btnViewVideo.frame.size.width, height: 1))
        btnViewVideo.addTarget(self, action: #selector(viewVideoAction), for: .touchUpInside)
        bottomBorder1.backgroundColor = UIColor.lightGray
        btnViewVideo.addSubview(bottomBorder1)
        contentVW.addSubview(btnViewVideo)
        
        let btnDropChallenge = UIButton(frame: CGRect(x: 0, y:btnViewVideo.frame.size.height+10, width: contentVW.frame.size.width, height: 50))
        btnDropChallenge.setTitle("Drop Challenge?", for: .normal)
        btnDropChallenge.addTarget(self, action: #selector(dropChallenge), for: .touchUpInside)
        btnDropChallenge.setTitleColor(UIColor.lightGray, for: .normal)
        btnDropChallenge.titleLabel?.font = UIFont(name: "Rubik-Medium", size: 17.0)
        let bottomBorder2 = UIView(frame: CGRect(x: 0, y: btnDropChallenge.frame.size.height - 1.0, width: btnDropChallenge.frame.size.width, height: 1))
        bottomBorder2.backgroundColor = UIColor.lightGray
        btnDropChallenge.addSubview(bottomBorder2)
        contentVW.addSubview(btnDropChallenge)
        
        let btnTryAgain = UIButton(frame: CGRect(x: 0, y:btnDropChallenge.frame.size.height+btnDropChallenge.frame.origin.y, width: contentVW.frame.size.width, height: 50))
        btnTryAgain.setTitle("Try again?", for: .normal)
        btnTryAgain.addTarget(self, action: #selector(tryagainAction), for: .touchUpInside)
        btnTryAgain.setTitleColor(UIColor.lightGray, for: .normal)
        btnTryAgain.titleLabel?.font = UIFont(name: "Rubik-Medium", size: 17.0)
        contentVW.addSubview(btnTryAgain)
        vetoRecipientVW.addGestureRecognizer(touchVoteVW)
        vetoRecipientVW.addSubview(contentVW)
        self.view.addSubview(vetoRecipientVW)
    }
    
    func setupChangeRecipientView() {
        let touchVoteVW = UITapGestureRecognizer(target: self, action: #selector(changeRecipientVWRemove))
        changeRecipientVW = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
          changeRecipientVW.layer.cornerRadius = 10
        changeRecipientVW.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        let contentVW = UIView(frame: CGRect(x: (self.view.frame.width-250)/2, y: (self.view.frame.height-160)/2, width: 250, height: 160))
        contentVW.backgroundColor = UIColor.white
      
        contentVW.layer.cornerRadius = 10
        let btnViewVideo = UIButton(frame: CGRect(x: 0, y:10, width: contentVW.frame.size.width, height: 50))
        btnViewVideo.setTitle("View Video", for: .normal)
        btnViewVideo.setTitleColor(UIColor.lightGray, for: .normal)
        btnViewVideo.titleLabel?.font = UIFont(name: "Rubik-Medium", size: 17.0)
        let bottomBorder1 = UIView(frame: CGRect(x: 0, y: btnViewVideo.frame.size.height - 1.0, width: btnViewVideo.frame.size.width, height: 1))
        btnViewVideo.addTarget(self, action: #selector(viewVideoAction), for: .touchUpInside)
        bottomBorder1.backgroundColor = UIColor.lightGray
        btnViewVideo.addSubview(bottomBorder1)
        contentVW.addSubview(btnViewVideo)
        
        let btnDropChallenge = UIButton(frame: CGRect(x: 0, y:btnViewVideo.frame.size.height+10, width: contentVW.frame.size.width, height: 50))
        btnDropChallenge.setTitle("Drop Challenge?", for: .normal)
        btnDropChallenge.addTarget(self, action: #selector(dropChallenge), for: .touchUpInside)
        btnDropChallenge.setTitleColor(UIColor.lightGray, for: .normal)
        
        btnDropChallenge.titleLabel?.font = UIFont(name: "Rubik-Medium", size: 17.0)
        let bottomBorder2 = UIView(frame: CGRect(x: 0, y: btnDropChallenge.frame.size.height - 1.0, width: btnDropChallenge.frame.size.width, height: 1))
        bottomBorder2.backgroundColor = UIColor.lightGray
        btnDropChallenge.addSubview(bottomBorder2)
        bottomBorder2.layer.cornerRadius = 10
        contentVW.addSubview(btnDropChallenge)
        
        let changeRecipient = UIButton(frame: CGRect(x: 0, y:btnDropChallenge.frame.size.height+btnDropChallenge.frame.origin.y, width: contentVW.frame.size.width, height: 50))
        changeRecipient.setTitle("Change Receipient?", for: .normal)
        changeRecipient.addTarget(self, action: #selector(changeRecipientAction), for: .touchUpInside)
        changeRecipient.setTitleColor(UIColor.lightGray, for: .normal)
        changeRecipient.titleLabel?.font = UIFont(name: "Rubik-Medium", size: 17.0)
        contentVW.addSubview(changeRecipient)
        changeRecipientVW.addGestureRecognizer(touchVoteVW)
        changeRecipientVW.addSubview(contentVW)
        self.view.addSubview(changeRecipientVW)
    }
    
    @objc func voteViewRemove() {
        voteVW.removeFromSuperview()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func changeRecipientVWRemove() {
        if  changeRecipientVW != nil {
            if self.view.subviews.contains(changeRecipientVW) {
                changeRecipientVW.removeFromSuperview()
            }
        }
        //self.dismiss(animated: true, completion: nil)
    }
    
    @objc func vetoRecipientVWVWRemove() {
        if vetoRecipientVW != nil {
            if self.view.subviews.contains(vetoRecipientVW) {
                vetoRecipientVW.removeFromSuperview()
            }
        }
        //self.dismiss(animated: true, completion: nil)
    }
    
    @objc func postAction()  {
        voteVW.removeFromSuperview()
        self.dismiss(animated: true) {
            self.postChallengeApiCall()
        }
    }
    
    @objc func vetoAction()  {
        voteVW.removeFromSuperview()
        self.dismiss(animated: true) {
            self.vetoChallengeApiCall()
        }
    }
    
    @objc func acceptAction()  {
        VersManager.share.isAcceptScreen = true
        voteVW.removeFromSuperview()
        self.dismiss(animated: false) {
            let vc = VideoRecordingController(nibName: "VideoRecordingController", bundle: nil)
            vc.view.frame = self.view.bounds
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func declineAction()  {
        voteVW.removeFromSuperview()
        self.dismiss(animated: true) {
            self.declineChallengeApiCall()
        }
    }
    
    @objc func closeAction()  {
        voteVW.removeFromSuperview()
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Alert", message: "You have 3 days to reply", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.dismiss(animated: true)
            NSLog("OK Pressed")
        }
      
        // Add the actions
        alertController.addAction(okAction)
       
        // Present the controller
        playerViewController.present(alertController, animated: true, completion: nil)
    
    }
    
    @objc func viewVideoAction() {
       vetoRecipientVWVWRemove()
        var videoUrl:URL!
        if sentIndexPath.section == 0 {
            videoUrl = VersManager.share.versSent.data[sentIndexPath.row].senderVideoPath
        }else if sentIndexPath.section == 1 {
            videoUrl = VersManager.share.reactVers.data[sentIndexPath.row].receiverVideoPath
        }
        let player = AVPlayer(url: videoUrl!)
        //            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(note:)),
        //                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        playerViewController.delegate = self
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            self.playerViewController.player!.play()
        }
    }
    
    @objc func changeRecipientAction() {
        changeRecipientVWRemove()
        var receiver_id:String!
        if self.sentIndexPath.section == 0 {
            VersManager.share.changeRecipientParams.challenge_id = VersManager.share.versSent.data[self.sentIndexPath.row].challengeId.toString
            VersManager.share.changeRecipientParams.receiver_id = VersManager.share.versSent.data[self.sentIndexPath.row].recieverId.toString
            VersManager.share.changeRecipientParams.sender_video_id = VersManager.share.versSent.data[self.sentIndexPath.row].senderVideoId.toString
            VersManager.share.changeRecipientParams.sender_id = VersManager.share.versSent.data[self.sentIndexPath.row].senderId.toString
            receiver_id = VersManager.share.versSent.data[self.sentIndexPath.row].recieverId.toString
        }else if self.sentIndexPath.section == 1 {
            VersManager.share.changeRecipientParams.challenge_id = VersManager.share.reactVers.data[self.sentIndexPath.row].challengeId.toString
            VersManager.share.changeRecipientParams.receiver_id = VersManager.share.reactVers.data[self.sentIndexPath.row].recieverId.toString
            VersManager.share.changeRecipientParams.sender_video_id = VersManager.share.reactVers.data[self.sentIndexPath.row].senderVideoId.toString
            VersManager.share.changeRecipientParams.sender_id = VersManager.share.reactVers.data[self.sentIndexPath.row].senderId.toString
            receiver_id = VersManager.share.reactVers.data[self.sentIndexPath.row].recieverId.toString
        }
        
        VersManager.share.isChangeRecipent = true
        let vc = SendToViewController.init(nibName: SendToViewController.stringRepresentation, bundle: nil)
        vc.status = "change_recipient"
        vc.receiver_id = receiver_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tryagainAction() {
        vetoRecipientVWVWRemove()
        if self.sentIndexPath.section == 0 {
            VersManager.share.tryagainParams.challenge_id = VersManager.share.versSent.data[self.sentIndexPath.row].challengeId.toString
            VersManager.share.tryagainParams.receiver_id = VersManager.share.versSent.data[self.sentIndexPath.row].recieverId.toString
            VersManager.share.tryagainParams.sender_id = VersManager.share.versSent.data[self.sentIndexPath.row].senderId.toString
        }else if self.sentIndexPath.section == 1 {
            VersManager.share.tryagainParams.challenge_id = VersManager.share.reactVers.data[self.sentIndexPath.row].challengeId.toString
            VersManager.share.tryagainParams.receiver_id = VersManager.share.reactVers.data[self.sentIndexPath.row].recieverId.toString
            VersManager.share.tryagainParams.sender_id = VersManager.share.reactVers.data[self.sentIndexPath.row].senderId.toString
        }
        VersManager.share.istryagain = true
        let vc = VideoRecordingController(nibName: "VideoRecordingController", bundle: nil)
        vc.view.frame = self.view.bounds
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func dropChallenge() {
       vetoRecipientVWVWRemove()
        let alert = UIAlertController(title: "", message: "Drop the challenge?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "YES", style: .default) { (UIAlertAction) in
            if self.sentIndexPath.section == 0 {
                self.dropChallengeApiCall(challenge_id: VersManager.share.versSent.data[self.sentIndexPath.row].challengeId.toString, dropped_by: "sender", user_id: VersManager.share.versSent.data[self.sentIndexPath.row].senderId.toString)
            }else if self.sentIndexPath.section == 1{
                self.dropChallengeApiCall(challenge_id: VersManager.share.reactVers.data[self.sentIndexPath.row].challengeId.toString, dropped_by: "sender", user_id: VersManager.share.reactVers.data[self.sentIndexPath.row].senderId.toString)
            }
        }
        let no = UIAlertAction(title: "NO", style: .default) { (UIAlertAction) in
    
        }
        alert.addAction(yes)
        alert.addAction(no)
        self.present(alert, animated: true, completion:nil)
    }
}

extension VersusViewController:AVPlayerViewControllerDelegate {
    
    
}

extension VersusViewController:SentVersViewDelegate {
    func changeRecipient(index: IndexPath) {
        sentIndexPath = index
        setupChangeRecipientView()
    }
    
    func tryAgain(index: IndexPath) {
        sentIndexPath = index
        setupVetoedView()
    }
}

extension VersusViewController {
    
    fileprivate func dropChallengeApiCall(challenge_id:String,dropped_by:String,user_id:String) {
        self.view.showHUD()
        let params = ["challenge_id":challenge_id,"dropped_by":dropped_by,"user_id":user_id] as JSONDictionary
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.dropchallenge) { (JSON: Any?, _: URLResponse?, _: Error?) in
            self.view.hideHUD()
            if let json = JSON as? JSONDictionary {
                print(json)
                let dictobj = json["meta"] as! JSONDictionary
                if dictobj["status"] as! Bool == false {
                    self.view.hideHUD()
                    if dictobj["message"] as? String == "Unauthorized" {
                        self.showUnauthorizedAlert(title: "Alert", message: dictobj["message"] as? String)
                    }else{
                        self.showAlert(title: "Alert", message: dictobj["message"] as? String)
                        self.received.tblReceived.reloadData()
                    }
                } else {
                   self.view.hideHUD()
                   self.showAlert(title: "Alert", message: dictobj["message"] as? String)
                    
                }
            }else{
                self.showAlert(title: "", message: "Data is not in correct format.")
            }
        }
    }
}
