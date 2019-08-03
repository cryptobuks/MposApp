//
//  SearchServices.swift
//  Mpos
//
//  Created by Yash on 03/08/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import Foundation
import Alamofire

extension MainReqeustClass
{
    func getSearchResult(parameter:[String:Any]?,header:[String : String]?,strMethodName:String,showProgress:Bool = true, successCall:@escaping (Dictionary<String, AnyObject>) -> Void, failedCall:@escaping (String) -> Void)
    {
        let url = "\(base_Url)\(strMethodName)"
        
        MainReqeustClass.BaseRequestSharedInstance.getRequestWithHeader(showLoader: showProgress, url:url, parameter: nil, header:header, success: { (response:Dictionary<String,AnyObject>) in
            MainReqeustClass.HideActivityIndicatorInStatusBar()
            successCall(response)
        }) { (responseError) in
            failedCall(responseError)
        }
    }
}
