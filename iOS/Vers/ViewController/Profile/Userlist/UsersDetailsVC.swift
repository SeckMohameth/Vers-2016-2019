//
//  SendToViewController.swift
//  Vers
//
//  Created by sagar.gupta on 21/02/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit
import AVFoundation

protocol UserViewDelegate {
    func seletedUser(indx:IndexPath)
}

@objc class UsersDetailsVC: UIViewController {
    
    @IBOutlet weak var tblSendTo: UITableView!
    @IBOutlet weak var searchVW: UIView!
    @IBOutlet weak var txtSearchBar: UITextField!
    
    var delegate: UserViewDelegate!

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
   //     hideNavigationBar()
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            self.configuration()
        }
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       self.showNavigationBar()
        self.backButton(image: "back")
        carsDictionary.removeAll()
        featchUserListApiCall()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tblSendTo.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
    }
    
    func configuration()  {
        searchVW.showShadow()
        selectedVersIdxPath = IndexPath(row: 0, section: 0)
        txtSearchBar.addTarget(self, action: #selector(searchRecordsAsPerText(_ :)), for: .editingChanged)
        self.tblSendTo.register(UINib(nibName: USerDetailCellTableViewCell.stringRepresentation, bundle: nil), forCellReuseIdentifier: USerDetailCellTableViewCell.stringRepresentation)
    }
    
    @IBAction func btnSendVersAction(sender: UIButton) {
        if selectedUser != nil {
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
        print(params)
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
                        print(VersManager.share.versUsers ?? "")
                        self.searchedArray.removeAll()
                        
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
                selectedUser = carValues[selectedVersIdxPath.row]
            }
        }
        tblSendTo.reloadData()
    }
    
    @objc func searchRecordsAsPerText(_ textfield:UITextField) {
        searchedArray.removeAll()
        carSectionTitles.removeAll()
        carsDictionary.removeAll()
        if textfield.text?.count != 0 {
            for strCountry in VersManager.share.versUsers.data {
                let range = strCountry.name.lowercased().range(of: textfield.text!, options: .caseInsensitive, range: nil,   locale: nil)
                
                if range != nil {
                    searchedArray.append(strCountry)
                }
            }
        } else {
            searchedArray = VersManager.share.versUsers.data
        }
        self.versDataLoad()
        tblSendTo.reloadData()
    }
    
    @objc func btnFollowAction(sender:UIButton) {
        let revicerId:Int!
        let senderId:Int!
        guard let cell = sender.superview?.superview as? USerDetailCellTableViewCell else {
            return // or fatalError() or whatever
        }
        let indexPath = tblSendTo.indexPath(for: cell)
        print(indexPath)
        //cell.setPendingBotton()
        let carKey = carSectionTitles[(indexPath?.section)!]
        if let carValues = carsDictionary[carKey] {
            senderId = VersManager.share.userLogin?.data.first?.id
            revicerId = carValues[(indexPath?.row)!].id
            self.followRequestApiCall(follow_request_senderid: senderId, follow_request_receiverid: revicerId)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            self.tblSendTo.reloadData()
            
 })
        
    }
}

extension UsersDetailsVC:UITableViewDelegate,UITableViewDataSource {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: USerDetailCellTableViewCell.stringRepresentation) as! USerDetailCellTableViewCell
        cell.selectionStyle = .none
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
           
            if carValues[indexPath.row].followStatus == "following" {
                cell.btnFollow.setTitle("Following", for: UIControlState.normal)
                 cell.btnFollow.addTarget(self, action: #selector(btnFollowAction(sender:)), for: .touchUpInside)
                cell.setFollowingBotton()
            }else{
                cell.setFollowBotton()
                cell.btnFollow.addTarget(self, action: #selector(btnFollowAction(sender:)), for: .touchUpInside)
            };
            //if carValues[indexPath.row].blockStatus == "blocked" {
             //   self.showAlert(title: "Alert", message: "You have blocked by this user, you can send follow request ")
            //}
            
            if carValues[indexPath.row].followStatus == "pending" {
                cell.btnFollow.setTitle("Pending", for: UIControlState.normal)
                 cell.btnFollow.addTarget(self, action: #selector(btnFollowAction(sender:)), for: .touchUpInside)
                
                 cell.setPendingBotton()
            }; if carValues[indexPath.row].followStatus == "" {
                cell.btnFollow.setTitle("Follow", for: UIControlState.normal)
                 cell.btnFollow.addTarget(self, action: #selector(btnFollowAction(sender:)), for: .touchUpInside)
               cell.setFollowBotton()
            }
          //  tblSendTo.reloadData()
        }
        if selectedVersIdxPath == indexPath {
       //     cell.markImageVW.isHidden = false
       //     cell.profileImageVW.layer.borderColor = UIColor(red: 255.0/255.0, green: 56/255.0, blue: 57/255.0, alpha: 1.0).cgColor
        }else{
        //    cell.markImageVW.isHidden = true
        //    cell.profileImageVW.layer.borderColor = UIColor.white.cgColor
        }
    //    cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     

        let vc = OtherUserProfileVC.init(nibName: OtherUserProfileVC.stringRepresentation, bundle: nil)
        let carKey = carSectionTitles[indexPath.section]
        if let carValues = carsDictionary[carKey] {
            vc.user_id = carValues[indexPath.row].id
        }
        self.navigationController?.pushViewController(vc, animated: true)
            
   
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        let selectedCell:USerDetailCellTableViewCell = tableView.cellForRow(at: indexPath)! as! USerDetailCellTableViewCell
//        selectedCell.markImageVW.isHidden = true
//        selectedCell.profileImageVW.layer.borderColor = UIColor.white.cgColor
//
//    }
    

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return carSectionTitles
    }
    
   
}

