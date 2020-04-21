//
//  APIClient.swift
//  UCash
//
//  Created by Sagar.Gupta on 05/06/17.
//  Copyright © 2017 Sagar.Gupta. All rights reserved.
//

import UIKit

typealias JSONDictionary = [String: Any]

typealias JSONParams = [String: AnyHashable]

typealias CompletionBlock = (Any?, URLResponse?, Error?) -> Void

final class ReachabilityWrapper: NSObject {
    
    /// Shared reachability instance across the app.
    static let sharedReach = Reachability()
    private override init() {
  
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}

fileprivate enum HttpMethods: String {
    case post = "POST"
    case put = "PUT"
    case get = "GET"
    case delete = "DELETE"
}

struct Admin {
    static let username:String = "versAdmin"
    static let password:String = "vers@123456"
    static let language:String = "en"
}

class APIClient: NSObject {
    
    /// Comletion block to execute on completion of api call.
    private var completionHandler: CompletionBlock?
    
    override init() {
        super.init()
        checkNetwork()
        NotificationCenter.default.addObserver(self, selector: #selector(resumeTask), name: ReachabilityChangedNotification, object: nil)
        
    }
    
    func checkNetwork()  {
        do {
            try ReachabilityWrapper.sharedReach?.startNotifier()
        } catch  {
            
        }
        
//        ReachabilityWrapper.sharedReach?.whenUnreachable? = {_ in
//            NotificationCenter.default.post(name: AppDelegate.share.notificationName, object: nil)
//        }
    }
    
   static let share = APIClient.init()
          var arrUploadTask = Array<URLSessionUploadTask>()
          var arrDataTask = Array<URLSessionDataTask>()
    
    
    
    /// File upload request
    ///
    /// - Parameters:
    ///   - params: Parameters to send along with the file data.
    ///   - _urlString: URL for service.
    ///   - _filePath: Full path of the file to upload
    ///   - requestCompletion: Code block to execure when request finishes.
    
    
    func uploadVideoRequest(with params: JSONParams, url _urlString: String,viedoKey: String, imageData: NSData?, completion requestCompletion: CompletionBlock?) {
        let reachabilityStatus = ReachabilityWrapper.sharedReach!.currentReachabilityStatus
        if reachabilityStatus == Reachability.NetworkStatus.notReachable {
            let errorObj: JSONDictionary = ["status": false, "message": "Please check your internet connectivity!"]
            if let completion = requestCompletion {
                completion(errorObj, nil, nil)
                return
            }
        }
        
        guard let _url = URL.init(string: _urlString) else {
            return
        }
        
        var request = URLRequest(url: _url)
        request.httpMethod = HttpMethods.post.rawValue
        let boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
        let headerBoundary = "multipart/form-data; boundary=" + boundary
        request.addValue(headerBoundary, forHTTPHeaderField: "Content-Type")
        
        let loginString = String(format: "%@:%@", Admin.username, Admin.password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        let authString = "Basic \(base64LoginString)"
        
        
        let headers = [
            "content-type": headerBoundary,
            "language": Admin.language,
            "authorization": authString,
            "cache-control": "no-cache",
            ]
        
        request.allHTTPHeaderFields = headers
        
        request.timeoutInterval = 120
        
        if VersManager.share.userLogin != nil {
            request.addValue((VersManager.share.userLogin!.data.first?.userAccessToken)!, forHTTPHeaderField: "Auth-Token")
        }
        request.addValue(Admin.language, forHTTPHeaderField: "Language")
        completionHandler = requestCompletion
        
        request.httpBody  = createBody(parameters: params,
                                       boundary: boundary,
                                       data: imageData! as Data,
                                       mimeType: "video/mp4",
                                       filename: "video.mp4",parameter:viedoKey )
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
      //  request.timeoutInterval = 300
    let task =     URLSession.shared.dataTask(with: request) { (responseData, responseObj, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            OperationQueue.main.addOperation {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if let completion = self.completionHandler, let d = responseData {
                print(d)
                let returnData = String(data: d, encoding: .utf8)
                print(returnData ?? "nil")
                do {
                    let jsonObj = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.allowFragments)
                    
                    OperationQueue.main.addOperation {
                        print(jsonObj)
                        completion(jsonObj, responseObj, error)
                    }
                } catch {
                    OperationQueue.main.addOperation {
                        completion(["status": false, "message": error.localizedDescription], responseObj, error)
                    }
                }
        }}
        

       // arrUploadTask.append(task)
        task.resume()
    }
    
    func createBody(parameters:  [String: AnyHashable],
                    boundary: String,
                    data: Data,
                    mimeType: String,
                    filename: String,parameter : String) -> Data {
        var body = Data()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(string:boundaryPrefix)
            body.appendString(string:"Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string:"\(value)\r\n")
        }
        
        body.appendString(string:boundaryPrefix)
        body.appendString(string:"Content-Disposition: form-data; name=\"\(parameter)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string:"Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString(string:"\r\n")
        body.appendString(string:"--".appending(boundary.appending("--")))
        
        return body as Data
    }
    
    /// File upload request
    ///
    /// - Parameters:
    ///   - params: Parameters to send along with the file data.
    ///   - _urlString: URL for service.
    ///   - _filePath: Full path of the file to upload
    ///   - requestCompletion: Code block to execure when request finishes.
    func uploadRequest(with params: JSONParams, url _urlString: String, imageData: NSData?, completion requestCompletion: CompletionBlock?) {
        let reachabilityStatus = ReachabilityWrapper.sharedReach!.currentReachabilityStatus
        if reachabilityStatus == Reachability.NetworkStatus.notReachable {
            let errorObj: JSONDictionary = ["status": false, "message": "Please check your internet connectivity!"]
            if let completion = requestCompletion {
                completion(errorObj, nil, nil)
                return
            }
        }
        
        guard let _url = URL.init(string: _urlString) else {
            return
        }
  
        var request = URLRequest(url: _url)
        request.httpMethod = HttpMethods.post.rawValue
        let boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
        let headerBoundary = "multipart/form-data; boundary=" + boundary
        request.addValue(headerBoundary, forHTTPHeaderField: "Content-Type")
        
        let loginString = String(format: "%@:%@", Admin.username, Admin.password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        let authString = "Basic \(base64LoginString)"
        
        
        let headers = [
            "content-type": headerBoundary,
            "language": Admin.language,
            "authorization": authString,
            "cache-control": "no-cache",
            ]
        
        request.allHTTPHeaderFields = headers
        
        request.timeoutInterval = 180
        if VersManager.share.userLogin != nil {
            request.addValue((VersManager.share.userLogin!.data.first?.userAccessToken)!, forHTTPHeaderField: "Auth-Token")
        }
        request.addValue(Admin.language, forHTTPHeaderField: "Language")
        completionHandler = requestCompletion
     
         request.httpBody  = createBody(parameters: params,
                   boundary: boundary,
                   data: imageData! as Data,
                   mimeType: "image/jpg",
                   filename: "image.jpg",parameter:"profile_image" )

      
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
      //  request.timeoutInterval = 300
        URLSession.shared.dataTask(with: request) { (responseData, responseObj, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            OperationQueue.main.addOperation {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if let completion = self.completionHandler, let d = responseData {
                print(d)
                let returnData = String(data: d, encoding: .utf8)
                print(returnData ?? "nil")
                do {
                    let jsonObj = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.allowFragments)
                    
                    OperationQueue.main.addOperation {
                        print(jsonObj)
                        completion(jsonObj, responseObj, error)
                    }
                } catch {
                    OperationQueue.main.addOperation {
                        completion(["status": false, "message": error.localizedDescription], responseObj, error)
                    }
                }
            }
            }.resume()

    }
    
  
    
    /// POST request
    ///
    /// - Parameters:
    ///   - postParams: parameters to send
    ///   - urlString: Full URL of the service
    ///   - requestCompletion: Code block to execure when request finishes
    func postRequest(withParams postParams: JSONDictionary, url urlString: String, completion requestCompletion: CompletionBlock?) {
        let reachabilityStatus = ReachabilityWrapper.sharedReach!.currentReachabilityStatus
        if reachabilityStatus == Reachability.NetworkStatus.notReachable {
            let errorObj: JSONDictionary = ["status": false, "message": "Please check your internet connectivity!"]
            if let completion = requestCompletion {
                completion(errorObj, nil, nil)
                return
            }
        }
        
        let url = URL(string: urlString)!
        let config = URLSessionConfiguration.default
        completionHandler = requestCompletion
        
        let loginString = String(format: "%@:%@", Admin.username, Admin.password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
         let session = URLSession(configuration: config)
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethods.post.rawValue
        
        let authString = "Basic \(base64LoginString)"
        request.allHTTPHeaderFields = ["authorization" : authString]
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(Admin.language, forHTTPHeaderField: "Language")
        request.timeoutInterval = 60
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postParams)
            let str = String.init(data: jsonData, encoding: String.Encoding.utf8)
            
            debugPrint(url)
            
            debugPrint(str ?? "")
            
            let uploadTask = session.uploadTask(with: request, from: jsonData) { (responseData: Data?, responseObj: URLResponse?, error: Error?) in
                if let completion = self.completionHandler {
                    if let d = responseData {
                        
                        do {
                            let jsonObj = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.allowFragments)
                            
                            OperationQueue.main.addOperation {
                                print(jsonObj)
                                completion(jsonObj, responseObj, error)
                            }
                        } catch {
                            OperationQueue.main.addOperation {
                                completion(nil, nil, error)
                            }
                        }
                    } else {
                        OperationQueue.main.addOperation {
                            let errorObj: JSONDictionary = ["status": false, "message": error?.localizedDescription ?? "Something went worong, please try later"]
                            if let completion = requestCompletion {
                                completion(errorObj, responseObj, error)
                            }
                        }
                    }
                }
            }
            arrUploadTask.append(uploadTask)
            uploadTask.resume()
        } catch {
            fatalError("Request could not be serialized")
        }
    }
    
    /// POST request
    ///
    /// - Parameters:
    ///   - postParams: parameters to send
    ///   - urlString: Full URL of the service
    ///   - requestCompletion: Code block to execure when request finishes
    func postRequestAfterLogin(withParams postParams: JSONDictionary, url urlString: String, completion requestCompletion: CompletionBlock?) {
        let reachabilityStatus = ReachabilityWrapper.sharedReach!.currentReachabilityStatus
        if reachabilityStatus == Reachability.NetworkStatus.notReachable {
            let errorObj: JSONDictionary = ["status": false, "message": "Please check your internet connectivity!"]
            if let completion = requestCompletion {
                completion(errorObj, nil, nil)
                return
            }
        }
        
        let url = URL(string: urlString)!
        let config = URLSessionConfiguration.default
        completionHandler = requestCompletion
        
        let loginString = String(format: "%@:%@", Admin.username, Admin.password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        let session = URLSession(configuration: config)
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethods.post.rawValue
        
        let authString = "Basic \(base64LoginString)"
        request.allHTTPHeaderFields = ["authorization" : authString]
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(Admin.language, forHTTPHeaderField: "Language")
        
//        if VersManager.share.userLogin?.data.first?.userAccessToken != nil {
        request.addValue((VersManager.share.userLogin?.data.first?.userAccessToken)!, forHTTPHeaderField: "Auth-Token")
      //  }
        request.timeoutInterval = 60
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postParams)
            let str = String.init(data: jsonData, encoding: String.Encoding.utf8)
            
            debugPrint(url)
            
            debugPrint(str ?? "")
            
            let uploadTask = session.uploadTask(with: request, from: jsonData) { (responseData: Data?, responseObj: URLResponse?, error: Error?) in
                if let completion = self.completionHandler {
                    if let d = responseData {
                        print(d)
                        let returnData = String(data: d, encoding: .utf8)
                        print(returnData ?? "nil")
                        do {
                            let jsonObj = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.allowFragments)
                            
                            OperationQueue.main.addOperation {
                                print(jsonObj)
                                completion(jsonObj, responseObj, error)
                            }
                        } catch {
                            OperationQueue.main.addOperation {
                                completion(nil, nil, error)
                            }
                        }
                    } else {
                        OperationQueue.main.addOperation {
                            let errorObj: JSONDictionary = ["status": false, "message": error?.localizedDescription ?? "Something went worong, please try later"]
                            if let completion = requestCompletion {
                                completion(errorObj, responseObj, error)
                            }
                        }
                    }
                }
            }
            arrUploadTask.append(uploadTask)
            uploadTask.resume()
        } catch {
            fatalError("Request could not be serialized")
        }
    }
    
  
    func demoRegister () {

        let headers = [
            "content-type": "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
            "language": "en",
            "authorization": "Basic dmVyc0FkbWluOnZlcnNAMTIzNDU2",
            "cache-control": "no-cache",
        ]
        let parameters = [
            "name":"nishat",
            "user_name": "Nishant3 Tiwari13",
            "representing_location": "Indore",
            "email_address": "nitin.tiwari3@hiteshi.com",
            "password": "123456",
            "privateinfo_status": "public",
            "device_type": "1",
            "device_token": "883C885E947FD818DEF5BAFC87CA69461E23FF08CF13A82976495689B377A425",
            "gender": "male"
        ]
        var body = ""
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters)
           body = String.init(data: jsonData, encoding: String.Encoding.utf8)!
            
            let request = NSMutableURLRequest(url: URL(string: "http://versappadmin-com.stackstaging.com/api/v1/Authentication/register")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 100.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = jsonData
            
            let session = URLSession.init(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if let d = data {
                    print(d)
                    let returnData = String(data: d, encoding: .utf8)
                    print(returnData ?? "nil")
                    do {
                        let jsonObj = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.allowFragments)
                        
                        OperationQueue.main.addOperation {
                            print(jsonObj)
                        }
                    } catch {
                        
                    }
                }
                
                if (error != nil) {
                    print(error!)
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse)
                }
            })
            
