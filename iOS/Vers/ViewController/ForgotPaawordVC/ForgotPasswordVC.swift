//
//  ForgotPasswordVC.swift
//  Vers
//
//  Created by sagar.gupta on 12/02/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit
import IQKeyboardManager

class ForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var contentViewBottom: NSLayoutConstraint!

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
        self.hideNavigationBarBackButton()
        self.backButton(image: "back")
        self.navigationItem.title = "Forgot password"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared().isEnabled = true
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize)
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 200
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize)
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 200
            }
        }
    }
    
    func configuration()  {
        txtEmail.setBottomBorder()
        txtEmail.delegate = self
        
    }
    
    func validation() -> Bool {
        
        if (txtEmail.text?.isEmpty)! {
            self.showAlert(title: "", message: "Enter email.")
            return false
        }
        if !(txtEmail.text?.isValidEmail())! {
            self.showAlert(title: "", message: "Enter vaild email.")
            return false
        }
        return true
    }
    
    @IBAction func btnForgotpassword(sender:UIButton) {
        if validation() {
            forgotpasswordApiCall()
        }
    }
    
    fileprivate func forgotpasswordApiCall() {
        let params = ["email_address":txtEmail.text!] as JSONDictionary
        self.view.showHUD()
        APIClient.share.postRequest(withParams: params , url: URLConstants.share.forgotpassword) { (JSON: Any?, _: URLResponse?, _: Error?) in
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
                    self.showSuccessAlert(strMsaage: dictobj["message"] as? String)
                }
            }else{
                self.showAlert(title: "", message: "Data is not in correct format.")
            }
        }
    }
    
    func showSuccessAlert(strMsaage:String?)  {
        let alert = UIAlertController(title: "", message: strMsaage ?? "Forgot password link sent in your mail.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            self.navigateToBackScreen()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }
}

extension ForgotPasswordVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
