//
//  AppDelegate.swift
//  Mpos
//
//  Created by Kevin on 17/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//
import Foundation
import UIKit

/* Created by Yash on 28-Sep-2018
 * * Purpose : This class is helper class designed define app level constants.
 */

let MainScreen = UIScreen.main.bounds.size

let appDelegate     = UIApplication.shared.delegate as! AppDelegate
let userDefaults    = UserDefaults.standard
let Application_Name  =  "Mpos"
let Alert_NoInternet    = "You are offline.\nPlease check your internet connection."
let Alert_NoDataFound    = "No Data Found."

let kNO = "NO"
let kYES = "YES"

let kkeyError = "error"

var progressView : UIView?

let kkey_api_url = "api_url"

let kUIDateFormate =  "dd MMM YYYY"
let kUIDateTimeFormate =  "dd MMM YYYY hh:mm a"
let kImageDateTimeFormate =  "YYYYMMDDHHMMSS"
let iMinTempSyncId = 1000000000;
let kNoUpdatesAvailable = "No Updates Avilable"
let kQuestionPaperFormate = "yyyy-MM-dd'T'HH:mm:ss"
let passWord_MAX = 20
let JAVA_SCRIPT_SEPARATOR_CONSTANT = "||"//"~"
let kAlertEnterEmailId = "Please enter your email address"
let kAlertEnterPassword = "Please enter your password"
let kAlertEnterEmailPasswd = "Please enter your email address and password"
let kAlertInvalidEmailId = "Please enter a valid email address."
let kREG_EX_FOR_EMAIL = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
let kIsRememberPassword = "IsRememberPassword"

// Listing constant
let kCellOfClientListing = "ClientDetailCell"
let kDataConfirmationHeaderCell = "DataConfirmationHeaderCell"
let kDataConfirmataionListwithLogoCell = "DataConfirmataionListwithLogoCell"
let kDataConfirmationNormalListCell = "DataConfirmationNormalListCell"
let kCellOfInvoiceDetails = "InvoiceDetailsTableViewCell"
let kCellOfCompanyDetails = "CompanyDetailsCellTableViewCell"
let kCellOfInvoiceDetailsWIthCheckBoxTableViewCell = "InvoiceDetailsWIthCheckBoxTableViewCell"
let kCellOfReceiptHeaderCell = "ReceiptHeaderCell"
let kCellOfGeneralDataCell = "GeneralDataCell"
let kCellOfAwardsDetailsCell = "AwardsDetailsCell"

let kCellOfCommitteesDetailsCell = "CommitteesDetailsCell"

let kCellOfPaymentDataCell = "PaymentDataCell"
let kCellOfInvoiceDetailsHeaderCell = "InvoiceDetailsHeaderCell"





let isIpad = Device.IS_IPAD

struct Device {
    // iDevice detection code
    static let IS_IPAD             = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE           = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA           = UIScreen.main.scale >= 2.0
    
