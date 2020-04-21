//
//  LoginViewController.swift
//  Vers
//
//  Created by sagar.gupta on 12/02/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var contentViewBottom: NSLayoutConstraint!
    @IBOutlet weak var contentImageY: NSLayoutConstraint!
    
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
        self.hideNavigationBar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if DeviceType.IS_IPHONE_5 {
//            scrollview.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height+100)
//            self.contentViewBottom.constant = (self.scrollview.contentSize.height/4)
//            self.contentImageY.constant = 30
//        }
    }
    
    func configuration()  {
        let dict = UserDefaults.standard.object(forKey: "userinfo") as? JSONDictionary
        if dict != nil && dict?.count != 0 {
            VersManager.share.userLogin = VersLogin(json: dict!)
            self.navigateToHomeVC()
        }
        txtEmail.setBottomBorder()
        txtPassword.setBottomBorder()
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtEmail.text = ""
        txtPassword.text = ""
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
        if  (txtPassword.text?.isEmpty)! {
            self.showAlert(title: "", message: "Enter password.")
            return false
        }
        return true
    }
    
    @IBAction func btnSinginAction(sender:UIButton) {
        
        if validation() {
            loginApiCall()
        }
        
    }
    
    fileprivate func loginApiCall() {
        let params = ["email_address":txtEmail.text!,"password":txtPassword.text!,"device_type":"1","device_token":AppDelegate.share.deviceToken] as JSONDictionary
        self.view.showHUD()
        APIClient.share.postRequest(withParams: params , url: URLConstants.share.login) { (JSON: Any?, _: URLResponse?, _: Error?) in
            self.view.hideHUD()
            if let json = JSON as? JSONDictionary {
                print(json)
                if let dictobj = json["meta"] as? JSONDictionary {
                    if dictobj["status"] as! Bool == false {
                        self.view.hideHUD()
                        self.showAlert(title: "Alert", message: "invalid e-mail or password")
                    } else {
                        self.view.hideHUD()
                        print(json)
                        UserDefaults.standard.set(json, forKey: "userinfo")
                        UserDefaults.standard.synchronize()
                        VersManager.share.userLogin = VersLogin(json: json)
                        self.navigateToHomeVC()
                    }
                }else{
                    self.showAlert(title: "Alert", message: json["message"] as? String)
                }
            }else{
                self.showAlert(title: "", message: "Data is not in correct format.")
            }
        }
    }
    
    func navigateToHomeVC()  {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        mainViewController.rootViewController = navigationController
        mainViewController.setup(type: UInt(0))
        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = mainViewController
        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
