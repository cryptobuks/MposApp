//
//  WebServiceManager.swift
//
//

import UIKit
import Alamofire
import MBProgressHUD
import SwiftyJSON
import SystemConfiguration

class MainReqeustClass: NSObject
{
    static let BaseRequestSharedInstance = MainReqeustClass()
    
    //HTTP Headers
    
    //header
    func header_Auth() -> [String:String]  {
        let token = UserDefaultManager.SharedInstance.getToken()
        let header = ["Accept":"application/json",
                      "Content-Type" : "application/x-www-form-urlencoded",
                      "Authorization" : token ?? "",
                      "Platform" : "ios"]
        return header
    }
    
     func header() -> [String:String]   {
        let header = ["Accept":"application/json",
                      "Content-Type" : "application/x-www-form-urlencoded",
                      "Platform" : "ios"]
        return header
    }
    
    
    //MARK: - WS CALLS Methods
    /** Created by Yash on 05-Sep-2018
     * * purpose : This method is used for making WebAPI calls using post method. In this method AlamofireManager class is used to handle the WebAPI calls. If the internet connectivity is available then only the WebAPI is called.
     
     - parameter parameter: A dictionary of parameters that needs to be sent to WebAPI. This parameter is optional, if the webservice uses GET method and accepts no parameter then user can skip this parameter, by default its value is nil.
     - parameter url:     The url of webservice.
     - parameter showLoader:     Do you need to show Loader[Prgoress View] or Hide it.
     - Date: 05-Sep-2018
     */
    func PostRequset(showLoader: Bool, url:String, parameter:[String : AnyObject]?, success:@escaping (Dictionary<String, AnyObject>) -> Void, failed:@escaping (String) -> Void)
    {
        if(isInternetConnection())
        {
            MainReqeustClass.ShowActivityIndicatorInStatusBar(shouldShowHUD: showLoader)
            print("----------------------\n\n\n\nURL: \(base_Url+url)")
            
            Alamofire.request(base_Url+url, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: header()).responseJSON { (response:DataResponse<Any>) in
                
                MainReqeustClass.HideActivityIndicatorInStatusBar()
                
                switch(response.result)
                {
                    case .success(_):
                        if response.result.value != nil
                        {
                        //debugPrint(response.result.value!)
                        
                        if let json = response.result.value
                        {
                            let dictemp = json as! NSDictionary
                            //print("dictemp :> \(dictemp)")
                           
                            
                            if let errorobject = dictemp["error"] as? [String:Any]
                            {
                                if let errorcode = errorobject["errorCode"] as? Int
                                {
                                    if errorcode != 200
                                    {
                                        failed("")
                                    }
                                }
                                
                                if let errorType = errorobject["errorType"] as? String
                                {
                                    if errorType != "OK"
                                    {
                                        failed("")
                                    }
                                }
                            }
                            
                            if dictemp.count > 0
                            {
                                success(dictemp as! Dictionary<String, AnyObject>)
                            }
                            else
                            {
                                failed(dictemp[kkeyError]! as! String)
                            }
                        }
                    }
                    else
                    {
                        failed("\(response.result.error?.localizedDescription ?? "")")
                    }
                    break
                case .failure(_):
                    failed("\(response.result.error?.localizedDescription ?? "")")
                    break
                }
            }
        }
        else
        {
            CommonMethods().displayAlertView(Application_Name, aStrMessage: Alert_NoInternet, aStrOtherTitle: nil)
            failed(Alert_NoInternet)
        }
    }
    
