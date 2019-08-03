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
}

