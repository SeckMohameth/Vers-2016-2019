//
//  NotificationViewController.swift
//  Vers
//
//  Created by sagar.gupta on 08/03/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var tblNotification: UITableView!
    let arrdata = ["Ammar,idk, Dom_dc, and 12 others voted on your challenge","Ammar,idk, Dom_dc, and 12 others voted on your challenge","Ammar,idk, Dom_dc, and 12 others voted on your challenge"]
    var notification: Notification?
    
    
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
        self.navigationItem.title = "Notification"
        self.backButton(image: "back")
        getAllNotificationApiCall()
        tblNotification.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if DeviceType.IS_IPHONE_5 {
            tblNotification.contentOffset = CGPoint(x: 0, y: -64)
        }
    }
    
    func configuration()  {
        tblNotification.register(UINib(nibName: SimpleNotificationTbCell.stringRepresentation, bundle: nil), forCellReuseIdentifier: SimpleNotificationTbCell.stringRepresentation)
        tblNotification.register(UINib(nibName: FollowAcceptTableViewCell.stringRepresentation, bundle: nil), forCellReuseIdentifier: FollowAcceptTableViewCell.stringRepresentation)
        tblNotification.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func getAllNotificationApiCall() {
        self.view.showHUD()
        
        let params = ["user_id":VersManager.share.userLogin?.data.first?.id ?? 0] as JSONDictionary
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.fetchNotifications) { (JSON: Any?, _: URLResponse?, _: Error?) in
            self.view.hideHUD()
            if let json = JSON as? JSONDictionary {
                print(json)
                if let dictobj = json["meta"] as? JSONDictionary {
                    if dictobj["status"] as! Bool == false {
                        self.view.hideHUD()
                        self.tblNotification.reloadData()
                        self.showAlert(title: "Alert", message: dictobj["message"] as? String)
                    } else {
                        self.view.hideHUD()
                        print(json)
                        self.notification = Notification(json: json)
                        self.tblNotification.reloadData()
                    }
                }else{
                    self.showAlert(title: "Alert", message: json["message"] as? String)
                }
            }else{
                self.showAlert(title: "", message: "Data not found.")
            }
        }
    }
    
    func acceptRejectFollowRequestApiCall(follow_id:String,follow_status:String,request_receiver_id:String) {
        let params = ["follow_id":follow_id,"follow_status":follow_status,"request_receiver_id":request_receiver_id]
        self.view.showHUD()
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.requeststatusupdate) { (JSON: Any?, _: URLResponse?, _: Error?) in
            self.view.hideHUD()
            if let json = JSON as? JSONDictionary {
                print(json)
                if let dictobj = json["meta"] as? JSONDictionary {
                    if dictobj["status"] as! Bool == false {
                        self.view.hideHUD()
                        self.tblNotification.reloadData()
                        self.showAlert(title: "Alert", message: dictobj["message"] as? String)
                    } else {
                        self.view.hideHUD()
                        print(json)
                        
                       self.showAlert(title: "Alert", message: dictobj["message"] as? String)
                        self.tblNotification.reloadData()
                    }
                }else{
                    self.showAlert(title: "Alert", message: json["message"] as? String)
                }
            }else{
                self.showAlert(title: "", message: "Data not found.")
            }
        }
    }
    
    @objc func btnAcceptAction(sender:UIButton) {
        let followid = self.notification?.followRequestNotifications[sender.tag].followRequestId.toString
        let recevierid = VersManager.share.userLogin?.data.first?.id ?? 0
        let status = "accepted"
        self.acceptRejectFollowRequestApiCall(follow_id: followid!, follow_status: status, request_receiver_id: recevierid.toString)
        
    }
    
    @objc func btnRejectAction(sender:UIButton) {
        let followid = self.notification?.followRequestNotifications[sender.tag].followRequestId.toString
        let recevierid = VersManager.share.userLogin?.data.first?.id ?? 0
        let status = "declined"
        self.acceptRejectFollowRequestApiCall(follow_id: followid!, follow_status: status, request_receiver_id: recevierid.toString)
    }
}