    /** Created by Yash on 05-Sep-2018
     * * purpose : This method is used for making WebAPI calls using Post method. In this method AlamofireManager class is used to handle the WebAPI calls. If the internet connectivity is available then only the WebAPI is called.
     
     - parameter parameter: A dictionary of parameters that needs to be sent to WebAPI. This parameter is optional, if the webservice uses GET method and accepts no parameter then user can skip this parameter, by default its value is nil.
     - parameter url: The url of webservice.
     - parameter showLoader: Do you need to show Loader[Prgoress View] or Hide it.
     - parameter header: if needed pass it else not required.
     */
    func postRequestWithHeader(showloaderText:String = "Loading...", showLoader: Bool, url:String, parameter:[String : AnyObject],header:[String : String], success:@escaping (Dictionary<String, AnyObject>) -> Void, failed:@escaping (String) -> Void)
    {
        if(isInternetConnection())
        {
            MainReqeustClass.ShowActivityIndicatorInStatusBar(shouldShowHUD: showLoader,loadingText:showloaderText)
            Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON { (response:DataResponse<Any>) in
                if showLoader {
                   MainReqeustClass.HideActivityIndicatorInStatusBar()
                }
                
                switch(response.result)
                {
                case .success(_):
                    if response.result.value != nil
                    {
                        print(response.result.value!)
                        
                        if let json = response.result.value
                        {
                            let dictemp = json as! NSDictionary
                            print("dictemp :> \(dictemp)")
                            if let errorobject = dictemp["errors"] as? [[String:Any]]
                            {
                                if let errordata = errorobject.first?["errorCode"] as? [String:Any]
                                {
                                    if let error = errordata["errorCode"] as? String, error != "200"
                                    {
                                        failed("\(errordata["errorMessage"] ?? "")")
                                        break
                                    }
                                    if let errorType = errordata["errorCode"] as? String, errorType != "OK"
                                    {
                                        failed("\(errordata["errorMessage"] ?? "")")
                                        break
                                    }
                                }
                                
                            }
                            
                            if dictemp.count > 0
                            {
                                success(dictemp as! Dictionary<String, AnyObject>)
                                break
                            }
                            else
                            {
                                failed(dictemp[kkeyError]! as! String)
                            }
                        }
                    }
                    else
                    {
                        failed("\(response.result.error?.localizedDescription ?? "")")
                        break
                    }
                    break
                case .failure(_):
                    failed("\(response.result.error?.localizedDescription ?? "")")
                    break
                }
            }
        } else {
            CommonMethods().displayAlertView(Application_Name, aStrMessage: Alert_NoInternet, aStrOtherTitle: nil)
            failed(Alert_NoInternet)
        }
    }
    
    //MARK:- Get Request
    /** Created by Yash on 05-Sep-2018
     * * purpose : This method is used for making WebAPI calls using GET method. In this method AlamofireManager class is used to handle the WebAPI calls. If the internet connectivity is available then only the WebAPI is called.
     
     - parameter parameter: A dictionary of parameters that needs to be sent to WebAPI. This parameter is optional, if the webservice uses GET method and accepts no parameter then user can skip this parameter, by default its value is nil.
     - parameter url:     The url of webservice.
     - parameter showLoader:     Do you need to show Loader[Prgoress View] or Hide it.
     - parameter header: if needed pass it else not required.
     */
    func getRequestWithHeader(showLoaderText:String = "Loading...",showLoader: Bool, url:String, parameter:[String : AnyObject]?,header:[String : String]?, success:@escaping (Dictionary<String, AnyObject>) -> Void, failed:@escaping (String) -> Void) {
        if(isInternetConnection())
        {
            if showLoader {
                 MainReqeustClass.ShowActivityIndicatorInStatusBar(shouldShowHUD: showLoader,loadingText: showLoaderText)
            }
            print("----------------------\n\n\n\nURL: \(url)")
            
            Alamofire.request(url, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: header).responseJSON { (response:DataResponse<Any>) in
                MainReqeustClass.HideActivityIndicatorInStatusBar()
                switch(response.result)
                {
                case .success(_):
                    if response.result.value != nil
                    {
                        //print(response.result.value!)
                        
                        if let json = response.result.value
                        {
                            let dictemp = json as! NSDictionary
//                            debugPrint("dictemp :> \(dictemp)")
                            
                            if let errorcode = dictemp["errorCode"] as? Int {
                                if errorcode == 401 || errorcode == 403{
                                    failed("")
                                }
                            }
                            if dictemp.count > 0
                            {
                                success(dictemp as! Dictionary<String, AnyObject>)
                            }
                            else
                            {
                                failed(dictemp[kkeyError]! as! String)
                            }
                        }
                    }
                    else
                    {
                        failed("\(response.result.error?.localizedDescription ?? "")")
                    }
                    break
                case .failure(_):
                    failed("\(response.result.error?.localizedDescription ?? "")")
                    break
                }
            }
        }else{
            CommonMethods().displayAlertView(Application_Name, aStrMessage: Alert_NoInternet, aStrOtherTitle: nil)
            failed(Alert_NoInternet)
        }
    }
    
