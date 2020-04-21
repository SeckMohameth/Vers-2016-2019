//
//  ProfileViewController.swift
//  Vers
//
//  Created by sagar.gupta on 14/02/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var blackContentView: UIView!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var activeuserCollection: UICollectionView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSubHeadingName: UILabel!
    @IBOutlet weak var label_messageNorecord: UILabel!
    @IBOutlet weak var label_activeVers: UILabel!

    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblWin: UILabel!
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var contentViewBottom: NSLayoutConstraint!
    @IBOutlet weak var scrollview: UIScrollView!
    var activevers:Activevers?
    var delegate: ReceivedViewDelegate!
    var reciverVideopath:URL!
    var activeData : Activevers.ChallengeDetails!
    override func viewDidLoad() {
        super.viewDidLoad()
self.label_messageNorecord.isHidden = true
        // Do any additional setup after loading the view.
        configuration()
      //  featchUserInfoApiCall()
        self.label_activeVers.isHidden = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        self.navigationItem.title = "Profile"
        self.addMenuButton(image: "menu")
      // let saveImg = UIImage(named: "add")
//        navigationItem.hidesBackButton = true
      //  let savebtn = UIBarButtonItem(image: saveImg, style: UIBarButtonItemStyle.plain, target:self, action: #selector(saveUserInfo))
//        //255 56 77
       //savebtn.tintColor = UIColor(red: 255/255.0, green: 56/255.0, blue: 77/255.0, alpha: 1.0)
     //   navigationItem.rightBarButtonItem = savebtn
        DispatchQueue.main.async {
             self.featchUserInfoApiCall()
        }
       
        
       
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.activeVerusApiCall()
        })
        
    }
  //  @objc func saveUserInfo () {
        
    //    let userDetailVC = UsersDetailsVC(nibName: "UsersDetailsVC", bundle: nil)

      //  self.navigationController?.pushViewController(userDetailVC, animated: true)
        
        
    //}
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if DeviceType.IS_IPHONE_5 {
            //scrollview.contentInset = UIEdgeInsetsMake(0, 0,74, 0)
            scrollview.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height+80)
            self.contentViewBottom.constant = (self.scrollview.contentSize.height/4)
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
        if VersManager.share.profileInfo != nil {
            imgViewProfile.sd_setImage(with: URL(string: VersManager.share.profileInfo.userData.userProfileImagePath.absoluteString), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            lblName.text = VersManager.share.profileInfo.userData.userName
            lblSubHeadingName.text =  VersManager.share.profileInfo.userData.name
            lblAddress.text = VersManager.share.profileInfo.userData.userLocation
            lblWin.text = VersManager.share.profileInfo.userData.winCount.toString
            print(VersManager.share.profileInfo.userData.winCount.toString)
            lblFollowers.text = VersManager.share.profileInfo.userData.followersCount.toString
            lblFollowing.text = VersManager.share.profileInfo.userData.followingCount.toString
        }
        
    }
    
    @IBAction func btnEditAction(sender:UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: EditProfileViewController.stringRepresentation)
        self.navigationController?.pushViewController(vc!, animated: true)
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
        
        let params = ["user_id":VersManager.share.userLogin?.data.first?.id ?? 0] as JSONDictionary
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
                        
                        DispatchQueue.main.async {
                        VersManager.share.profileInfo = ProfileInfo(json: json)
                        
                           self.setUserData()
                        }
                        
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
        let params = ["user_id":VersManager.share.userLogin?.data.first?.id ?? 0] as JSONDictionary
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
                            self.label_messageNorecord.isHidden = false
                            
                            self.label_messageNorecord.text = "No active vers available"
                       //     self.showAlert(title: "Alert", message: dictobj["message"] as? String)
                        }
                    } else {
                        self.view.hideHUD()
                        print(json)
                           self.label_activeVers.isHidden = false
//                        if DeviceType.IS_IPHONE_5 {
//                            self.scrollview.contentInset = UIEdgeInsetsMake(0, 0,74, 0)
//                        }else{
//                            self.scrollview.contentInset = UIEdgeInsetsMake(0, 0,74, 0)
                     
//                        }
                         self.activevers = Activevers(json: (json))
                         self.activeuserCollection.reloadData()
                    }
                }else{
//                    self.label_messageNorecord.isHidden = false
//
//                    self.label_messageNorecord.text = "No Active Vers Available"
                  self.showAlert(title: "Alert", message: json["message"] as? String)
                }
            }else{
                self.showAlert(title: "", message: "Data is not in correct format.")
            }
        }
    }
    
    
}