extension NotificationViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.notification != nil else {
            return 0
        }
        if section == 0 {
            return self.notification?.data.count ?? 0
        }else{
            return self.notification?.followRequestNotifications.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
//            let str = arrdata[indexPath.row]
//            let height = str.height(withConstrainedWidth: self.view.frame.size.width-40, font: UIFont(name: "Rubik-Regular", size: 15.0)!)
            return 95
        }else{
            return 150
        }
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SimpleNotificationTbCell.stringRepresentation) as! SimpleNotificationTbCell
        cell.selectionStyle = .none
        let cellAccept = tableView.dequeueReusableCell(withIdentifier: FollowAcceptTableViewCell.stringRepresentation) as! FollowAcceptTableViewCell
        cellAccept.selectionStyle = .none
        
        if indexPath.section == 0 {
            setNotificationData(cell: cell, indexPath: indexPath)
            return cell
        }else{
            setAeccptFollowNotification(cell: cellAccept, indexPath: indexPath)
            return cellAccept
        }
       
    }
    
    func setAeccptFollowNotification(cell:FollowAcceptTableViewCell,indexPath:IndexPath) {
        let strMessage = "\(self.notification?.followRequestNotifications[indexPath.row].followRequestSenderName ?? "") requested to follow you"
        cell.lblContent.text = strMessage
        cell.imgVwUser.sd_setImage(with: self.notification?.followRequestNotifications[indexPath.row].followRequestSenderProfileImage, placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
        cell.btnAccept.addTarget(self, action: #selector(btnAcceptAction(sender:)), for: .touchUpInside)
        cell.btnCancel.addTarget(self, action: #selector(btnRejectAction(sender:)), for: .touchUpInside)
        cell.btnAccept.tag = indexPath.row
        cell.btnCancel.tag = indexPath.row
    
        cell.lblTime.text = self.notification?.followRequestNotifications[indexPath.row].timeElapsed ?? ""

    }
    
    func setNotificationData(cell:SimpleNotificationTbCell,indexPath:IndexPath) {
        
        if self.notification?.data[indexPath.row].notificationType == "challenge_tie_notification" {
            let strMessage = "Tie against \(self.notification?.data[indexPath.row].challengeTiedReceiverUserName ?? "")"
            cell.lblContent.text = strMessage
            cell.imgVwUser.sd_setImage(with: URL(string: (self.notification?.data[indexPath.row].challengeAcceptedByUserProfileImage)!), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            cell.lblTime.text = self.notification?.data[indexPath.row].timeElapsed
        }
        
        if self.notification?.data[indexPath.row].notificationType == "challenge_accept_notification" {
            let strMessage = "\(self.notification?.data[indexPath.row].challengeAcceptedByUserName ?? "") accepted your challenge"
            cell.lblContent.text = strMessage
            cell.imgVwUser.sd_setImage(with: URL(string: (self.notification?.data[indexPath.row].challengeAcceptedByUserProfileImage)!), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            cell.lblTime.text = self.notification?.data[indexPath.row].timeElapsed ?? ""
        }
        
        if self.notification?.data[indexPath.row].notificationType == "challenge_decline_notification" {
            let strMessage = "\(self.notification?.data[indexPath.row].challengeDeclinedByUserName ?? "") has declined your challenge"
            cell.lblContent.text = strMessage
            cell.imgVwUser.sd_setImage(with: URL(string: (self.notification?.data[indexPath.row].challengeDeclinedByUserProfileImage)!), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            cell.lblTime.text = self.notification?.data[indexPath.row].timeElapsed ?? ""
        }
        
        if self.notification?.data[indexPath.row].notificationType == "vote_notification" {
            let strMessage = "\(self.notification?.data[indexPath.row].votedByUserName ?? "") is voted your challenge"
            cell.lblContent.text = strMessage
            cell.imgVwUser.sd_setImage(with: URL(string: (self.notification?.data[indexPath.row].votedByUserProfileImage)!), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            cell.lblTime.text = self.notification?.data[indexPath.row].timeElapsed
        }
        
        if self.notification?.data[indexPath.row].notificationType == "challenge_post_notification" {
            let strMessage = "Your challenge has been posted"
            cell.lblContent.text = strMessage
            cell.imgVwUser.sd_setImage(with: URL(string: (self.notification?.data[indexPath.row].challengeReceiverProfileImage)!), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            cell.lblTime.text = self.notification?.data[indexPath.row].timeElapsed ?? ""

        }
        
        if self.notification?.data[indexPath.row].notificationType == "challenge_win_notification" {
            let strMessage = "Won against \(self.notification?.data[indexPath.row].challengeLostByUserName ?? "")"
            cell.lblContent.text = strMessage
            cell.imgVwUser.image = #imageLiteral(resourceName: "win")
            cell.lblTime.text = self.notification?.data[indexPath.row].timeElapsed
        }
        
        if self.notification?.data[indexPath.row].notificationType == "challenge_lost_notification" {
            let strMessage = "Lost against \(self.notification?.data[indexPath.row].challengeWonByUserName ?? "")"
            cell.lblContent.text = strMessage
            cell.imgVwUser.image = #imageLiteral(resourceName: "loss")
            cell.lblTime.text = self.notification?.data[indexPath.row].timeElapsed ?? ""
        }
        
        if self.notification?.data[indexPath.row].notificationType == "request_accept_notification" {
            let strMessage = "\(self.notification?.data[indexPath.row].followRequestAcceptedByUserName ?? "") accepted your follow request."
            cell.lblContent.text = strMessage
            cell.imgVwUser.sd_setImage(with: URL(string: (self.notification?.data[indexPath.row].followRequestAcceptedByUserProfileImage)!), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            cell.lblTime.text = self.notification?.data[indexPath.row].timeElapsed ?? ""
        }
        
        if self.notification?.data[indexPath.row].notificationType == "request_declined_notification" {
            let strMessage = "\(self.notification?.data[indexPath.row].followRequestDeclinedByUserName ?? "") declined your follow request."
            cell.lblContent.text = strMessage
            cell.imgVwUser.sd_setImage(with: URL(string: (self.notification?.data[indexPath.row].followRequestDeclinedByUserProfileImage)!), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            cell.lblTime.text = self.notification?.data[indexPath.row].timeElapsed ?? ""
        }
        
        if self.notification?.data[indexPath.row].notificationType == "challenge_create_notification" {
            let strMessage = "\(self.notification?.data[indexPath.row].challengeCreateSenderUserName ?? "") has created challenge with you."
            cell.lblContent.text = strMessage
            cell.imgVwUser.sd_setImage(with: URL(string: (self.notification?.data[indexPath.row].challengeCreateSenderProfileImage)!), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            cell.lblTime.text = self.notification?.data[indexPath.row].timeElapsed ?? ""
        }
    }
}

