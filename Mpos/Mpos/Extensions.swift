//
//  Extensions.swift
//  Mpos
//
//  Created by kaushal panchal on 25/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import Foundation
extension UITableViewCell {
    
    var viewControllerForTableView : UIViewController?{
        return ((self.superview as? UITableView)?.delegate as? UIViewController)
    }
    
}
