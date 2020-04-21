//
//  SendToViewController.swift
//  Vers
//
//  Created by sagar.gupta on 21/02/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit
import AVFoundation

@objc class SendToViewController: UIViewController {
    
    @IBOutlet weak var tblSendTo: UITableView!
    @IBOutlet weak var searchVW: UIView!
    @IBOutlet weak var txtSearchBar: UITextField!
    
    var carsDictionary = [String: [VersUserList.Data]]()
    var carSectionTitles = [String]()
    var searchedArray = [VersUserList.Data]()
    var lastContentOffset: CGFloat = 0
    var selectedUser:VersUserList.Data?
    var selectedVersIdxPath:IndexPath!
   @objc var status:String!
   @objc var receiver_id:String = ""
    
    @objc var challengeVideo:Data!
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
        self.navigationItem.title = "Send to..."
        self.backButton(image: "back")
        featchUserListApiCall()
    }
    
  
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tblSendTo.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
    }
    
    func configuration()  {
        searchVW.showShadow()
        selectedVersIdxPath = IndexPath(row: -1, section: 0)
        txtSearchBar.addTarget(self, action: #selector(searchRecordsAsPerText(_ :)), for: .editingChanged)
        self.tblSendTo.register(UINib(nibName: SendToTableViewCell.stringRepresentation, bundle: nil), forCellReuseIdentifier: SendToTableViewCell.stringRepresentation)
    }
    
    @IBAction func btnSendVersAction(sender: UIButton) {
        if selectedVersIdxPath.row > -1 {
            let vc = SendViewController.instantiateFromXIB() as SendViewController
            vc.selectedUser = selectedUser
            VersManager.share.videoData = challengeVideo
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.showAlert(title: "", message: "Please select user.")
        }
        
    }
    
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
    
    fileprivate func featchUserListApiCall() {
        self.view.showHUD()
        let params = ["user_id":VersManager.share.userLogin?.data.first?.id ?? 0,"status":status,"receiver_id":receiver_id] as JSONDictionary
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.userlist) { (JSON: Any?, _: URLResponse?, _: Error?) in
            self.view.hideHUD()
            if let json = JSON as? JSONDictionary {
                print(json)
                let dictobj = json["meta"] as! JSONDictionary
                if dictobj["status"] as! Bool == false {
                    self.view.hideHUD()
                    self.showAlert(title: "Alert", message: dictobj["message"] as? String)
                } else {
                    self.view.hideHUD()
                    print(json)
                    VersManager.share.versUsers = VersUserList(json: json)
                    if VersManager.share.versUsers != nil {
                        self.searchedArray = VersManager.share.versUsers.data
                        self.versDataLoad()
                    }
                }
            }else{
                self.showAlert(title: "", message: "Data is not in correct format.")
            }
        }
    }
    
    func versDataLoad() {
        print(searchedArray.count)
        for car in self.searchedArray {
            let carKey = String(car.name.prefix(1)).capitalized
            if var carValues = carsDictionary[carKey] {
                carValues.append(car)
                carsDictionary[carKey] = carValues
            } else {
                carsDictionary[carKey] = [car]
            }
        }
        carSectionTitles = [String](carsDictionary.keys)
        carSectionTitles = carSectionTitles.sorted(by: { $0 < $1 })
        if carSectionTitles.count != 0 {
            let carKey = carSectionTitles[selectedVersIdxPath.section]
            if let carValues = carsDictionary[carKey] {
                selectedUser = carValues[0] //selectedVersIdxPath.row
            }
        }
        tblSendTo.reloadData()
    }
    
    @objc func searchRecordsAsPerText(_ textfield:UITextField) {
        searchedArray.removeAll()
        carSectionTitles.removeAll()
        carsDictionary.removeAll()
        if textfield.text?.count != 0 {
            selectedVersIdxPath = IndexPath(row: -1, section: 0)
              for strCountry in VersManager.share.versUsers.data {
                let range = strCountry.name.lowercased().range(of: textfield.text!, options: .caseInsensitive, range: nil,   locale: nil)
                
                if range != nil {
                    searchedArray.append(strCountry)
                }
            }
        } else {
            selectedVersIdxPath = IndexPath(row: -1, section: 0)
            searchedArray = VersManager.share.versUsers.data
        }
        self.versDataLoad()
        tblSendTo.reloadData()
    }
    
    @objc func btnFollowAction(sender:UIButton) {
        let revicerId:Int!
        let senderId:Int!
        guard let cell = sender.superview?.superview as? SendToTableViewCell else {
            return // or fatalError() or whatever
        }
        let indexPath = tblSendTo.indexPath(for: cell)
        print(indexPath)
        let carKey = carSectionTitles[(indexPath?.section)!]
        if let carValues = carsDictionary[carKey] {
            senderId = VersManager.share.userLogin?.data.first?.id
            revicerId = carValues[(indexPath?.row)!].id
       // senderId = VersManager.share.userLogin?.data.first?.id
        //revicerId = searchedArray[sender.tag].id
        self.followRequestApiCall(follow_request_senderid: senderId, follow_request_receiverid: revicerId)
        }
    
    }
}