extension ProfileViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
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
           if VersManager.share.userLogin?.data.first?.id != self.activevers?.challengeDetails[indexPath.row].senderVideoDetails.first?.userId {
            cell.lblName.text = self.activevers?.challengeDetails[indexPath.row].senderVideoDetails.first?.name
            cell.lblWin.text = "\(self.activevers?.challengeDetails[indexPath.row].senderVideoDetails.first?.senderWins ?? 0) Wins"
              cell.imgViewProfile.sd_setImage(with: self.activevers?.challengeDetails[indexPath.row].senderVideoDetails.first?.userProfileImagePath, placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
           } else if VersManager.share.userLogin?.data.first?.id != self.activevers?.challengeDetails[indexPath.row].receiverVideoDetails.first?.userId {
            cell.lblName.text = self.activevers?.challengeDetails[indexPath.row].receiverVideoDetails.first?.name
            cell.lblWin.text = "\(self.activevers?.challengeDetails[indexPath.row].receiverVideoDetails.first?.receiverWins ?? 0) Wins"
            cell.imgViewProfile.sd_setImage(with: self.activevers?.challengeDetails[indexPath.row].receiverVideoDetails.first?.userProfileImagePath, placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            
          

        }
      
         cell.button_video.tag = indexPath.row
         cell.button_otheruser.addTarget(self, action: #selector(ButtonTopTenstrkes(sender:)), for: UIControlEvents.touchUpInside)
          cell.button_video.addTarget(self, action: #selector(ButtonViedoPlayer(sender:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    @objc func ButtonTopTenstrkes(sender:UIButton) {
        var useid:Int
        let vc = OtherUserProfileVC.init(nibName: OtherUserProfileVC.stringRepresentation, bundle: nil)
        if VersManager.share.userLogin?.data.first?.id != self.activevers?.challengeDetails[sender.tag].senderVideoDetails.first?.userId {
            useid = (self.activevers?.challengeDetails[sender.tag].senderVideoDetails.first?.userId)!
        }else if VersManager.share.userLogin?.data.first?.id != self.activevers?.challengeDetails[sender.tag].receiverVideoDetails.first?.userId{
            useid = (self.activevers?.challengeDetails[sender.tag].receiverVideoDetails.first?.userId)!
        }else{
            return
        }
        vc.user_id = useid
     //   print(streaks.wonBy)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @objc func ButtonViedoPlayer (sender : UIButton) {
        var videoUrl:URL!
        let data = self.activevers?.challengeDetails[sender.tag]
        print(data?.senderVideoDetails.first?.videoPath ?? "")
        videoUrl = data?.senderVideoDetails.first?.videoPath
        reciverVideopath = data?.receiverVideoDetails.first?.videoPath
        activeData = data
        print(reciverVideopath)
        openVideoplayer(vidoUrl: videoUrl, isSender: false)
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        var videoUrl:URL!
//
//        let data = self.activevers?.challengeDetails[indexPath.row];
//        print(data?.senderVideoDetails.first?.videoPath)
//        videoUrl = data?.senderVideoDetails.first?.videoPath
//          reciverVideopath = data?.receiverVideoDetails.first?.videoPath
//            print(reciverVideopath)
//            openVideoplayer(vidoUrl: videoUrl, isSender: false)
//
//
//
//
//
//    }
    
    func openVideoplayer(vidoUrl:URL,isSender:Bool)  {
        let vcProfile = VideoPlayerView()
        vcProfile.videoUrl = vidoUrl
        vcProfile.isSender = isSender
        vcProfile.delegate = self
        vcProfile.profiledata = activeData
        self.present(vcProfile, animated: true)
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
extension ProfileViewController:VideoPlayerViewDelegate {
    
    func callagain(isreciver: Bool) {
        self.dismiss(animated: false, completion: nil)
        if isreciver {
            self.openVideoplayer(vidoUrl: reciverVideopath, isSender: true)
        }
}
}
