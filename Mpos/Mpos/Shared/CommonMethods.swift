//
//  CommonMethods.swift
//  Mpos
//
//  Created by kaushal panchal on 03/08/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import Foundation

class CommonMethods: NSObject {
    public func displayAlertView(_ aStrTitle: String?, aStrMessage: String?,aStrCancelTitle: String? = "OK", aStrOtherTitle: String?)
    {
        let alert = UIAlertController(title: aStrTitle , message: aStrMessage , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: aStrCancelTitle, style: .default, handler: { action in
        }))
        appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    public func createHeaderDic(strMethod:String) -> [String:String]
    {
        
        let  dicRequestHeaders = ["Content-Type":"application/json",
                                  "bsPassword" : "eUNfNkE5az8=",
                                  "bsSolution" : "ViaConsulting",
                                  "bsUSer" : #"\BS\ViaConsultingD"#,
                                  "bsWebMethod":"\(strMethod)",
                                  "bsWebService":"ageas-api-MPOS",
                            "Authorization":UserDefaultManager.SharedInstance.getToken()!]
        return dicRequestHeaders
    }
}

extension String{
    func toCurrencyFormat() -> String {
        if let doubleValue = Double(self){
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: "fr_FR")
            return formatter.string(from: NSNumber(value: doubleValue)) ?? ""
        }
        return ""
    }
}