            dataTask.resume()

        } catch {
            fatalError("Request could not be serialized")
        }
        
        
        
        
    }
   
  
    /// PUT request
    ///
    /// - Parameters:
    ///   - putParams: parameters to send
    ///   - urlString: Full URL of the service
    ///   - requestCompletion: Code block to execure when request finishes
    func putRequest(withParams postParams: JSONDictionary, url urlString: String, completion requestCompletion: CompletionBlock?) {
        let reachabilityStatus = ReachabilityWrapper.sharedReach!.currentReachabilityStatus
        if reachabilityStatus == Reachability.NetworkStatus.notReachable {
            let errorObj: JSONDictionary = ["status": false, "message": "Please check your internet connectivity!"]
            if let completion = requestCompletion {
                completion(errorObj, nil, nil)
                return
            }
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let url = URL(string: urlString)!
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        completionHandler = requestCompletion
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethods.put.rawValue
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 60
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postParams)
            
            let str = String.init(data: jsonData, encoding: String.Encoding.utf8)
            
            debugPrint(str ?? "")
            
            let uploadTask = session.uploadTask(with: request, from: jsonData) { (responseData: Data?, responseObj: URLResponse?, error: Error?) in
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                if let completion = self.completionHandler {
                    if let d = responseData {
                        
                        do {
                            let jsonObj = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.allowFragments)
                            
                            OperationQueue.main.addOperation {
                                print(jsonObj)
                                completion(jsonObj, responseObj, error)
                            }
                        } catch {
                            OperationQueue.main.addOperation {
                                completion(nil, nil, error)
                            }
                        }
                    } else {
                        OperationQueue.main.addOperation {
                            let errorObj: JSONDictionary = ["status": false, "message": error?.localizedDescription ?? "Something went worong, please try later"]
                            if let completion = requestCompletion {
                                completion(errorObj, responseObj, error)
                            }
                        }
                    }
                }
            }
            arrUploadTask.append(uploadTask)
            uploadTask.resume()
        } catch {
            fatalError("Request could not be serialized")
        }
    }
    
    /// Delete request
    ///
    /// - Parameters:
    ///   - deleteParams: parameters to send
    ///   - urlString: Full URL of the service
    ///   - requestCompletion: Code block to execure when request finishes
    func deleteRequest(withURL urlString: String, completion requestCompletion: CompletionBlock?) {
        guard let percentEnoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else { return }
        guard let url = URL.init(string: percentEnoded) else { return }
        
        debugPrint(url)
        
        let reachabilityStatus = ReachabilityWrapper.sharedReach!.currentReachabilityStatus
        if reachabilityStatus == Reachability.NetworkStatus.notReachable {
            let errorObj: JSONDictionary = ["status": false, "message": "Please check your internet connectivity!"]
            if let completion = requestCompletion {
                completion(errorObj, nil, nil)
                return
            }
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        completionHandler = requestCompletion
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethods.delete.rawValue
        
        let downloadTask = session.dataTask(with: request) { (responseData: Data?, responseObj: URLResponse?, error: Error?) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let completion = self.completionHandler {
                if let d = responseData {
                    
                    if let jsonObj = try? JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.allowFragments) {
                        OperationQueue.main.addOperation {
                            print(jsonObj)
                            completion(jsonObj, responseObj, error)
                        }
                    } else {
                        OperationQueue.main.addOperation {
                            let errorObj: JSONDictionary = ["status": false, "message": error?.localizedDescription ?? "Something went worong, please try later"]
                            if let completion = requestCompletion {
                                completion(errorObj, responseObj, error)
                            }
                        }
                    }
                } else {
                    OperationQueue.main.addOperation {
                        let errorObj: JSONDictionary = ["status": false, "message": error?.localizedDescription ?? "Something went worong, please try later"]
                        if let completion = requestCompletion {
                            completion(errorObj, responseObj, error)
                        }
                    }
                }
            }
        }
        arrDataTask.append(downloadTask as! URLSessionUploadTask)
        downloadTask.resume()
    }
    
    /// GET request
    ///
    /// - Parameters:
    ///   - urlString: Full URL of the service
    ///   - requestCompletion: Code block to execure when request finishes
    func getRequest(withURL urlString: String, completion requestCompletion: CompletionBlock?) {
        guard let percentEnoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else { return }
        guard let url = URL.init(string: percentEnoded) else { return }
        
        debugPrint(url)
        
        let reachabilityStatus = ReachabilityWrapper.sharedReach!.currentReachabilityStatus
        if reachabilityStatus == Reachability.NetworkStatus.notReachable {
            let errorObj: JSONDictionary = ["status": false, "message": "Please check your internet connectivity!"]
            if let completion = requestCompletion {
                completion(errorObj, nil, nil)
                return
            }
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        completionHandler = requestCompletion
        let loginString = String(format: "%@:%@", Admin.username, Admin.password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethods.get.rawValue
        let authString = "Basic \(base64LoginString)"
        request.allHTTPHeaderFields = ["authorization" : authString]
        
//        request.addValue(UCashManager.share.login.data.authToken, forHTTPHeaderField: "auth_token")
//        request.addValue(UCashManager.share.login.data.merchantId.toString, forHTTPHeaderField: "merchant_id")
        request.timeoutInterval = 60
        let downloadTask = session.dataTask(with: request) { (responseData: Data?, responseObj: URLResponse?, error: Error?) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let completion = self.completionHandler {
                if let d = responseData {
                    
                    if let jsonObj = try? JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.allowFragments) {
                        OperationQueue.main.addOperation {
                            print(jsonObj)
                            completion(jsonObj, responseObj, error)
                        }
                    } else {
                        OperationQueue.main.addOperation {
                            let errorObj: JSONDictionary = ["status": false, "message": error?.localizedDescription ?? "Something went worong, please try later"]
                            if let completion = requestCompletion {
                                completion(errorObj, responseObj, error)
                            }
                        }
                    }
                } else {
                    OperationQueue.main.addOperation {
                        let errorObj: JSONDictionary = ["status": false, "message": error?.localizedDescription ?? "Something went worong, please try later"]
                        if let completion = requestCompletion {
                            completion(errorObj, responseObj, error)
                        }
                    }
                }
            }
        }
        arrDataTask.append(downloadTask)
        downloadTask.resume()
    }
    
    @objc func resumeTask()  {
        let reachabilityStatus = ReachabilityWrapper.sharedReach!.currentReachabilityStatus
        if reachabilityStatus == Reachability.NetworkStatus.notReachable {
             //NotificationCenter.default.post(name: AppDelegate.share.notificationName, object: nil)
            for task in arrDataTask {
                task.suspend()
            }
            for task in arrUploadTask {
                task.suspend()
            }
        }else{
            for task in arrDataTask {
                task.resume()
            }
            for task in arrUploadTask {
                task.resume()
            }
        }
    }

    
}
/*
 #import <Foundation/Foundation.h>
 
 NSDictionary *headers = @{ @"content-type": @"application/json",
 @"authorization": @"Basic dUNhc2hBZG1pbjo2NTQzMjE=",
 @"cache-control": @"no-cache",
 @"postman-token": @"0a885e32-8b7a-6b2f-40f5-04d6942ad343" };
 NSDictionary *parameters = @{ @"device_token": @"d5b3a5af4c2170ca4a9903fe1464bf10ff7ec1c5ccc5249c935a1b10d50fdebe",
 @"email": @"amit.sankla@hiteshi.com",
 @"device_id": @"9ED06D1B-A61D-4E7C-A87E-48237D33B765",
 @"password": @"123456",
 @"device_type": @"iPhone" };
 
 NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
 
 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://ucash.hiteshi.com/api/v1/authentication/login"]
 cachePolicy:NSURLRequestUseProtocolCachePolicy
 timeoutInterval:10.0];
 [request setHTTPMethod:@"POST"];
 [request setAllHTTPHeaderFields:headers];
 [request setHTTPBody:postData];
 
 NSURLSession *session = [NSURLSession sharedSession];
 NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
 if (error) {
 NSLog(@"%@", error);
 } else {
 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
 NSLog(@"%@", httpResponse);
 }
 }];
 [dataTask resume];
 */
extension Data {
    mutating func appendString(string: String) {
        let data = string.data(
            using: String.Encoding.utf8,
            allowLossyConversion: true)
        append(data!)
    }
}
