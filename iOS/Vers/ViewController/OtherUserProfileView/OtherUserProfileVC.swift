//
//  OtherUserProfileVC.swift
//  Vers
//
//  Created by pawan.sharma on 29/03/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit

class OtherUserProfileVC: UIViewController {
    
    @IBOutlet var blackContentView: UIView!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var activeuserCollection: UICollectionView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblWin: UILabel!
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var contentViewBottom: NSLayoutConstraint!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var button_UnFollow : UIButton!
     @IBOutlet weak var button_Report : UIButton!
    @IBOutlet weak var button_Block : UIButton!
    @IBOutlet var view_Private: UIView!
    @IBOutlet weak var lblPrivateWin: UILabel!
    @IBOutlet weak var lblPrivateFollowers: UILabel!
    @IBOutlet weak var lblPrivateFollowing: UILabel!
    @IBOutlet weak var lblPrivateName: UILabel!
    @IBOutlet weak var lblPrivateAddress: UILabel!
    @IBOutlet weak var imgViewPrivateProfile: UIImageView!


    
    @IBOutlet var view_report: UIView!
    @IBOutlet var view_report1: UIView!

    var user_id:Int!
    var activevers:Activevers?
    var userWins:UserWins?
    var userFollower:UserFollowers?
    var userFollowing:UserFollowing?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view_report.isHidden = true
        self.view_report1.isHidden = true
        configuration()
       view_Private.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
        self.navigationItem.title = "Profile"
        DispatchQueue.main.async {
            self.featchUserInfoApiCall()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            self.activeVerusApiCall()
        })
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if DeviceType.IS_IPHONE_5 {
            //scrollview.contentInset = UIEdgeInsetsMake(0, 0,74, 0)
            scrollview.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height+80)
            //self.contentViewBottom.constant = (self.scrollview.contentSize.height/4)
        }else{
            //            scrollview.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height+100)
            //            self.contentViewBottom.constant = (self.scrollview.contentSize.height/4)
        }
    }

    
    func configuration()  {
        blackContentView.layer.cornerRadius = 10
        blackContentView.layer.masksToBounds = true
        
        imgViewProfile.layer.cornerRadius = imgViewProfile.frame.size.height/2
        imgViewProfile.layer.masksToBounds = true
        imgViewProfile.layer.borderWidth = 2
        imgViewProfile.layer.borderColor = UIColor(red: 255.0/255.0, green: 56/255.0, blue: 57/255.0, alpha: 1.0).cgColor
        
        
        activeuserCollection.register(UINib(nibName: ActiveUserCollectionViewCell.stringRepresentation, bundle: nil), forCellWithReuseIdentifier: ActiveUserCollectionViewCell.stringRepresentation)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        activeuserCollection.collectionViewLayout = layout
        
    }
    
    func setUserData()  {
        
         if (VersManager.share.profileInfo.userData.userProfileSettings == "private" && VersManager.share.profileInfo.userData.follow_status == "") {
          view_Private.isHidden = false 
        }
        
        if VersManager.share.profileInfo != nil {
            imgViewProfile.sd_setImage(with: URL(string: VersManager.share.profileInfo.userData.userProfileImagePath.absoluteString), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            lblName.text = VersManager.share.profileInfo.userData.name
            lblAddress.text = VersManager.share.profileInfo.userData.userLocation
            lblWin.text = VersManager.share.profileInfo.userData.winCount.toString
            lblFollowers.text = VersManager.share.profileInfo.userData.followersCount.toString
            lblFollowing.text = VersManager.share.profileInfo.userData.followingCount.toString
        }
        
    }
    
    @IBAction func btnMoreAction(sender:UIButton) {

        if VersManager.share.profileInfo.userData.follow_status == "" {
           
             button_UnFollow.isHidden = true
        }
        
        self.view_report.isHidden = false
   }
   
    @IBAction func button_wins(_ sender:UIButton) {
        
          if (VersManager.share.profileInfo.userData.userProfileSettings == "private") {
            
            if (VersManager.share.profileInfo.userData.follow_status == "") {
                self.view_Private.isHidden = false
            }
            
            return
        }
      userWinsApiCall()
    }
    
    @IBAction func button_followers(_ sender:UIButton) {
        
         if (VersManager.share.profileInfo.userData.userProfileSettings == "private") {
             self.view_Private.isHidden = false
        }
        userfollowersApiCall()
    }
    
    @IBAction func button_following(_ sender:UIButton) {
        if (VersManager.share.profileInfo.userData.userProfileSettings == "private") {
            self.view_Private.isHidden = false
        }
        userfollowingApiCall()
    }
    
    @IBAction func button_inappropirate(_ sender:UIButton) {
        ReportViewApiCall1()
    }
    
    @IBAction func button_crossreport(_ sender:UIButton) {
        self.view_report.isHidden = true
        self.view_report1.isHidden = true

    }
    
    
    @IBAction func button_spam(_ sender:UIButton) {
        ReportViewApiCall()

    }
    
    @IBAction func button_block(_ sender:UIButton) {
           blockApiCalling()
    }
    
    @IBAction func button_unfollow(_ sender:UIButton) {
        UnfollowApiCalling()
    }
    
    @IBAction func button_report(_ sender:UIButton) {
         self.view_report1.isHidden = false
        self.view_Private.isHidden = true
        
    }
    
    @IBAction func button_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func button_follow(_ sender:UIButton) {
       self.view_Private.isHidden = true
    }
    
  @IBAction func btnVers_Action(_ sender:UIButton) {
    let vc = VideoRecordingController(nibName: "VideoRecordingController", bundle: nil)
    vc.view.frame = self.view.bounds
    VersManager.share.isAcceptScreen = false
    self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnWFFAction(sender:UIButton) {
        var strtitle:String!
        if sender.tag == 1 {
            strtitle = "Wins"
        }else if sender.tag == 2 {
            strtitle = "Followers"
        }else {
            strtitle = "Following"
        }
        let vc = WffViewController.init(nibName: WffViewController.stringRepresentation, bundle: nil)
        vc.strTitle = strtitle
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    fileprivate func featchUserInfoApiCall() {
        self.view.showHUD()
        let params = ["user_id":user_id,"loggedin_userid":VersManager.share.userLogin?.data.first?.id ?? 0 ] as JSONDictionary
        print(params)
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.profile) { (JSON: Any?, _: URLResponse?, _: Error?) in
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
                        self.view.hideHUD()
                        print(json)
                        if DeviceType.IS_IPHONE_5 {
                            self.scrollview.contentInset = UIEdgeInsetsMake(0, 0,74, 0)
                        }else{
                            self.scrollview.contentInset = UIEdgeInsetsMake(0, 0,74, 0)
                        }
                        VersManager.share.profileInfo = ProfileInfo(json: json)
                        self.setUserData()
                    }
                }else{
                    self.showAlert(title: "Alert", message: json["message"] as? String)
                }
            }else{
                self.showAlert(title: "", message: "Data is not in correct format.")
            }
        }
    }
    
    
    fileprivate func activeVerusApiCall() {
        self.view.showHUD()
        let params = ["user_id":user_id] as JSONDictionary
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.activevers) { (JSON: Any?, _: URLResponse?, _: Error?) in
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
                        self.view.hideHUD()
                        print(json)
                        //                        if DeviceType.IS_IPHONE_5 {
                        //                            self.scrollview.contentInset = UIEdgeInsetsMake(0, 0,74, 0)
                        //                        }else{
                        //                            self.scrollview.contentInset = UIEdgeInsetsMake(0, 0,74, 0)
                        //                        }
                        self.activevers = Activevers(json: (json))
                        self.activeuserCollection.reloadData()
                    }
                }else{
                    self.showAlert(title: "Alert", message: json["message"] as? String)
                }
            }else{
                self.showAlert(title: "", message: "Data is not in correct format.")
            }
        }
    }
}