extension SendToViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if VersManager.share.versUsers != nil {
            return carSectionTitles.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if VersManager.share.versUsers != nil {
            let carKey = carSectionTitles[section]
            if let carValues = carsDictionary[carKey] {
                return carValues.count
            }
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SendToTableViewCell.stringRepresentation) as! SendToTableViewCell
        let carKey = carSectionTitles[indexPath.section]
        if let carValues = carsDictionary[carKey] {
            cell.lblName.text = carValues[indexPath.row].name
            cell.lblSubName.text = carValues[indexPath.row].userName
            if carValues[indexPath.row].userProfileImagePath.absoluteString != "" {
                cell.profileImageVW.sd_setImage(with: carValues[indexPath.row].userProfileImagePath , placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            }else{
                cell.profileImageVW.image = #imageLiteral(resourceName: "dummy")
            }
            cell.markImageVW.isHidden = true
            cell.btnFollow.tag = indexPath.row
            
            
            if carValues[indexPath.row].followStatus == "Following" {
                cell.setFollowingBotton()
            };
            //if carValues[indexPath.row].blockStatus == "blocked" {
              //  self.showAlert(title: "Alert", message: "You have blocked by this user, you can send follow request ")
        //    }
         if carValues[indexPath.row].followStatus == "pending" {
                cell.btnFollow.setTitle("Pending", for: UIControlState.normal)
                cell.setPendingBotton()
            }; if carValues[indexPath.row].followStatus == "" {
                cell.setFollowBotton()
                cell.btnFollow.addTarget(self, action: #selector(btnFollowAction(sender:)), for: .touchUpInside)
            }
            
            else{
                cell.setFollowBotton()
                cell.btnFollow.addTarget(self, action: #selector(btnFollowAction(sender:)), for: .touchUpInside)
            }
        }
        if selectedVersIdxPath == indexPath {
            cell.markImageVW.isHidden = false
            cell.profileImageVW.layer.borderColor = UIColor(red: 255.0/255.0, green: 56/255.0, blue: 57/255.0, alpha: 1.0).cgColor
        }else{
            cell.markImageVW.isHidden = true
            cell.profileImageVW.layer.borderColor = UIColor.white.cgColor
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:SendToTableViewCell = tableView.cellForRow(at: indexPath)! as! SendToTableViewCell
        
        let carKey = carSectionTitles[indexPath.section]
        if let carValues = carsDictionary[carKey] {
        if (carValues[indexPath.row].userProfileSettings == "private") {
            if (carValues[indexPath.row].followStatus == "pending") {
                self.showAlert(title: "Alert", message: "You can not send challenge as your follow request is pending")
                return
            }
            else if (carValues[indexPath.row].followStatus == "") {
                self.showAlert(title: "Alert", message: "You can not send challenge. First you need to follow.")
                return
            } else if (carValues[indexPath.row].followStatus == "following") {
                //self.showAlert(title: "Alert", message: "You can send challenge")
                
            }
        }
        
        selectedCell.markImageVW.isHidden = false
        selectedCell.profileImageVW.layer.borderColor = UIColor(red: 255.0/255.0, green: 56/255.0, blue: 57/255.0, alpha: 1.0).cgColor
        
            selectedVersIdxPath = indexPath
            selectedUser = carValues[indexPath.row]
            tblSendTo.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selectedCell:SendToTableViewCell = tableView.cellForRow(at: indexPath)! as! SendToTableViewCell
        selectedCell.markImageVW.isHidden = true
        selectedCell.profileImageVW.layer.borderColor = UIColor.white.cgColor
      //  let carKey = carSectionTitles[indexPath.section]
//        if let carValues = carsDictionary[carKey] {
//            selectedUser = carValues[indexPath.row]
//        }
    }
    
    
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return carSectionTitles[section]
    //    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return carSectionTitles
    }
    
    //    // this delegate is called when the scrollView (i.e your UITableView) will start scrolling
    //    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    //        self.lastContentOffset = scrollView.contentOffset.y
    //    }
    //
    //    // while scrolling this delegate is being called so you may now check which direction your scrollView is being scrolled to
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        if (self.lastContentOffset < scrollView.contentOffset.y) {
    //            // moved to top
    //            tblSendTo.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    //        } else if (self.lastContentOffset > scrollView.contentOffset.y) {
    //            // moved to bottom
    //            tblSendTo.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
    //        } else {
    //            tblSendTo.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    //            // didn't move
    //        }
    //    }
}
