//
//  DiscoveryView.swift
//  Vers
//
//  Created by pawan.sharma on 26/03/18.
//  Copyright © 2018 sagar.gupta. All rights reserved.
//  let userDetailVC = UsersDetailsVC(nibName: "UsersDetailsVC", bundle: nil)
//self.navigationController?.pushViewController(userDetailVC, animated: true)

import UIKit

protocol DiscoveryViewDelegate {
    func playView(datadiscovry:Discovery.ChallengeDetails)
    func seletedTopTenstrkes(streaks:TopTenStreaks.Data)
    
}

class DiscoveryView: UIView {

    @IBOutlet weak var collectionVW: UICollectionView!
    @IBOutlet weak var tblDiscovery: UITableView!
    @IBOutlet weak var topHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btn_viewprofile: UIButton!
    @IBOutlet weak var view_content: UIView!
    @IBOutlet weak var label_Message: UILabel!



    var delegate:DiscoveryViewDelegate!
     var activeDiscoveychallenge:Discovery.ChallengeDetails!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        deafultConfiguration()
    }
    
   
    
    
    
    func deafultConfiguration()  {
        collectionVW.register(UINib(nibName: TopUserCollectionViewCell.stringRepresentation, bundle: nil), forCellWithReuseIdentifier: TopUserCollectionViewCell.stringRepresentation)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
       collectionVW.collectionViewLayout = layout
        collectionVW.contentInset = UIEdgeInsets(top: -10, left: 0, bottom:0, right: 0)

       btn_viewprofile.layer.cornerRadius = 25
        btn_viewprofile.clipsToBounds = true
        self.label_Message.isHidden = true
       if let layout = collectionVW.collectionViewLayout as? UICollectionViewFlowLayout {
           layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            layout.itemSize = CGSize(width: 180, height: 180)
           layout.invalidateLayout()
        }
        
        tblDiscovery.register(UINib(nibName: DiscoveryTableViewCell.stringRepresentation, bundle: nil), forCellReuseIdentifier: DiscoveryTableViewCell.stringRepresentation)
         view_content.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height * 0.25)
        tblDiscovery.tableHeaderView = view_content;
        tblDiscovery.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    @objc func sendervideoPlayAction(sender:UIButton) {
        let url = VersManager.share.discoveryList!.challengeDetails[sender.tag].senderVideoDetails.first?.videoPath
        delegate.playView(datadiscovry: VersManager.share.discoveryList!.challengeDetails[sender.tag])
    }
    
    @objc func receivervideoPlayAction(sender:UIButton) {
        let receiverVideo = VersManager.share.discoveryList?.challengeDetails[sender.tag].receiverVideoDetails.first?.videoPath
        delegate.playView(datadiscovry: VersManager.share.discoveryList!.challengeDetails[sender.tag])
    }
    
    @IBAction func button_viewprofile (_ sender : UIButton) {
     

    }
  
}

extension DiscoveryView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if  VersManager.share.toptenstrkes != nil {
            return  (VersManager.share.toptenstrkes?.data.count)!
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopUserCollectionViewCell.stringRepresentation, for: indexPath) as! TopUserCollectionViewCell
        cell.imgView.sd_setImage(with: VersManager.share.toptenstrkes?.data[indexPath.row].userProfileImagePath, placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
        cell.lblName.text = VersManager.share.toptenstrkes?.data[indexPath.row].name
        cell.lblNum.text = "\(VersManager.share.toptenstrkes?.data[indexPath.row].noWin ?? 0)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.seletedTopTenstrkes(streaks: (VersManager.share.toptenstrkes?.data[indexPath.row])!)
    }
    
}