extension OtherUserProfileVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.activevers != nil {
            return (self.activevers?.challengeDetails.count)!
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.activeuserCollection.dequeueReusableCell(withReuseIdentifier: ActiveUserCollectionViewCell.stringRepresentation, for: indexPath) as! ActiveUserCollectionViewCell
        let data = self.activevers?.challengeDetails[indexPath.row];
        cell.imgViewProfile.sd_setImage(with: data?.receiverVideoDetails.first?.userProfileImagePath, placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
        cell.lblName.text = data?.receiverVideoDetails.first?.name
        cell.lblWin.text = "\(data?.receiverVideoDetails.first?.receiverWins ?? 0) Wins"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthsize = self.activeuserCollection.frame.size.width/3
        let widthhight = self.activeuserCollection.frame.size.height
        return CGSize(width: widthsize, height: widthhight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
extension OtherUserProfileVC {
    
    fileprivate func userWinsApiCall() {
        self.view.showHUD()
        let params = ["user_id":user_id] as JSONDictionary
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.userwins) { (JSON: Any?, _: URLResponse?, _: Error?) in
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
                        self.view.hideHUD()
                        print(json)
                        self.userWins = UserWins(json: json)
                        
                    }
                }else{
                    self.showAlert(title: "Alert", message: json["message"] as? String)
                }
            }else{
                self.showAlert(title: "", message: "Data is not in correct format.")
            }
        }
    }
    
    fileprivate func userfollowersApiCall() {
        self.view.showHUD()
        let params = ["user_id":user_id] as JSONDictionary
        print(params)
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.followers) { (JSON: Any?, _: URLResponse?, _: Error?) in
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
                        self.view.hideHUD()
                        print(json)
                        self.userFollower = UserFollowers(json: json)
                        
                    }
                }else{
                    self.showAlert(title: "Alert", message: json["message"] as? String)
                }
            }else{
                self.showAlert(title: "", message: "Data is not in correct format.")
            }
        }
    }
    
    
    fileprivate func userfollowingApiCall() {
        self.view.showHUD()
        let params = ["user_id":user_id ?? 0] as JSONDictionary
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.followingusers) { (JSON: Any?, _: URLResponse?, _: Error?) in
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
                        self.view.hideHUD()
                        print(json)
                        self.userFollowing = UserFollowing(json: json)
                        
                    }
                }else{
                    self.showAlert(title: "Alert", message: json["message"] as? String)
                }
            }else{
                self.showAlert(title: "", message: "Data is not in correct format.")
            }
        }
    }
    
    internal func ReportViewApiCall() {
        let params = ["report_type":VersManager.share.changeUserParam2.reportType,"reported_by_userid":VersManager.share.userLogin?.data.first?.id ?? 0,"report_reason":VersManager.share.changeUserParam2.reportReason,"reported_user_id":user_id, "reported_video_id": VersManager.share.changeUserParam2.reported_video_id, "reported_challenge_id" : VersManager.share.changeUserParam2.reported_challenge_id] as [String : Any]
        
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
                            
                            self.view_report1.isHidden = true
                            self.view_report.isHidden = true

//                            self.ReportReason_view.isHidden = true
//                            self.Report_view.isHidden = true
                            
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
   let params = ["report_type":VersManager.share.changeUsersParams1.reportType,"reported_by_userid":VersManager.share.userLogin?.data.first?.id ?? 0,"report_reason":VersManager.share.changeUsersParams1.reportReason,"reported_user_id":user_id, "reported_video_id": VersManager.share.changeUsersParams1.reported_video_id, "reported_challenge_id" : VersManager.share.changeUsersParams1.reported_challenge_id] as [String : Any]
        
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
//                            self.ReportReason_view.isHidden = true
//                            self.Report_view.isHidden = true
                            self.view_report1.isHidden = true
                            self.view_report.isHidden = true
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
   
    internal func UnfollowApiCalling() {
        let params = ["following_user_id":user_id,"follower_id":VersManager.share.userLogin?.data.first?.id ?? 0] as [String : Any]
        
        print(params)
        
        self.view.showHUD()
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.unfollow) { (JSON: Any?, _: URLResponse?, _: Error?) in
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
                     //       self.dismiss(animated: true, completion: nil)
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
    
    internal func blockApiCalling() {
        let params = ["block_to_userid":user_id,"blocked_by_userid":VersManager.share.userLogin?.data.first?.id ?? 0] as [String : Any]
        
        print(params)
        
        self.view.showHUD()
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.block) { (JSON: Any?, _: URLResponse?, _: Error?) in
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
                           // self.dismiss(animated: true, completion: nil)
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
