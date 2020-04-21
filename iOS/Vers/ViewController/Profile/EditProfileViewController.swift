//
//  EditProfileViewController.swift
//  Vers
//
//  Created by sagar.gupta on 15/02/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    @IBOutlet var blackContentView: UIView!
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
    @IBOutlet weak var contentViewBottom: NSLayoutConstraint!
    var gender:String!
    var infoPrivate: String!
    
    var picker:UIImagePickerController?=UIImagePickerController()
    var imageData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configuration()
        setUserData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        self.navigationItem.title = "Edit Profile"
        self.backButton(image: "back")
        let saveImg = UIImage(named: "save")
        navigationItem.hidesBackButton = true
        let savebtn = UIBarButtonItem(image: saveImg, style: UIBarButtonItemStyle.plain, target:
            self, action: #selector(saveUserInfo))
        //255 56 77
        savebtn.tintColor = UIColor(red: 255/255.0, green: 56/255.0, blue: 77/255.0, alpha: 1.0)
        navigationItem.rightBarButtonItem = savebtn
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if DeviceType.IS_IPHONE_5 {
//            scrolview.contentInset = UIEdgeInsetsMake(0, 0,74, 0)
//            scrolview.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height+100)
//            self.contentViewBottom.constant = (self.scrolview.contentSize.height/2)
//        }else{
//            self.scrolview.contentInset = UIEdgeInsetsMake(0, 0,74, 0)
//            scrolview.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height+100)
//            self.contentViewBottom.constant = (self.scrolview.contentSize.height/4)
//        }
    }
    
    func configuration()  {
        blackContentView.layer.cornerRadius = 10
        blackContentView.layer.masksToBounds = true
        
        imgViewProfile.layer.cornerRadius = imgViewProfile.frame.size.height/2
        imgViewProfile.layer.masksToBounds = true
        imgViewProfile.layer.borderWidth = 2
        imgViewProfile.layer.borderColor = UIColor(red: 255.0/255.0, green: 56/255.0, blue: 57/255.0, alpha: 1.0).cgColor
        
        btnImageUpload.layer.cornerRadius = btnImageUpload.frame.size.height/2
        btnImageUpload.layer.masksToBounds = true
        btnImageUpload.layer.borderWidth = 2
        btnImageUpload.layer.borderColor = UIColor.black.cgColor
        
        //txtName.addLfetViewImage(image: "reduser")
        //txtName.setLeftPaddingPoints(10)
        //txtName.setRedBottomBorder(frame: txtName.frame)
        
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
        btnFeMale.tag = 1
        
        picker?.delegate = self
    }
    
    func setUserData()  {
        if VersManager.share.profileInfo != nil {
            imgViewProfile.sd_setImage(with: URL(string: VersManager.share.profileInfo.userData.userProfileImagePath.absoluteString), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
            txtName.text = VersManager.share.profileInfo.userData.name
            txtLocation.text = VersManager.share.profileInfo.userData.userLocation
            txtEmail.text =  VersManager.share.profileInfo.userData.userEmail
            txtUsername.text = VersManager.share.profileInfo.userData.userName
            //lblWin.text = VersManager. share.profileInfo.userData.
            if VersManager.share.profileInfo.userData.userGender ==  "male" {
                gender = "male"
                btnMale.setImage(#imageLiteral(resourceName: "ellipse"), for: .normal)
                btnFeMale.setImage(UIImage(named: ""), for: .normal)
            }else if (VersManager.share.profileInfo.userData.userGender == "female"){
                gender = "female"
                btnFeMale.setImage(#imageLiteral(resourceName: "ellipse"), for: .normal)
                btnMale.setImage(UIImage(named: ""), for: .normal)
            } else {
                gender = ""
               
                btnMale.setImage(UIImage(named: ""), for: .normal)
                btnFeMale.setImage(UIImage(named: ""), for: .normal)
            }
            
            if VersManager.share.profileInfo.userData.userPrivateInfoStatus == "public"{
                infoPrivate = "public"
                infoswitch.setOn(false, animated: true)
            }else{
                infoswitch.setOn(true, animated: true)
                infoPrivate = "private"
            }
            
            imageData = UIImageJPEGRepresentation(imgViewProfile.image!, 1.0)
        }
    }
    
    @objc func saveUserInfo()  {
        if validation() {
            editApiCall()
        }
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
        //        if  (txtPassword.text?.isEmpty)! {
        //            self.showAlert(title: "", message: "Enter password.")
        //            return false
        //        }
        if  imageData == nil {
            self.showAlert(title: "", message: "upload profile image.")
            return false
        }
        return true
    }
    
    fileprivate func editApiCall() {
        let params = ["user_id":VersManager.share.userLogin?.data.first?.id ?? 0,"name":txtName.text! ,"user_name":txtUsername.text!,"representing_location":txtLocation.text!,"email_address":txtEmail.text!,"gender":gender,"privateinfo_status":infoPrivate] as [String : Any]
        self.view.showHUD()
        APIClient.share.uploadRequest(with: params as! JSONParams, url: URLConstants.share.editprofile, imageData: imageData! as NSData) { (JSON: Any?, _: URLResponse?, _: Error?) in
            self.view.hideHUD()
            if let json = JSON as? JSONDictionary {
                print(json)
                if let dictobj = json["meta"] as? JSONDictionary{
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
                        let alert = UIAlertController(title: "Alert", message: "Profile updated successfully", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: self.finishAlert))
                        self.present(alert, animated: true, completion: nil)
                       // self.showAlert(title: "Alert", message: dictobj["message"] as? String)
                        //self.showSuccessAlert()
                    }
                }
            }else{
                self.showAlert(title: "", message: "Data is not in correct format.")
            }
        }
    }
    func finishAlert(alert: UIAlertAction!)
    {
        self.navigationController?.popViewController(animated: true)
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
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
            //self.contentViewBottom.constant = (self.scrolview.contentSize.height/2)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion:nil)
        print("picker cancel.")
    }
}
