//
//  URLConstants.swift
//  app
//
//  UCash
//
//  Created by Sagar.Gupta on 05/06/17.
//  Copyright © 2017 Sagar.Gupta. All rights reserved.
//

import UIKit

internal final class URLConstants: NSObject {
    // Do not allow instantiation of the class
    private override init() {}
    var baseurlString: String? = "http://18.205.82.97/api/v1"
    /// Base URL
    static let share = URLConstants.init()
    private  var baseURL: String {

   // return "http://versapp.hiteshi.com/api/v1"
    // return "http://versappadmin-com.stackstaging.com/api/v1"
     // return "http://18.205.82.97/api/v1"
        if let url = baseURLFromServer{
            return url;
        }else{
            return ""
        }
    
    }
    lazy var baseURLFromServer: String? = {
        if let url = baseurlString {
            return url
        }else{
            APIClient.share.getRequest(withURL: "http://versapp.hiteshi.com/apiurl.json" ) { (JSON: Any?, _: URLResponse?, _: Error?) in
                if let json = JSON as? JSONDictionary {
                    print(json)
                    if let url = json ["apiurl"] as? String{
                        self.baseurlString = url;
                      
                    }
                    
                    
                }
            }
            
        }
      return  baseurlString;
        
    }()
    /// User login
     var login: String {
        return baseURL + "/Login/login"
    }
    
    /// User register
     var register: String {
        return baseURL + "/Authentication/register"
    }
    
    
    /// Forgot password
     var forgotpassword: String {
        return baseURL + "/ForgotPassword/forgotpassword"
    }
    
    /// Logout password
     var logout: String {
        return baseURL + "/Logout/userlogout"
    }
    
    /// profile
     var profile: String {
        return baseURL + "/FetchLoggedInUserDetails/fetchuserdetails"
    }
    
    /// edit profile
     var editprofile: String {
        return baseURL + "/EditProfile/editprofile"
    }

    /// change password
     var changepassword: String {
        return baseURL + "/ChangePassword/setNewPassword"
    }
    
    /// show pagedetails
     var pagedetails: String {
        return baseURL + "/AppPageDetails/pagedetails"
    }
    
    /// userlist
     var userlist: String {
        return baseURL + "/GetUsersList/userslist"
    }
    
    /// sendchallenge
     var sendchallenge: String {
        return baseURL + "/SendChallenge/sendchallenge"
    }
    
    /// get sentvers
     var sentvers: String {
        return baseURL + "/FetchSentVers/sentvers"
    }///FetchReactedVers/reactedvers
    
    /// get reactedvers
     var reactedvers: String {
        return baseURL + "/FetchReactedVers/reactedvers"
    }
    
    /// receivedvers
     var receivedvers: String {
        return baseURL + "/FetchReceivedVers/receivedvers"
    }
    
    /// FetchVersReplies repliedvers
     var fetchVersReplies: String {
        return baseURL + "/FetchVersReplies/repliedvers"
    }
    
    /// home challenges
     var homechallenges: String {
        return baseURL + "/Home/challenges"
    }///Discovery/discovery
    
    /// discovery
     var discovery: String {
        return baseURL + "/Discovery/discovery"
    }//
    
    /// toptenStreaks
     var toptenStreaks: String {
        return baseURL + "/TopTenStreaks/streaks"
    }
    
    /// post challenge
     var postchallenge: String {
        return baseURL + "/PostChallenge/postchallenge"
    }//
    
    /// veto challenge
     var vetochallenge: String {
        return baseURL + "/VetoChallenge/vetochallenge"
    }//
    
    /// accept challenge
     var acceptchallenge: String {
        return baseURL + "/AcceptChallenge/acceptchallenge"
    }
    
    /// decline challenge
     var declinechallenge: String {
        return baseURL + "/DeclineChallenge/declinechallenge"
    }

    /// FetchNotifications
     var fetchNotifications: String {
        return baseURL + "/FetchNotifications/notifications"
    }
    
    /// DropChallenge/dropchallenge
     var dropchallenge: String {
        return baseURL + "/DropChallenge/dropchallenge"
    }
    
    /// DropChallenge/dropchallenge
     var tryagain: String {
        return baseURL + "/TryAgain/tryagain"
    }
    
    /// ChangeRecepient
     var changerecepient: String {
        return baseURL + "/ChangeRecepient/changerecepient"
    }///ProfileSettings/settings
    
    /// ProfileSettings
     var profileSettings: String {
        return baseURL + "/ProfileSettings/settings"
    }
    
    /// activevers
     var activevers: String {
        return baseURL + "/ActiveVers/activevers"
    }
    
    /// followingusers
     var followingusers: String {
        return baseURL + "/FollowingUserDetails/followingusers"
    } //
    
    /// followers
     var followers: String {
        return baseURL + "/FollowerDetails/followers"
    }
    
    /// userwins
     var userwins: String {
        return baseURL + "/UserWinsList/userwins"
    }//
    
    /// GetChallenges
     var challenges: String {
        return baseURL + "/GetChallenges/challenges"
    }
  
    /// SendFollowRequest
     var sendfollowrequest: String {
        return baseURL + "/SendFollowRequest/sendrequest"
    } //
    
    /// requeststatusupdate
     var requeststatusupdate: String {
        return baseURL + "/FollowRequestStatus/requeststatusupdate"
    }//
    
    /// AddVideoViews
     var addviews: String {
        return baseURL + "/AddVideoViews/addviews"
    } //
    
    /// AddVotes
     var addvotes: String {
        return baseURL + "/AddVotes/addvotes"
    }
    //Report
     var reports: String {
        return baseURL + "/Report/report"
    }
    
    //Unfollow
     var unfollow: String {
        return baseURL + "/UnFollowUser/unfollow"
    }
    // Blockurl :- http://versapp.hiteshi.com/api/v1/BlockUser/block
    
   
     var block : String {
        return baseURL + "/BlockUser/block"
    }
    
    // FeedBack
     var feedback : String {
        return baseURL + "/UserFeedbacks/feedbacks"
    }
}
