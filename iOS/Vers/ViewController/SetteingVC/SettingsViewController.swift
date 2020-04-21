//
//  SettingsViewController.swift
//  Vers
//
//  Created by sagar.gupta on 16/02/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var shadowVW1: UIView!
    @IBOutlet weak var shadowVW2: UIView!
    @IBOutlet weak var lblPrivate1: UILabel!
    @IBOutlet weak var lblPrivate2: UILabel!
    @IBOutlet weak var lblPublic1: UILabel!
    @IBOutlet weak var lblPublic2: UILabel!
    @IBOutlet weak var lblPublic3: UILabel!
    
    @IBOutlet weak var switchPrivate: UISwitch!
    @IBOutlet weak var switchPublic: UISwitch!
    var profileStatus:String!
    
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
        self.navigationItem.title = "Setting"
        self.addMenuButton(image: "menu")
    }
    
    func configuration()  {
        shadowVW1.showShadow()
        shadowVW2.showShadow()
        lblPrivate1.text = "Only Followers can send you a challenge and vote"
        lblPrivate2.text = "Your streak will not appear on the top ten discovery page"
        lblPublic1.text = "Anyone can vers me and vote."
        lblPublic2.text = "Your streak will be visible in top ten on the discovery."
        lblPublic3.text = "Videos will appear on the discovery page for public voting."
        
        profileStatus = VersManager.share.userLogin?.data.first?.userProfileSettings
        if profileStatus == "public" {
            switchPrivate.setOn(false, animated: true)
            switchPublic.setOn(true, animated: true)
        }else{
            switchPrivate.setOn(true, animated: true)
            switchPublic.setOn(false, animated: true)
        }
        
//        if VersManager.share.userSettingStatus != nil {
//            if VersManager.share.userSettingStatus == "public" {
//                switchPrivate.setOn(false, animated: true)
//                switchPublic.setOn(true, animated: true)
//            }else{
//                switchPrivate.setOn(true, animated: true)
//                switchPublic.setOn(false, animated: true)
//            }
//        }
    }
    
    @IBAction func btnPublicSwitch(sender:UISwitch) {
        if sender.isOn {
            switchPrivate.setOn(false, animated: true)
            profileStatus = "public"
        }else {
            profileStatus = "private"
        }
        UpdateUserprofileSettings()
    }
    
    @IBAction func btnPrivateSwitch(sender:UISwitch) {
        if sender.isOn {
            switchPublic.setOn(false, animated: true)
            profileStatus = "private"
        }else {
            profileStatus = "public"
        }
        UpdateUserprofileSettings()
    }
    
    
    fileprivate func UpdateUserprofileSettings() {
        self.view.showHUD()
        let params = ["user_id":VersManager.share.userLogin?.data.first?.id ?? 0,"profile_type":profileStatus] as JSONDictionary
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.profileSettings) { (JSON: Any?, _: URLResponse?, _: Error?) in
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
                        var dict = UserDefaults.standard.object(forKey: "userinfo") as? JSONDictionary
                        if dict != nil && dict?.count != 0 {
                            print(dict ?? [:])
                            var arrdata = dict!["data"] as! [JSONDictionary]
                            var dictupdate = arrdata.first
                            print(self.profileStatus)
                            dictupdate!["userProfileSettings"] = self.profileStatus
                            arrdata[0] = dictupdate!
                            dict!["data"] = arrdata
                            UserDefaults.standard.set(dict, forKey: "userinfo")
                            UserDefaults.standard.synchronize()
                            VersManager.share.userLogin = VersLogin(json: dict!)
                        }
                        VersManager.share.userSettingStatus = self.profileStatus
                        self.view.hideHUD()
                        
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