    /** Created by Yash on 05-Sep-2018
     * * purpose : This method is used for making WebAPI calls using GET method. In this method AlamofireManager class is used to handle the WebAPI calls. If the internet connectivity is available then only the WebAPI is called.
     
     - parameter parameter: A dictionary of parameters that needs to be sent to WebAPI. This parameter is optional, if the webservice uses GET method and accepts no parameter then user can skip this parameter, by default its value is nil.
     - parameter url: The url of webservice.
     - parameter showLoader: Do you need to show Loader[Prgoress View] or Hide it.
     */
    func GetRequset(showLoader: Bool, url:String, parameter:[String : AnyObject]?, success:@escaping (Dictionary<String, AnyObject>) -> Void, failed:@escaping (String) -> Void)
    {
        
        if(isInternetConnection())
        {
            MainReqeustClass.ShowActivityIndicatorInStatusBar(shouldShowHUD: showLoader)
            
            //print("----------------------\n\n\n\nURL: \(base_Url+url)")
            //print("I/P PARAMS: \(parameter ?? ["Novalue" :"" as AnyObject])")
            
            Alamofire.request(base_Url+url, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: header()).responseJSON { (response:DataResponse<Any>) in
                
                
                MainReqeustClass.HideActivityIndicatorInStatusBar()
                switch(response.result)
                {
                case .success(_):
                    if response.result.value != nil
                    {
                        //print(response.result.value!)
                        
                        if let json = response.result.value
                        {
                            let dictemp = json as! NSDictionary
                            if let errorcode = dictemp["errorCode"] as? Int {
                                if errorcode == 401 || errorcode == 403{
                                    failed("")
                                }
                            }
                            if dictemp.count > 0
                            {
                                success(dictemp as! Dictionary<String, AnyObject>)
                            }
                            else
                            {
                                failed(dictemp[kkeyError]! as! String)
                            }
                        }
                    }
                    else
                    {
                        failed("\(response.result.error?.localizedDescription ?? "")")
                    }
                    break
                case .failure(_):
                    failed("\(response.result.error?.localizedDescription ?? "")")
                    break
                }
            }
        }else{
            CommonMethods().displayAlertView(Application_Name, aStrMessage: Alert_NoInternet, aStrOtherTitle: nil)
            failed(Alert_NoInternet)
        }
    }
    
