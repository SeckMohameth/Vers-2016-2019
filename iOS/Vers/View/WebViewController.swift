//
//  WebViewController.swift
//  Vers
//
//  Created by sagar.gupta on 16/03/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit

class WebViewController: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL (string: "https://app.termly.io/document/terms-of-use-for-website/9bf28c37-858c-4898-8290-616d2ba607cf")
        let requestObj = URLRequest(url: url!)
        webView.loadRequest(requestObj)
        webView.delegate = self
        self.view.showHUD()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackAction(semder:UIButton) {
        self.navigateToBackScreen()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.view.hideHUD()
    }

}