    static let SCREEN_WIDTH        = Int(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT       = Int(UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH   = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
    static let SCREEN_MIN_LENGTH   = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
    
    static let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH  < 568
    static let IS_IPHONE_5         = IS_IPHONE && SCREEN_MAX_LENGTH == 568
    static let IS_IPHONE_6         = IS_IPHONE && SCREEN_MAX_LENGTH == 667
    static let IS_IPHONE_6P        = IS_IPHONE && SCREEN_MAX_LENGTH == 736
    static let IS_IPHONE_X         = IS_IPHONE && SCREEN_MAX_LENGTH == 812
    static let IS_IPHONE_XR         = IS_IPHONE && SCREEN_MAX_LENGTH == 812
    static let IS_IPHONE_XS         = IS_IPHONE && SCREEN_MAX_LENGTH == 812
    static let IS_IPHONE_XMAX         = IS_IPHONE && SCREEN_MAX_LENGTH == 812
}

struct DateFormats {
    static let serverDate = "yyyy-MM-dd"
    static let displayDate = "dd-MM-yyyy"
    static let serverDateTime = "yyyy-MM-dd'T'HH:mm:ss"
    static let kSyncDateFormatter = "yyyy-MM-dd HH mm ss"
}

enum UserDefaultKey: String {
    case LOGIN_USER = "LOGIN_USER"
    case TOKEN = "TOKEN"
    case IS_USERLOGGEDIN = "IS_USERLOGIN"
    case IS_ONBOARDINGDONE = "IS_ONBOARDINGDONE"
    case IS_INLINEMSG = "IS_INLINEMSG"
}

enum kValidationMsg : String {
    case first_name_empty = "Please enter first name."
    case first_name_MAXLenght = "First name can take max 50 character."
    case numeric_not_allow = "#NAME# can not take numeric values."
    case last_name_empty = "Please enter Last name."
    case last_name_MAXLenght = "Last name can take max 50 character."
    case email_empty = "Please enter email address"
    case oldPass_empty = "Please enter old password"
    case newPass_empty = "Please enter new password"
    case confPass_empty = "Please enter confirm password"
    case invalid_PasswordLength = "The #password# must be at least 8 characters."
    case invalid_password_pattern = "The #password# must be atlest one lower case, one upper case, one special character and one numeric digit"
    case gassafe_empty = "Please enter gas safe registration number."
    case gassafe_invalid = "Please enter valid gas safe registration number.This number must be between 3 to 7 digits."
    case oilsafe_empty = "Please enter OFTEC registration number."
    case oilsafe_inValid = "Please enter valid OFTEC registration number.This number must be between 3 to 7 digits."
    case invalid_credetial = "User credentials did not match !"
    case invalid_Email = "Please enter valid email address."
    case invalid_phone = "Please enter valid phone number."
    case passwordSame = "New password and confirmed password do not match."
    case userIsOfflineMode = "You are offline"
}

enum kServerStatus : Int {
    case NOValue ///No Value as per server enum match
    case New // 1
    case InProgress //2
    case OnHold // 3
    case Transferred // 4
    case InRectification // 5
    case Rejected // 6
    case Downloaded // 7
    case Invalid  //8
    case AwaitingPreInstall //9
    case PreInstallCompleted //10
    case AwaitingPostInstall  //11
    case PostInstallCompleted  //12
}

enum kWebURLs: String {
    case terms_conditions = ""
    case privacy_policy = "h"
}


func App_showAlert(withMessage message:String, inView viewC : UIViewController)
{
    let alert = UIAlertController(title: Application_Name, message: message, preferredStyle: UIAlertController.Style.alert)
    let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
    alert.addAction(action)
    viewC.present(alert, animated: true, completion: nil)
}

func isValidEmailID(strEmail: String) -> Bool
{
    let emailstr = strEmail.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailTest.evaluate(with: emailstr)
}

func isValidRegex(strInputText: String, strRegex: String) -> Bool
{
    let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", strRegex)
    return emailTest.evaluate(with: strInputText)
}


func isValidPasswordLength(strPass:String?) ->Bool {
    if (strPass != nil && strPass!.count >= 8) {
        return true
    } else {
        return false
    }
}
func isValidPassword(strPass:String?) ->Bool {
    //1 special character, 1 numeric, 1 uppecase, 1 lowe case and minimum 8 character.
    let passRegex = "^(?=.*[A-Z])(?=.*[!@<>|#$&*])(?=.*[0-9])(?=.*[a-z]).{8,}$"
    let passTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", passRegex)
    return passTest.evaluate(with: strPass)
}


func checkHandleStringNULL(str:AnyObject?) -> AnyObject? {
    if let nullObject = str as? NSNull {
        return "" as AnyObject
    }
    if let nullString = str as? String,nullString == "<null>" {
        return "" as AnyObject
    }
    return str
}

func isNumeric(strNumber:String) -> Bool
{
    let allowedCharacters = CharacterSet(charactersIn: "0123456789+()")
    let characterSet = CharacterSet(charactersIn: strNumber)
    return allowedCharacters.isSuperset(of: characterSet)
}

func getMsg(arr:AnyObject) -> String {
    var msg = ""
    if let ar = arr as? NSArray {
        msg = ar.componentsJoined(by: ",")
    }
    return msg
}

func isalphaNumeric(strAlphaNumber:String) -> Bool
{
    let str = strAlphaNumber.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    let allowedCharacters = CharacterSet(charactersIn: ".- abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
    let characterSet = CharacterSet(charactersIn: str)
    return allowedCharacters.isSuperset(of: characterSet)
}


func callNumber(phoneNumber:String) {
    if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
        
        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(phoneCallURL)) {
            application.open(phoneCallURL, options: [:], completionHandler: nil)
        }
    }
}




func showAlertIFornternetWithRetry(retrytapped: @escaping () -> Void)
{
    let alert = UIAlertController(title: Application_Name, message:kValidationMsg.userIsOfflineMode.rawValue, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action: UIAlertAction!) in
        
    }))
    alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
        retrytapped()
    }))
    appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
}

func showAlertWithAction(title:String,message1:String,arrAction:[UIAlertAction]) {
    let alert = UIAlertController(title: title,message:message1, preferredStyle: UIAlertController.Style.alert)
    for action in arrAction {
        alert.addAction(action)
    }
    appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
}

func validEmailAddress(_ emailString: String) -> Bool
{
    let regExPattern: String = kREG_EX_FOR_EMAIL
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", regExPattern)
    return emailPredicate.evaluate(with: emailString)
    // email valid
}