    //This is used for external URLs call without authentication.
    func getRequestWithResponseAsArray(showLoaderText:String = "Loading...",showLoader: Bool, url:String, parameter:[String : AnyObject]?, successCall:@escaping ([[String:AnyObject]]) -> Void, failedCall:@escaping (String) -> Void) {
        
        if(isInternetConnection()) {
            if showLoader {
                MainReqeustClass.ShowActivityIndicatorInStatusBar(shouldShowHUD: showLoader,loadingText: showLoaderText)
            }
            //print("----------------------\n\n\n\nURL: \(url)")
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers:self.header()).responseJSON { (response:DataResponse<Any>) in
                MainReqeustClass.HideActivityIndicatorInStatusBar()
                switch(response.result)
                {
                case .success(_):
                    if response.result.value != nil
                    {
                        //print(response.result.value!)
                        
                        if let json = response.result.value
                        {
                            if let arrJson = json as? [[String:AnyObject]] {
                                //print("dictemp :> \(arrJson)")
                                successCall(arrJson)
                            } else {
                                failedCall("Server internal error")
                            }
                        } else {
                            failedCall("Server internal error")
                        }
                    }
                    else
                    {
                        failedCall("\(response.result.error?.localizedDescription ?? "")")
                    }
                    break
                case .failure(_):
                    MainReqeustClass.HideActivityIndicatorInStatusBar()
                    failedCall("\(response.result.error?.localizedDescription ?? "")")
                    break
                }
            }
        }else{
            MainReqeustClass.HideActivityIndicatorInStatusBar()
            CommonMethods().displayAlertView(Application_Name, aStrMessage: Alert_NoInternet, aStrOtherTitle: nil)
            failedCall(Alert_NoInternet)
        }
    }
    
    //MARK:- Delete Request
    /**
     * * purpose : This method is used for making WebAPI calls using GET method. In this method AlamofireManager class is used to handle the WebAPI calls. If the internet connectivity is available then only the WebAPI is called.
     
     - parameter parameter: A dictionary of parameters that needs to be sent to WebAPI. This parameter is optional, if the webservice uses GET method and accepts no parameter then user can skip this parameter, by default its value is nil.
     - parameter url:     The url of webservice.
     - parameter showLoader:     Do you need to show Loader[Prgoress View] or Hide it.
     - parameter header: if needed pass it else not required.
     */
    func deleteRequestWithHeader(showLoader: Bool, url:String, parameter:[String : AnyObject]?,header:[String : String]?, success:@escaping (Dictionary<String, AnyObject>) -> Void, failed:@escaping (String) -> Void) {
        if(isInternetConnection())
        {
            MainReqeustClass.ShowActivityIndicatorInStatusBar(shouldShowHUD: showLoader)
            //print("----------------------\n\n\n\nURL: \(url)")
            
            Alamofire.request(url, method: .delete, parameters: parameter, encoding: URLEncoding.default, headers: header).responseJSON { (response:DataResponse<Any>) in
                MainReqeustClass.HideActivityIndicatorInStatusBar()
                switch(response.result)
                {
                case .success(_):
                    if response.result.value != nil
                    {
                        //print(response.result.value!)
                        
                        if let json = response.result.value
                        {
                            let dictemp = json as! NSDictionary
                            //print("dictemp :> \(dictemp)")
                            if let errorcode = dictemp["errorCode"] as? Int {
                                if errorcode == 401 || errorcode == 403{
                                    failed("")
                                }
                            }
                            
                            if dictemp.count > 0
                            {
                                success(dictemp as! Dictionary<String, AnyObject>)
                            }
                            else
                            {
                                failed(dictemp[kkeyError]! as! String)
                            }
                        }
                    }
                    else
                    {
                        failed("\(response.result.error?.localizedDescription ?? "")")
                    }
                    break
                case .failure(_):
                    failed("\(response.result.error?.localizedDescription ?? "")")
                    break
                }
            }
        }else{
            CommonMethods().displayAlertView(Application_Name, aStrMessage: Alert_NoInternet, aStrOtherTitle: nil)
            failed(Alert_NoInternet)
        }
    }
    
    //MARK:- Multipart Request
    func POSTMultipartRequest(showLoader: Bool, url:String, parameter:[String : AnyObject]?, img : UIImage?, header:[String : String]?,success:@escaping (Dictionary<String, AnyObject>) -> Void, failed:@escaping (String?) -> Void)
    {
        
        if(isInternetConnection())
        {
            MainReqeustClass.ShowActivityIndicatorInStatusBar(shouldShowHUD: showLoader)
            
           // print("----------------------\n\n\n\nURL: \(base_Url+url)")
            //print("I/P PARAMS: \(parameter ?? ["Novalue" :"" as AnyObject])")
            
            Alamofire.upload(multipartFormData:{ multipartFormData in
                
                if img != nil
                {
                    multipartFormData.append(img!.jpegData(compressionQuality: 1)!, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
                }
                if parameter != nil {
                    for (key, value) in parameter!
                    {
                        multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }
                }
            },
                             usingThreshold:UInt64.init(),
                             to:url,
                             method:.post,
                             headers:header,
                             encodingCompletion: { encodingResult in
                                switch encodingResult {
                                    
                                case .success(let upload, _, _):
                                    upload.responseJSON { response in
//                                        debugPrint(response)
                                        
                                        upload.responseJSON { response in
                                            MainReqeustClass.HideActivityIndicatorInStatusBar()
                                            print("Response: \(response.result.value as AnyObject?)")
                                            
                                            var dict = JSON(response.result.value ?? "").dictionaryValue
                                            
                                            if let errorcode = dict["errorCode"] as? Int {
                                                if errorcode == 401 || errorcode == 403 {
                                                    failed("")
                                                }
                                            }
                                            
                                            if(dict["code"]?.intValue == 500) {
                                                failed((dict["message"]?.stringValue)!)
                                            }
                                            else {
                                                success(dict as Dictionary<String, AnyObject>)
                                            }
                                        }
                                        
                                    }
                                case .failure(let encodingError):
                                    //print(encodingError)
                                    MainReqeustClass.HideActivityIndicatorInStatusBar()
                                    failed("The network connection was lost please try again.")
                                }
            })
            
        } else {
            CommonMethods().displayAlertView(Application_Name, aStrMessage: Alert_NoInternet, aStrOtherTitle: nil)
           failed(Alert_NoInternet)
        } 
    }
    
    func POSTMultipartRequestwithMultipleImage(showLoader: Bool, url:String, parameter:[String : AnyObject]?, header:[String : String]?,success:@escaping (Dictionary<String, AnyObject>) -> Void, failed:@escaping (String?) -> Void)
    {
      
        MainReqeustClass.ShowActivityIndicatorInStatusBar(shouldShowHUD: showLoader,loadingText:"Uploading survey form...")
        var tempparameters = parameter!
        var arrImageData = [AnyObject]()
        arrImageData = parameter!["imageData"] as! [AnyObject]
        tempparameters.removeValue(forKey: "imageData")
        
        if(isInternetConnection())
        {
            Alamofire.upload(multipartFormData:{ multipartFormData in
                
                for imageData in arrImageData
                {
                    if let data = imageData as? Data {
                         multipartFormData.append(data, withName: "value[]", fileName: "image.jpeg", mimeType: "image/jpeg")
                    }
                }
                
                for (key, value) in tempparameters
                {
                    if let temp = value as? [AnyObject]
                    {
                        let data = try? JSONSerialization.data(withJSONObject: value, options: [])
                        multipartFormData.append(data!, withName: key)
                    }
                    else
                    {
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }
                    //                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }

            },
                             usingThreshold:UInt64.init(),
                             to:base_Url+url,
                             method:.post,
                             headers:header,
                             encodingCompletion: { encodingResult in
                                switch encodingResult {
                                    
                                case .success(let upload, _, _):
                                    upload.responseJSON { response in
//                                        debugPrint(response)
                                        
                                        upload.responseJSON { response in
                                            MainReqeustClass.HideActivityIndicatorInStatusBar()
                                            //print("Response: \(response.result.value as AnyObject?)")
                                            
                                            
                                            
                                            if response.result.value != nil
                                            {
                                                //print(response.result.value!)
                                                
                                                if let json = response.result.value
                                                {
                                                    let dictemp = json as! NSDictionary
                                                    if let errorcode = dictemp["errorCode"] as? Int {
                                                        if errorcode == 401 || errorcode == 403{
                                                            failed("")
                                                        }
                                                    }
                                                    if dictemp.count > 0
                                                    {
                                                        success(dictemp as! Dictionary<String, AnyObject>)
                                                    }
                                                    else
                                                    {
                                                        failed(((dictemp["message"] as AnyObject).stringValue)!)
                                                    }
                                                }
                                            } else {
                                                failed("Error in uploading survey form.")
                                            }
                                            
                                            /*var dict = JSON(response.result.value ?? "").dictionaryValue
                                            
                                            
                                            if(dict["code"]?.intValue == 500)
                                            {
                                                failed((dict["message"]?.stringValue)!)
                                            }
                                            else
                                            {
                                                success((dict as NSDictionary) as! Dictionary<String, AnyObject>)
                                            }*/
                                        }
                                        
                                    }
                                case .failure(let encodingError):
                                    //print(encodingError)
                                    MainReqeustClass.HideActivityIndicatorInStatusBar()
                                    failed("The network connection was lost please try again.")
                                }
            })
            
        }
        else
        {
            CommonMethods().displayAlertView(Application_Name, aStrMessage: Alert_NoInternet, aStrOtherTitle: nil)
            failed(Alert_NoInternet)
        }
    }
    
    func postUpdateSurveyForm(dict:[String:AnyObject],successCall:@escaping (Dictionary<String, AnyObject>) -> Void, failedCall:@escaping (String) -> Void) {
        let url = "\(base_Url)/survey/mobile-update-survey-form"
        self.postRequestWithHeader(showloaderText :"Uploading survey form...",showLoader: true, url: url, parameter:dict as [String : AnyObject], header: header_Auth(), success: { (response) in
            successCall(response)
        }) { (errorResponse) in
            failedCall(errorResponse)
        }
    }
    
    
    /** Created by Yash on 05-Sep-2018
     * * purpose : This method is used for making WebAPI calls using Post method. In this method AlamofireManager class is used to handle the WebAPI calls. If the internet connectivity is available then only the WebAPI is called.
     
     - parameter parameter: A dictionary of parameters that needs to be sent to WebAPI. This parameter is optional, if the webservice uses GET method and accepts no parameter then user can skip this parameter, by default its value is nil.
     - parameter url: The url of webservice.
     - parameter showLoader: Do you need to show Loader[Prgoress View] or Hide it.
     - parameter header: if needed pass it else not required.
     */
    func putRequestWithHeader(showLoader: Bool, url:String, parameter:[String : AnyObject]?,header:[String : String]?, success:@escaping (Dictionary<String, AnyObject>) -> Void, failed:@escaping (String) -> Void)
    {
        if(isInternetConnection())
        {
            MainReqeustClass.ShowActivityIndicatorInStatusBar(shouldShowHUD: showLoader)
            Alamofire.request(url, method: .put, parameters: parameter, encoding: URLEncoding.default, headers: header).responseJSON { (response:DataResponse<Any>) in
                MainReqeustClass.HideActivityIndicatorInStatusBar()
                switch(response.result)
                {
                case .success(_):
                    if response.result.value != nil
                    {
                        //print(response.result.value!)
                        
                        if let json = response.result.value
                        {
                            let dictemp = json as! NSDictionary
                            //print("dictemp :> \(dictemp)")
                            
                            if let errorcode = dictemp["errorCode"] as? Int {
                                if errorcode == 401 || errorcode == 403{
                                    failed("")
                                }
                            }
                            if dictemp.count > 0
                            {
                                success(dictemp as! Dictionary<String, AnyObject>)
                            }
                            else
                            {
                                failed(dictemp[kkeyError]! as! String)
                            }
                        }
                    }
                    else
                    {
                        failed("\(response.result.error?.localizedDescription ?? "")")
                    }
                    break
                case .failure(_):
                    failed("\(response.result.error?.localizedDescription ?? "")")
                    break
                }
            }
        } else {
            CommonMethods().displayAlertView(Application_Name, aStrMessage: Alert_NoInternet, aStrOtherTitle: nil)
            failed(Alert_NoInternet)
        }
    }
    
}

//MARK: - Progress HUD Methods
extension MainReqeustClass {
    
    /** Created by Yash on 05-Sep-2018
     * * purpose : This method is used show loading and status bar loading.
     **/
    class func ShowActivityIndicatorInStatusBar( shouldShowHUD : Bool,loadingText:String = "Loading...")
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if (shouldShowHUD == true)
        {
            let window = UIApplication.shared.keyWindow!
            let progressHUD = MBProgressHUD.showAdded(to: window, animated: true)
            progressHUD.label.text = loadingText
        }
    }
    
    /** Created by Yash on 05-Sep-2018
     * * purpose : This method is used show loading and status bar loading with custom text.
     **/
    class func ShowActivityIndicatorInStatusBarwithLoadingText( shouldShowHUD : Bool , strLoadingText : String)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        MainReqeustClass.HideActivityIndicatorInStatusBar()
        if (shouldShowHUD == true)
        {
            let window = UIApplication.shared.keyWindow!
            let progressHUD = MBProgressHUD.showAdded(to: window, animated: true)
            progressHUD.label.text = strLoadingText
        }
    }
    
    /** Created by Yash on 05-Sep-2018
     * * purpose : This method is used hide loading.
     **/
    class func HideActivityIndicatorInStatusBar()
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        MBProgressHUD.hide(for: UIApplication.shared.keyWindow!, animated: true)
    }
}
 //MARK: - Internet connectivity check
extension MainReqeustClass {
    
    /** Created by Yash on 05-Sep-2018
     * * purpose : This method is used hcheck internet connetion is active or not.
     https://drisksurvey.atlassian.net/browse/SUR-66
     **/
    func isInternetConnection() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress)
        {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags)
        {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
