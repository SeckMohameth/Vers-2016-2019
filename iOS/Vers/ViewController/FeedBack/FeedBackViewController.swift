//
//  FeedBackViewController.swift
//  Vers
//
//  Created by Nishant.Tiwari on 24/04/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit

class FeedBackViewController: UIViewController {

   
    @IBOutlet weak var textview_description : UITextView!
    @objc var isfeedback = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textview_description.layer.borderColor = UIColor(red: 0.9 , green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        textview_description.layer.borderWidth = 1.0
        textview_description.layer.cornerRadius = 5
     //   textview_description.text = "Description"
        textview_description.textColor = UIColor.black
        
       self.navigationItem.title = "Feedback Form"
        // Do any additional setup after loading the view.
        textview_description.text = ""
        self.textview_description.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        textview_description.layer.cornerRadius = 10
    //    textview_description.layer.borderColor = UIColor.gray as! CGColor
    }

    @IBAction func button_send (_ sender : UIButton) {
        if (textview_description.text?.isEmpty)! {
            self.showAlert(title: "Alert", message: "Please Write something on description")
        } else {
            self.feedbackApiCall()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addMenuButton(image: "menu")
    }
    
}

extension FeedBackViewController : UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textview_description.text.isEmpty {
            textview_description.text = "Description"
            textview_description.textColor = UIColor.lightGray
        }
    
}
}

// Mark :- Api calling

extension FeedBackViewController {
    
    
    internal func addMenuButtonfeedback(image imageName: String?) {
        let menuImg = UIImage(named: imageName ?? "menu")
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: menuImg, style: UIBarButtonItemStyle.plain, target:
            self, action: #selector(openLeftView(_:)))
    }
    
    func showChangeRecipientSuccessAlert(message:String?)  {
        let alert = UIAlertController(title: "", message: message ?? "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
             let str = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                   self.navigationController?.pushViewController(str, animated: true)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }
    
    fileprivate func feedbackApiCall() {
        self.view.showHUD()
        let params = ["user_id":VersManager.share.userLogin?.data.first?.id ?? 0,"feedback" :textview_description.text! ] as JSONDictionary
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.feedback) { (JSON: Any?, _: URLResponse?, _: Error?) in
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
    
}


