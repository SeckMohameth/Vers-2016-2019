//
//  AppInfoViewController.swift
//  Vers
//
//  Created by sagar.gupta on 16/02/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit

class AppInfoViewController: UIViewController {
    
    var topTitle: String!
    var page_title: String!
    @IBOutlet weak var appinfoWebView:UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        self.navigationItem.title = topTitle
        self.backButton(image: "back")
        featchPagedetailsApiCall()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if DeviceType.IS_IPHONE_5 {
            appinfoWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0,64, 0)
        }
    }
    
    func loadUrl(url:String)  {
            
        appinfoWebView.loadRequest(URLRequest(url: URL(string: url)!))
        appinfoWebView.delegate = self;
    }
    
    func loadHTMLContent(pageContent:String)
    {
        self.appinfoWebView.loadHTMLString(pageContent, baseURL: nil)
    }
    
    fileprivate func featchPagedetailsApiCall() {
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
//                    if self.topTitle == "Social media" {
//                        self.loadUrl(url: content)
//                    }else{
//                        self.loadHTMLContent(pageContent: content)
//                    }
                }
            }else{
                self.showAlert(title: "", message: "Data is not in correct format.")
            }
        }
    }
}

extension AppInfoViewController:UIWebViewDelegate {
   
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.view.showHUD()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.view.hideHUD()
    }
}
