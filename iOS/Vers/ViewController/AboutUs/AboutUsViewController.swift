//
//  AboutUsViewController.swift
//  Vers
//
//  Created by sagar.gupta on 15/02/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    
    
    @IBOutlet weak var socialVW: UIView!
    @IBOutlet weak var outerVW1: UIView!
    @IBOutlet weak var outerVW2: UIView!
    @IBOutlet weak var outerVW3: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     //   configuration()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        self.navigationItem.title = "About us"
        self.addMenuButton(image: "menu")
    }
    
   // func configuration()  {
//        outerVW1.showShadow()
//        outerVW2.showShadow()
//        outerVW3.showShadow()
//        socialVW.showShadow()
 //   }
    
    @IBAction func btnPrivacyPolicyAction(sender:UIButton) {
        

        let vc = self.storyboard?.instantiateViewController(withIdentifier: AppInfoViewController.stringRepresentation) as! AppInfoViewController
        vc.topTitle = "Privacy Policy"
        vc.page_title = Constent.Privacy_Policy
    
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnTermsandConditionsAction(sender:UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: AppInfoViewController.stringRepresentation) as! AppInfoViewController
        vc.topTitle = "Terms and Conditions"
        vc.page_title = Constent.Terms_and_Conditions
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnCommunityGuidlinesAction(sender:UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: AppInfoViewController.stringRepresentation)
        as! AppInfoViewController
        vc.topTitle = "Community Guidlines"
        vc.page_title = Constent.Community_GuideLines
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnFacebookAction(sender:UIButton) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: AppInfoViewController.stringRepresentation)
//            as! AppInfoViewController
//        vc.topTitle = "Social media"
//        vc.page_title = Constent.Facebook
//        self.navigationController?.pushViewController(vc, animated: true)
        featchPagedetailsApiCall(page_title: Constent.Facebook)
    }
    
    @IBAction func btnTwitterAction(sender:UIButton) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: AppInfoViewController.stringRepresentation)
//            as! AppInfoViewController
//        vc.topTitle = "Social media"
//        vc.page_title = Constent.Twitter
//        self.navigationController?.pushViewController(vc, animated: true)
        featchPagedetailsApiCall(page_title: Constent.Twitter)
    }
    
    @IBAction func btnInstagramAction(sender:UIButton) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: AppInfoViewController.stringRepresentation)
//            as! AppInfoViewController
//        vc.topTitle = "Social media"
//        vc.page_title = Constent.Instagram
//        self.navigationController?.pushViewController(vc, animated: true)
        featchPagedetailsApiCall(page_title: Constent.Instagram)
    }
    
    @IBAction func btnTumblerAction(sender:UIButton) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: AppInfoViewController.stringRepresentation)
//            as! AppInfoViewController
//        vc.topTitle = "Social media"
//        vc.page_title = Constent.Tumblr
//        self.navigationController?.pushViewController(vc, animated: true)
        featchPagedetailsApiCall(page_title: Constent.Tumblr)
    }
    
    @IBAction func btnYoutubeAction(sender:UIButton) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: AppInfoViewController.stringRepresentation)
//            as! AppInfoViewController
//        vc.topTitle = "Social media"
//        vc.page_title = Constent.You_Tube
//        self.navigationController?.pushViewController(vc, animated: true)
        featchPagedetailsApiCall(page_title: Constent.You_Tube)
    }
    
    
    fileprivate func featchPagedetailsApiCall(page_title:String) {
        self.view.showHUD()
        let params = ["page_title":page_title] as JSONDictionary
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.pagedetails) { (JSON: Any?, _: URLResponse?, _: Error?) in
            self.view.hideHUD()
            if let json = JSON as? JSONDictionary {
                print(json)
                let dictobj = json["meta"] as! JSONDictionary
                if dictobj["status"] as! Bool == false {
                    self.view.hideHUD()
                    self.showAlert(title: "Alert", message: dictobj["message"] as? String)
                } else {
                    self.view.hideHUD()
                    let dictobj1 = json["data"] as! JSONDictionary
                    let content = dictobj1["content"] as! String
                    print(json)
                    self.loadUrl(url: content)
                }
            }else{
                self.showAlert(title: "", message: "Data is not in correct format.")
            }
        }
    }
    
    func loadUrl(url:String)  {
        guard let url = URL(string: url) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    

}
