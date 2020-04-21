//
//  WffViewController.swift
//  Vers
//
//  Created by pawan.sharma on 29/03/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit

class WffViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    var strTitle:String!
    var userWins:UserWins?
    var userFollower:UserFollowers?
    var userFollowing:UserFollowing?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        defaultConfiguration()
    }
    
    @IBAction func button_back (_ sender : UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = strTitle
        self.backButton(image: "back")
        if strTitle == "Wins" {
            userWinsApiCall()
        }else if strTitle == "Followers" {
            userfollowersApiCall()
        }else {
            userfollowingApiCall()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func defaultConfiguration()  {
        tblView.register(UINib(nibName: WffTableViewCell.stringRepresentation, bundle: nil), forCellReuseIdentifier: WffTableViewCell.stringRepresentation)
        tblView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    fileprivate func userfollowingApiCall() {
        self.view.showHUD()
        let params = ["user_id":VersManager.share.userLogin?.data.first?.id ?? 0] as JSONDictionary
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
                           // self.showAlert(title: "Alert", message: dictobj["message"] as? String)
                        }
                    } else {
                        self.view.hideHUD()
                        print(json)
                        self.userFollowing = UserFollowing(json: json)
                        self.tblView.reloadData()
                    }
                }else{
                   // self.showAlert(title: "Alert", message: json["message"] as? String)
                }
            }else{
                self.showAlert(title: "", message: "Data is not in correct format.")
            }
        }
    }
    
    fileprivate func userfollowersApiCall() {
        self.view.showHUD()
        let params = ["user_id":VersManager.share.userLogin?.data.first?.id ?? 0] as JSONDictionary
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
                        self.tblView.reloadData()
                    }
                }else{
                    //self.showAlert(title: "Alert", message: json["message"] as? String)
                }
            }else{
                self.showAlert(title: "", message: "Data is not in correct format.")
            }
        }
    }
    
    fileprivate func userWinsApiCall() {
        self.view.showHUD()
        let params = ["user_id":VersManager.share.userLogin?.data.first?.id ?? 0] as JSONDictionary
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
                        self.tblView.reloadData()
                    }
                }else{
                    self.showAlert(title: "Alert", message: json["message"] as? String)
                }
            }else{
                self.showAlert(title: "", message: "Data is not in correct format.")
            }
        }
    }
    
    @objc func followRequestSendApiCall(sender:UIButton) {
        let revicerId:Int!
        let senderId:Int!
        if strTitle == "Wins" {
            revicerId = userWins?.data[sender.tag].recieverId
            senderId = userWins?.data[sender.tag].senderId
        }else if strTitle == "Followers" {
            revicerId = userFollower?.data[sender.tag].id
            senderId = VersManager.share.userLogin?.data.first?.id ?? 0
        }else {
            revicerId = userFollowing?.data[sender.tag].id
            senderId = VersManager.share.userLogin?.data.first?.id ?? 0
        }
        
        self.followRequestApiCall(follow_request_senderid: senderId, follow_request_receiverid: revicerId)
        
    }
    
}

extension WffViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if strTitle == "Wins" {
            print(userWins?.data.count ?? 0)
            return userWins?.data.count ?? 0
            
        }else if strTitle == "Followers" {
            return userFollower?.data.count ?? 0
            print(userFollower?.data.count ?? 0)
        }else {
           return userFollowing?.data.count ?? 0
            print(userFollowing?.data.count ?? 0)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WffTableViewCell.stringRepresentation) as! WffTableViewCell
        cell.selectionStyle = .none
        cell.btnFollow.tag = indexPath.row
        if strTitle == "Wins" {
            cell.imgVwUser.sd_setImage(with: userWins?.data[indexPath.row].profileImage, placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            cell.lblName.text = userWins?.data[indexPath.row].name
            cell.lblDefeted.text = "Defeted \(userWins?.data[indexPath.row].defeatCount ?? 0)X"
            if userWins?.data[indexPath.row].followStatus == "Following" {
                cell.setFollowingBotton()
            }else{
                cell.setFollowBotton()
            }
        }else if strTitle == "Followers" {
            cell.imgVwUser.sd_setImage(with: userFollower?.data[indexPath.row].userProfileImagePath, placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            cell.lblName.text = userFollower?.data[indexPath.row].name
            cell.lblDefeted.isHidden = true
            if userFollower?.data[indexPath.row].followStatus == "Following" {
                cell.setFollowingBotton()
            }else{
                cell.setFollowBotton()
                cell.btnFollow.addTarget(self, action: #selector(followRequestSendApiCall(sender:)), for: .touchUpInside)
            }
            
        }else {
            cell.imgVwUser.sd_setImage(with: userFollowing?.data[indexPath.row].userProfileImagePath, placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            cell.lblName.text = userFollowing?.data[indexPath.row].name
            cell.lblDefeted.isHidden = true
            cell.setFollowingBotton()
        }
        return cell
    }
}
