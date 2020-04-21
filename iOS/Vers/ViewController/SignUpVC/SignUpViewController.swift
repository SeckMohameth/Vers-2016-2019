//
//  SignUpViewController.swift
//  Vers
//
//  Created by sagar.gupta on 12/02/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var btnImageUpload: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFeMale: UIButton!
    @IBOutlet weak var scrolview: UIScrollView!
    @IBOutlet weak var infoswitch: UISwitch!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var btnTermCondition: UIButton!
    
    @IBOutlet weak var contentViewBottom: NSLayoutConstraint!
    var gender:String!
    var infoPrivate: String!
    var istermCondition: Bool = false
    var picker:UIImagePickerController?=UIImagePickerController()
    var imageData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     gender = ""
        infoPrivate = "public"
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
        self.navigationItem.title = "Sign Up"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
  //     APIClient.share.demoRegister()
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//
//        if DeviceType.IS_IPHONE_5 {
//
//            scrolview.contentSize = CGSize(width: self.view.frame.width, height:800)
//            contentViewBottom.constant = 800
//
//        }else{
//            scrolview.contentOffset = CGPoint(x: 0, y: -64)
//            scrolview.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
//            contentViewBottom.constant = 150
//        }
    }
    
    func configuration()  {
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtName.delegate = self
        txtUsername.delegate = self
        txtLocation.delegate = self
        imgViewProfile.layer.cornerRadius = imgViewProfile.frame.size.height/2
        imgViewProfile.layer.masksToBounds = true
        imgViewProfile.layer.borderWidth = 2
        imgViewProfile.layer.borderColor = UIColor(red: 255.0/255.0, green: 56/255.0, blue: 57/255.0, alpha: 1.0).cgColor
        
        btnImageUpload.layer.cornerRadius = btnImageUpload.frame.size.height/2
        btnImageUpload.layer.masksToBounds = true
        btnImageUpload.layer.borderWidth = 2
        btnImageUpload.layer.borderColor = UIColor.black.cgColor
        
        btnMale.layer.cornerRadius = btnMale.frame.size.height/2
        btnMale.layer.masksToBounds = true
        btnMale.layer.borderWidth = 2
        btnMale.layer.borderColor = UIColor.red.cgColor
        btnMale.backgroundColor = UIColor.black
        btnMale.tag = 1
        
        btnFeMale.layer.cornerRadius = btnFeMale.frame.size.height/2
        btnFeMale.layer.masksToBounds = true
        btnFeMale.layer.borderWidth = 2
        btnFeMale.layer.borderColor = UIColor.red.cgColor
        btnFeMale.backgroundColor = UIColor.black
        btnFeMale.tag = 3
        
        txtEmail.setBottomBorder()
        txtUsername.setBottomBorder()
        txtName.setBottomBorder()
        txtLocation.setBottomBorder()
        txtPassword.setBottomBorder()
        picker?.delegate = self
        infoswitch.setOn(false, animated: true)
        
        btnCheck.layer.cornerRadius = 5
        btnCheck.layer.borderWidth = 1
        btnCheck.layer.borderColor = UIColor.black.cgColor
        btnCheck.layer.masksToBounds = true
        
    }
    
    @IBAction func btnMaleAction(sender:UIButton) {
          gender = "male"
       btnMale.setImage(#imageLiteral(resourceName: "ellipse"), for: .normal)
       btnFeMale.setImage(UIImage(named: ""), for: .normal)
    }
    
    @IBAction func btnFeMaleAction(sender:UIButton) {
     gender = "female"
   btnFeMale.setImage(#imageLiteral(resourceName: "ellipse"), for: .normal)
       btnMale.setImage(UIImage(named: ""), for: .normal)
    }
    
    @IBAction func switchON(sender:UISwitch) {
        
        if sender.isOn {
            infoPrivate = "private"
        }else{
            infoPrivate = "public"
        }
    }
    
    @IBAction func btnCheckUnchake(sender:UIButton) {
        if !istermCondition {
            istermCondition = true
            btnCheck.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        }else{
            istermCondition = false
            btnCheck.setImage(nil, for: .normal)
        }
    }
    
    @IBAction func btntermCondition(sender:UIButton) {
        let vc = WebViewController.init(nibName: WebViewController.stringRepresentation, bundle: nil)
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnUploadPhoto(sender:UIButton) {
        //self.openCamera()
        let alert:UIAlertController=UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        // Add the actions
        picker?.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the controller
        self.present(alert, animated: true, completion: nil)
    }
    
    func validation() -> Bool {
        if (txtName.text?.isEmpty)! {
            self.showAlert(title: "", message: "Enter name.")
            return false
        }
        if (txtUsername.text?.isEmpty)! {
            self.showAlert(title: "", message: "Enter username.")
            return false
        }
        if (txtEmail.text?.isEmpty)! {
            self.showAlert(title: "", message: "Enter email.")
            return false
        }
        if !(txtEmail.text?.isValidEmail())! {
            self.showAlert(title: "", message: "Enter vaild email.")
            return false
        }
        if  (txtLocation.text?.isEmpty)! {
            self.showAlert(title: "", message: "Enter representing location.")
            return false
        }
        if  (txtPassword.text?.isEmpty)! {
            self.showAlert(title: "", message: "Enter password.")
            return false
        }
        if  imageData == nil {
            self.showAlert(title: "", message: "upload profile image.")
            return false
        }
        
        if istermCondition == false {
            self.showAlert(title: "", message: "Please check term & condition check box.")
            return false
        }
        return true
    }
    
    @IBAction func signupAction(sender:UIButton) {
        if validation() {
            signupApiCall()
       //    APIClient.share.demoRegister()
        }
    }
    
    
    fileprivate func signupApiCall() {
        let params = ["name":txtName.text ?? "" ,"user_name":txtUsername.text ?? "","representing_location":txtLocation.text ?? "","email_address":txtEmail.text ?? "","password":txtPassword.text ?? "","gender":gender,"privateinfo_status":infoPrivate,"device_type":"1","device_token":AppDelegate.share.deviceToken] as JSONDictionary
        print(params)
        self.view.showHUD()
        APIClient.share.uploadRequest(with: params as! JSONParams, url: URLConstants.share.register, imageData: imageData! as NSData) { (JSON: Any?, _: URLResponse?, _: Error?) in
          //  print(URLConstants.register)
            self.view.hideHUD()
            if let json = JSON as? JSONDictionary {
                print(json)
                if let dictobj = json["meta"] as? JSONDictionary {
                    if dictobj["status"] as! Bool == false {
                        self.view.hideHUD()
                        self.showAlert(title: "Alert", message: dictobj["message"] as? String)
                    } else {
                        self.view.hideHUD()
                        print(json)
                        self.showSuccessAlert(message: dictobj["message"] as? String)
                    }
                }else{
                    self.showAlert(title: "", message: "Data is not in correct format.")
                }
            }else{
                self.showAlert(title: "", message: "Data is not in correct format.")
            }
        }
    }
    
    func showSuccessAlert(message:String?)  {
        let alert = UIAlertController(title: "", message: message ?? "Ragistration successfully.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            self.navigateToBackScreen()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }
    
    
}

extension SignUpViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    /// open camera
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            self .present(picker!, animated: true, completion: nil)
        }
        else
        {
            openGallary()
        }
    }
    
    /// open photo library
    func openGallary()
    {
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(picker!, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imageObj = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imgViewProfile.image = imageObj
        imageData = UIImageJPEGRepresentation(imageObj, 0.5)
        picker.dismiss(animated: true) {
            self.contentViewBottom.constant = (self.scrolview.contentSize.height/2)+20
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion:nil)
        print("picker cancel.")
    }
}

extension SignUpViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == txtName )
        {
            let name_reg = "[a-zA-Z\\s]+"
            
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            
            if name_test.evaluate(with: txtName.text) == false
            {
                let alert = UIAlertController(title: "Information", message: "Enter the name in correct format", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                
                alert.addAction(ok)
                alert.addAction(cancel)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        if (textField == txtPassword)
        {
            let name_reg = "[A-Z0-9a-z._%@+-]{6,10}"
            
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            
            if name_test.evaluate(with: txtPassword.text) == false
            {
                let alert = UIAlertController(title: "Information", message: "Passwords must contain at least six characters", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                
                alert.addAction(ok)
                alert.addAction(cancel)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        if (textField == txtEmail)
        {
            let name_reg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            
            if name_test.evaluate(with: txtEmail.text) == false
            {
                let alert = UIAlertController(title: "Information", message: "Enter the E-mail in correct format", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                
                alert.addAction(ok)
                alert.addAction(cancel)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        if (textField == txtUsername )
        {
            let name_reg = "[A-Za-z0-9]{3,20}"
            
            let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
            
            if name_test.evaluate(with: txtUsername.text) == false
            {
                let alert = UIAlertController(title: "Information", message: "Enter the name in correct format", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                
                alert.addAction(ok)
                alert.addAction(cancel)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
}
