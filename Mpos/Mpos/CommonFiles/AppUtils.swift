//
//  AppDelegate.swift
//  Mpos
//
//  Created by Kevin on 17/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit
import Foundation
import CoreGraphics

/* Created by Yash on 28-Sep-2018
 * * Purpose : This class is utility class designed to extend functionality of exisitng classes.
 */

//MARK: UIView designable Methods
@IBDesignable extension UIView
{
    /* Created by Yash on 28-Sep-2018
     * * Purpose : This method is to add custom stoaryboard property borderColor.
     */
    @IBInspectable var borderColor:UIColor?
        {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    
    /* Created by Yash on 28-Sep-2018
     * * Purpose : This method is to add custom stoaryboard property borderWidth.
     */
    @IBInspectable var borderWidth:CGFloat
        {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    /* Created by Yash on 28-Sep-2018
     * * Purpose : This method is to add custom stoaryboard property cornerRadius.
     */
    @IBInspectable var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}

extension UIView {
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }
        
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        return nil
    }
}

private var kAssociationKeyMaxLength: Int = 0

//MARK: TextField Methods
extension UITextField {
    
    /* Created by Yash on 28-Sep-2018
     * * Purpose : This method is to add custom stoaryboard property max length to textfield.
     */
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    /* Created by Yash on 28-Sep-2018
     * * Purpose : This method is to validate max length of textfield.
     */
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        
        let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        let substring = prospectiveText[..<indexEndOfText]
        text = String(substring)
        
        selectedTextRange = selection
    }
}

//MARK: Custom TextFiled class
class PaddingTextField: UITextField {
    
    @IBInspectable var paddingLeft: CGFloat = 0
    @IBInspectable var paddingRight: CGFloat = 0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect
    {
        return CGRect(x: bounds.origin.x + paddingLeft, y: bounds.origin.y,
                      width: bounds.size.width - paddingLeft - paddingRight, height: bounds.size.height);
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}

//MARK: NSAttributed String Methods
extension NSAttributedString {
    func rangeOf(string: String) -> Range<String.Index>? {
        return self.string.range(of: string)
    }
}


//MARK: String Methods
extension String
{
    func EncodingText() -> NSData
    {
        return self.data(using: String.Encoding.utf8, allowLossyConversion: false)! as NSData
    }
    
    func addImageURLPercentageEncode() -> String {
        let str = self.replacingOccurrences(of: " ", with: "%20")
        return str
    }
    func utf8DecodedString()-> String {
        let data = self.data(using: .utf8)
        if let message = String(data: data!, encoding: .nonLossyASCII){
            return message
        }
        return ""
    }
    
    func utf8EncodedString()-> String? {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8)
        return text
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

//MARK: Date Methods
extension Date
{
    func toString() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
    
    func toStringDateFM(strFormateofDate: String,strTimeZone: String?) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strFormateofDate
        if let strTimeZoneSet = strTimeZone
        {
            dateFormatter.timeZone = NSTimeZone(abbreviation: strTimeZoneSet)! as TimeZone
        }
        return dateFormatter.string(from: self)
    }
    
    func toTimeString() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:MM"
        return dateFormatter.string(from: self)
    }
}

//MARK: UIColor Methods
extension UIColor
{
   
    public class func APPTHEMEGREEN () -> UIColor {
        return UIColor(red: 100/255.0, green: 204.0/255.0, blue: 117/255.0, alpha: 1.0)
    }
    public class func APPTHEMELightGREEN () -> UIColor {
        return UIColor(red: 138/255.0, green: 222/255.0, blue: 152/255.0, alpha: 1.0)
    }
    public class func APPTHEMELighterGREEN () -> UIColor {
        return UIColor(red: 192/255.0, green: 243/255.0, blue: 200/255.0, alpha: 1.0)
    }
    public class func APPTHEMELIGHTGRAY() -> UIColor {
        return UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 0.8)
    }
}

extension UIFont {
    public class func RalewayMedium_title17 () -> UIFont {
        return UIFont(name: "Poppins-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .regular)
    }
    public class func RalewaySemibold_title17 () -> UIFont {
        return UIFont(name: "Poppins-SemiBold", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .regular)
    }
    public class func RalewayBold_title17 () -> UIFont {
        return UIFont(name: "Poppins-Bold", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .regular)
    }
    public class func RalewayRegular_14 () -> UIFont {
        return UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
    }
}

extension UIViewController {
    
    struct Header {
        var name: String!
        var items: [Int]!
        var collapsed: Bool!
        
        init(name: String, items: [Int], collapsed: Bool = false) {
            self.name = name
            self.items = items
            self.collapsed = collapsed
        }
    }
    
    func isModal() -> Bool {
        if self.presentingViewController != nil {
            return true
        } else if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        } else if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }
}

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
extension Int {
    
    init(_ range: Range<Int> ) {
        let delta = range.lowerBound < 0 ? abs(range.lowerBound) : 0
        let min = UInt32(range.lowerBound + delta)
        let max = UInt32(range.upperBound   + delta)
        self.init(Int(min + arc4random_uniform(max - min)) - delta)
    }
}



