//
//  LeftViewController.swift
//  LGSideMenuControllerDemo
//


class LeftViewController: UITableViewController {
    
    private let titlesArray = [
        "Home",
        "Profile",
        "Versus",
        "Settings",
        "About us",
        "FeedBack"
    ]
    private let titlesArrayIcon = [
        "home",
        "userIcon",
        "vsIcon",
        "setting",
        "aboutus",
        "aboutus"
    ]
    
    private let titlesArrayredIcon = [
        "redhome",
        "reduser",
        "redvsIcon",
        "redsetting",
        "redaboutus",
        "redaboutus"
    ]
    
    var seletedIdx:Int = 0
    var vote : VersVoteView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0.0, bottom: 44.0, right: 0.0)
           let btnCross = UIButton(frame: CGRect(x: 10, y: 0, width: 50, height: 50))
           btnCross.setTitle("X", for: .normal)
           btnCross.titleLabel?.font = UIFont(name: "Rubik-Medium", size: 22)
           btnCross.setTitleColor(UIColor(red: 149/255.0, green: 168/255.0, blue: 185/255.0, alpha: 1.0), for: .normal)
           btnCross.addTarget(self, action: #selector(hideSideView), for: .touchUpInside)
           self.view.addSubview(btnCross)
           self.view.bringSubview(toFront: btnCross)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    @objc func hideSideView()  {
        let mainViewController = sideMenuController!
        mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
    }
    
    fileprivate func logoutApiCall() {
        self.view.showHUD()
        let params = ["user_id":VersManager.share.userLogin?.data.first?.id ?? 0] as JSONDictionary
        APIClient.share.postRequestAfterLogin(withParams: params, url: URLConstants.share.logout) { (JSON: Any?, _: URLResponse?, _: Error?) in
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
                        self.showSuccessAlert(message: dictobj["message"] as? String ?? "Logout successfully.")
                    }
                }else{
                     self.showSuccessAlert(message: json["message"] as? String ?? "Logout successfully.")
                }
               
            }else{
                self.showAlert(title: "", message: "Data is not in correct format.")
            }
        }
    }
    
    func showSuccessAlert(message:String?)  {
        let alert = UIAlertController(title: "", message: message ?? "Ragistration successfully.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            VersManager.share.versReceived = nil
            VersManager.share.homeList = nil
            VersManager.share.versRepliedList = nil
            VersManager.share.versSent = nil
            UserDefaults.standard.removeObject(forKey: "userinfo")
            self.navigateToLoginScreen()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }else if section == 2 {
            return 4
        }else if section == 1 {
            return titlesArray.count
        }else{
            return 0
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LeftViewCell
        //149 168 185
        if indexPath.section == 0 {
             
        }else if indexPath.section == 1 {
            cell.titleLabel.textColor = UIColor(red: 149/255.0, green: 149/255.0, blue: 149/255.0, alpha: 1.0)
            cell.titleLabel.font = UIFont(name: "Rubik-Medium", size: 17.8)
            cell.titleLabel.text = titlesArray[indexPath.row]
            
            if seletedIdx == indexPath.row {
                cell.contentView.backgroundColor = UIColor(red: 243/255.0, green: 243/255.0, blue: 243/255.0, alpha: 1.0)
                cell.imgIcon.image = UIImage(named: titlesArrayredIcon[indexPath.row])
                cell.imgLeftLine.backgroundColor = UIColor.red
            }else{
                cell.imgIcon?.image = UIImage(named: titlesArrayIcon[indexPath.row])
                cell.contentView.backgroundColor = UIColor.clear
                cell.imgLeftLine.backgroundColor = UIColor.clear
            }
        }else if indexPath.section == 2 {
            if indexPath.row == 3 {
                cell.titleLabel.textColor = UIColor.red
                cell.titleLabel.font = UIFont(name: "Rubik-Medium", size: 26.6)
                cell.titleLabel.text = "Logout"
                cell.imgLogoutIcon?.image = UIImage(named: "logout")
            }else{
                
            }
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainViewController = sideMenuController!
        
        switch indexPath.section {
        case 0:
            break
        case 1:
            seletedIdx = indexPath.row
            tableView.reloadData()
            let selectedCell:LeftViewCell = tableView.cellForRow(at: indexPath)! as! LeftViewCell
            selectedCell.contentView.backgroundColor = UIColor(red: 243/255.0, green: 243/255.0, blue: 243/255.0, alpha: 1.0)
         //   vote.isHidden = true
            selectedCell.imgIcon.image = UIImage(named: titlesArrayredIcon[indexPath.row])
            selectedCell.imgLeftLine.backgroundColor = UIColor.red
            if indexPath.row == 0 {
                let navigationController = mainViewController.rootViewController as! NavigationController
                let viewController: UIViewController!
                
                if navigationController.viewControllers.first is HomeViewController {
                    mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
                }
                else {
                    viewController = self.storyboard!.instantiateViewController(withIdentifier: "HomeViewController")
                    navigationController.setViewControllers([viewController], animated: false)
                    
                    // Rarely you can get some visual bugs when you change view hierarchy and toggle side views in the same iteration
                    // You can use delay to avoid this and probably other unexpected visual bugs
                    mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
                }
            }
            if indexPath.row == 1 {
                let navigationController = mainViewController.rootViewController as! NavigationController
                let viewController: UIViewController!
                
                if navigationController.viewControllers.first is ProfileViewController {
                    mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
                }
                else {
                    viewController = self.storyboard!.instantiateViewController(withIdentifier: "ProfileViewController")
                    navigationController.setViewControllers([viewController], animated: false)
                    
                    // Rarely you can get some visual bugs when you change view hierarchy and toggle side views in the same iteration
                    // You can use delay to avoid this and probably other unexpected visual bugs
                    mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
                }
            }
            if indexPath.row == 2 {
                let navigationController = mainViewController.rootViewController as! NavigationController
                let viewController: UIViewController!
                
                if navigationController.viewControllers.first is VersusViewController {
                    mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
                }
                else {
                    viewController = self.storyboard!.instantiateViewController(withIdentifier: "VersusViewController")
                    navigationController.setViewControllers([viewController], animated: false)
                    
                    // Rarely you can get some visual bugs when you change view hierarchy and toggle side views in the same iteration
                    // You can use delay to avoid this and probably other unexpected visual bugs
                    mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
                }
            }
            if indexPath.row == 3 {
                let navigationController = mainViewController.rootViewController as! NavigationController
                let viewController: UIViewController!
                
                if navigationController.viewControllers.first is SettingsViewController {
                    mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
                }
                else {
                    viewController = self.storyboard!.instantiateViewController(withIdentifier: "SettingsViewController")
                    navigationController.setViewControllers([viewController], animated: false)
                    
                    // Rarely you can get some visual bugs when you change view hierarchy and toggle side views in the same iteration
                    // You can use delay to avoid this and probably other unexpected visual bugs
                    mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
                }
            }
            if indexPath.row == 4 {
                let navigationController = mainViewController.rootViewController as! NavigationController
                let viewController: UIViewController!
                
                if navigationController.viewControllers.first is AboutUsViewController {
                    mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
                }
                else {
                    viewController = self.storyboard!.instantiateViewController(withIdentifier: "AboutUsViewController")
                    navigationController.setViewControllers([viewController], animated: false)
                    
                    // Rarely you can get some visual bugs when you change view hierarchy and toggle side views in the same iteration
                    // You can use delay to avoid this and probably other unexpected visual bugs
                    mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
                }
            }
            if indexPath.row == 5 {
                let navigationController = mainViewController.rootViewController as! NavigationController
                let viewController: UIViewController!
                
                if navigationController.viewControllers.first is FeedBackViewController {
                    mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
                }
                else {
                    viewController = self.storyboard!.instantiateViewController(withIdentifier: "FeedBackViewController")
                    navigationController.setViewControllers([viewController], animated: false)
                    
                    // Rarely you can get some visual bugs when you change view hierarchy and toggle side views in the same iteration
                    // You can use delay to avoid this and probably other unexpected visual bugs
                    mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
                }
            }
            break
        case 2:
            if indexPath.row == 3 {
                self.logoutApiCall()
            }
            break
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let selectedCell:LeftViewCell = tableView.cellForRow(at: indexPath)! as! LeftViewCell
            selectedCell.contentView.backgroundColor = UIColor.clear
            selectedCell.imgIcon?.image = UIImage(named: titlesArrayIcon[indexPath.row])
            selectedCell.imgLeftLine.backgroundColor = UIColor.clear
        }
    }
    
}
