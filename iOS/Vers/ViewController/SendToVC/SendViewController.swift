//
//  SendViewController.swift
//  Vers
//
//  Created by sagar.gupta on 21/02/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit

class SendViewController: UIViewController {
    
    @IBOutlet weak var titleVW: UIView!
    @IBOutlet weak var descriptionVW: UIView!
    @IBOutlet weak var privacyVW: UIView!
    @IBOutlet weak var votestowinVW: UIView!
    
    @IBOutlet weak var txtTitleVW: UITextField!
    @IBOutlet weak var txtDescriptionVW: UITextView!
    @IBOutlet weak var txtPrivacyVW: UITextField!
   
    var selectedUser:VersUserList.Data?
    var isvideoUploadStart:Bool!
    var visibility = ["public","private"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configuration()
        txtTitleVW.text = ""
        txtDescriptionVW.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        let menuImg = UIImage(named:"back")
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: menuImg, style: UIBarButtonItemStyle.plain, target:
            self, action: #selector(backButtonAction))
        isvideoUploadStart = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        VersManager.share.isChangeRecipent = false
    }
    
    func configuration() {
        titleVW.showShadow()
        descriptionVW.showShadow()
        privacyVW.showShadow()
   //     votestowinVW.showShadow()
       // txtPrivacyVW.isUserInteractionEnabled = false
        txtPrivacyVW.text = visibility.first?.capitalized
        
        let picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 220))
        picker.dataSource = self
        picker.delegate = self
        txtPrivacyVW.inputView = picker
    }
    
    @objc func backButtonAction() {
        if isvideoUploadStart {
            let alert = UIAlertController(title: "", message: "Are you sure.you want to stop challenge.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
               self.navigateToBackScreen()
            }
            let cancelActionButton = UIAlertAction(title: "Cancel", style: .destructive) { action -> Void in
                
            }
            alert.addAction(cancelActionButton)
            alert.addAction(action)
            self.present(alert, animated: true, completion:nil)
        }else{
            self.navigateToBackScreen()
        }
    }
    
    fileprivate func challengeApiCall() {
        let params = ["sender_id":VersManager.share.userLogin?.data.first?.id ?? 0,"receiver_id":selectedUser?.id ?? 0 ,"challenge_title":txtTitleVW.text!,"challenge_description":txtDescriptionVW.text!,"challenge_visibility":txtPrivacyVW.text!.lowercased()] as [String : Any]
        print(params)
        isvideoUploadStart = true
        self.view.showHUD()
        APIClient.share.uploadVideoRequest(with: params as! JSONParams, url: URLConstants.share.sendchallenge,viedoKey: "user_video", imageData: VersManager.share.videoData! as NSData) { (JSON: Any?, _: URLResponse?, _: Error?) in
            self.view.hideHUD()
            if let json = JSON as? JSONDictionary {
                print(json)
                self.isvideoUploadStart = false
                if let dictobj = json["meta"] as? JSONDictionary {
                    if dictobj["status"] as! Bool == false {
                        self.view.hideHUD()
                        self.showAlert(title: "Alert", message: dictobj["message"] as? String)
                    } else {
                        self.view.hideHUD()
                        print(json)
                        //self.showAlert(title: "Alert", message: dictobj["message"] as? String)
                        //self.showSuccessAlert()
                        self.showSuccessAlert(message: dictobj["message"] as? String ?? "")
                    }
                }else{
                    self.showAlert(title: "", message: "Data is not in correct format.")
                }
            }else{
                self.isvideoUploadStart = false
                self.showAlert(title: "", message: "Data is not in correct format.")
            }
        }
    }
    
    fileprivate func changeRecipientApiCall() {
        self.view.showHUD()
        let params = ["challenge_id":VersManager.share.changeRecipientParams.challenge_id,"challenge_title":txtTitleVW.text!,"challenge_description":txtDescriptionVW.text!,"sender_id":VersManager.share.changeRecipientParams.sender_id,"sender_video_id":VersManager.share.changeRecipientParams.sender_video_id,"receiver_id":selectedUser?.id ?? 0] as JSONDictionary
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.changerecepient) { (JSON: Any?, _: URLResponse?, _: Error?) in
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
                    VersManager.share.isChangeRecipent = false
                    self.view.hideHUD()
                    self.showChangeRecipientSuccessAlert(message: dictobj["message"] as? String)
                }
            }else{
                self.showAlert(title: "", message: "Data is not in correct format.")
            }
        }
    }
    
    
    func showSuccessAlert(message:String?)  {
        let alert = UIAlertController(title: "", message: message ?? "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            self.naviagteTohomeScreen()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }
    
    func showChangeRecipientSuccessAlert(message:String?)  {
        let alert = UIAlertController(title: "", message: message ?? "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            self.naviagteToVersScreen()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }
    
    func naviagteTohomeScreen()  {
        let controllers = self.navigationController?.viewControllers
        for vc in controllers! {
            if vc is HomeViewController {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    func naviagteToVersScreen()  {
        let controllers = self.navigationController?.viewControllers
        for vc in controllers! {
            if vc is VersusViewController {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    func validation() -> Bool {
        
        if (txtTitleVW.text?.isEmpty)! {
            self.showAlert(title: "", message: "Enter challenge tittle.")
            return false
        }
        if (txtDescriptionVW.text?.isEmpty)! {
            self.showAlert(title: "", message: "Enter challenge description.")
            return false
        }
        return true
    }
    
    @IBAction func btnsendAction(sender:UIButton) {
        if validation() {
            if VersManager.share.isChangeRecipent {
                self.changeRecipientApiCall()
            }else{
                self.challengeApiCall()
            }
            
        }
    }

}
extension SendViewController:UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return visibility[row].capitalized
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtPrivacyVW.text = visibility[row].capitalized
    }
}