extension DiscoveryView:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if VersManager.share.discoveryList != nil {
            return  VersManager.share.discoveryList!.challengeDetails.count
        }
       return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DiscoveryTableViewCell.stringRepresentation) as!
          DiscoveryTableViewCell
    
    
          
        cell.selectionStyle = .none
        cell.user1VidePlay.tag = indexPath.row
        cell.user1VidePlay.addTarget(self, action: #selector(sendervideoPlayAction(sender:)), for: .touchUpInside)
        cell.user2VidePlay.addTarget(self, action: #selector(receivervideoPlayAction(sender:)), for: .touchUpInside)
        cell.user2VidePlay.tag = indexPath.row
        cell.setSenderData(senderdata: VersManager.share.discoveryList!.challengeDetails[indexPath.row].senderVideoDetails.first!)
        cell.setReciverData(reciverdata: VersManager.share.discoveryList!.challengeDetails[indexPath.row].receiverVideoDetails.first!)
        let time = VersManager.share.discoveryList!.challengeDetails[indexPath.row].hoursPassed
        if time != "" {
            let truncated = time.substring(to: time.index(before: time.endIndex))
            cell.lblTime.text = truncated
        }else{
            cell.lblTime.text = ""
        }
    
        //userProfileImagePath
    //    cell.user1Videothub.image = VersManager.share.discoveryList!.challengeDetails[indexPath.row].senderVideoDetails.first?.userProfileImagePath
        
        let strimg1 = VersManager.share.discoveryList!.challengeDetails[indexPath.row].senderVideoDetails.first?.thumbImagePath ?? ""
        
        let strimg2 = VersManager.share.discoveryList!.challengeDetails[indexPath.row].receiverVideoDetails.first?.thumbImagePath ?? ""
        
        cell.user1Videothub.sd_setImage(with: URL(string: strimg1), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
        
        cell.user2Videothub.sd_setImage(with: URL(string: strimg2), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
        cell.winImageView.image = UIImage(named: "vs")
        
        let sendervote = VersManager.share.discoveryList!.challengeDetails[indexPath.row].senderVideoDetails.first?.senderVideoVotesCount ?? 0
        let recivervote = VersManager.share.discoveryList!.challengeDetails[indexPath.row].receiverVideoDetails.first?.recieverVideoVotesCount ?? 0
        let voteCount = recivervote + sendervote
        
        cell.btnVote.setTitle("\(voteCount) Votes", for: .normal)
        activeDiscoveychallenge = VersManager.share.discoveryList!.challengeDetails[indexPath.row]
        
        let senderView = VersManager.share.discoveryList!.challengeDetails[indexPath.row].senderVideoDetails.first?.senderVideoViewsCount ?? 0
        let reciverView = VersManager.share.discoveryList!.challengeDetails[indexPath.row].receiverVideoDetails.first?.recieverVideoViewsCount ?? 0
        let viewCount = senderView + reciverView
        cell.btnViews.setTitle("\(viewCount) Views", for: .normal)
    
        
        if VersManager.share.discoveryList?.challengeDetails[indexPath.row].postExpiryStatus == "expired" {
            if (VersManager.share.discoveryList?.challengeDetails[indexPath.row].wonStatus == "won_by_sender") {
                if (VersManager.share.discoveryList?.challengeDetails[indexPath.row].wonBy == VersManager.share.discoveryList?.challengeDetails[indexPath.row].senderId ) {
                    cell.winImageView.image = UIImage(named: "left-arrow (3)")
                }
                
                //           cell.winImageView.sd_setImage(with: URL(string: "right-arrow"), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly) right-arrow (3)
                
            } else if ( VersManager.share.discoveryList?.challengeDetails[indexPath.row].wonStatus == "won_by_receiver") {
                if (VersManager.share.discoveryList?.challengeDetails[indexPath.row].wonBy == VersManager.share.discoveryList?.challengeDetails[indexPath.row].recieverId ) {
                    cell.winImageView.image = UIImage(named: "Right-arrow (3) 2")
                }
                
                //   cell.winImageView.sd_setImage(with: URL(string: "left-arrow"), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
                
            } else if (VersManager.share.discoveryList?.challengeDetails[indexPath.row].wonStatus == "tied") {
                //  cell.winImageView.sd_setImage(with: URL(string: "equality-sign"), placeholderImage: #imageLiteral(resourceName: "dummy"), options: .cacheMemoryOnly)
                cell.winImageView.image = UIImage(named: "equality-sign")
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
    
 
    
}
