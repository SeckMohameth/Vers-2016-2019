//
//  VideoPlayerViewController.swift
//  Vers
//
//  Created by sagar.gupta on 26/02/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoPlayerViewController: UIViewController {
    
    var strVideo: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setPlayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
    }
    
    func setPlayer()  {
        let videoURL = URL(string: strVideo)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
        
        let btnCross = UIButton(frame: CGRect(x: 20, y: 20, width: 40, height: 40))
        btnCross.setImage(#imageLiteral(resourceName: "cross"), for: .normal)
        btnCross.tintColor = UIColor.white
        btnCross.addTarget(self, action: #selector(navigateToBackScreen), for: .touchUpInside)
        self.view.addSubview(btnCross)
    }


}
