//
//  AppDelegate.swift
//  Mpos
//
//  Created by Kevin on 17/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var onboardingContainer: UIView!
    @IBOutlet weak var skipBtn: UIButton!

    @IBOutlet weak var txtfdEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtfdPassword: SkyFloatingLabelTextField!
    
    
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    
    @IBOutlet weak var btnPasswordEye: UIButton!
    @IBOutlet weak var btnRememberPassword: UIButton!

    @IBOutlet weak var scrvwLogin: UIScrollView!
    
    var isRememberPassword : Bool = false
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.txtfdPassword.isSecureTextEntry = false
        lblEmail.text = lblEmail.text!.uppercased()
        lblPassword.text = lblPassword.text!.uppercased()
        
        txtfdEmail.text = "test@gmail.com"
        txtfdPassword.text = "test"

        if Device.IS_IPHONE && Device.SCREEN_HEIGHT < 568
        {
            scrvwLogin.isScrollEnabled = true
        }
        else
        {
            scrvwLogin.isScrollEnabled = false
        }
        
        
        if UserDefaultManager.SharedInstance.isOnboardingComplete()
        {
            //Normal Login View
            onboardingContainer.removeFromSuperview()
            self.skipBtn.isHidden = true
        }
        else
        {
            self.setOnboardingUI()
        }
        
    }
    
    /*
     Screen 8 | Onboarding
     The “Mpos_onboarding”, “Mpos_onboarding – 1”, “Mpos_onboarding – 2” screens represent the onboarding panel for this app. They should appear on the first ever login of a user.
     */
    func setOnboardingUI()
    {
        onboardingContainer.frame = CGRect(x: 0, y: 0, width: MainScreen.width, height: MainScreen.height)
        
        // Do any additional setup after loading the view.
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
        controller.willMove(toParent: self)
        onboardingContainer.addSubview(controller.view)
        self.addChild(controller)
        controller.didMove(toParent: self)
    }
    
    //MARK: User Actions
    @IBAction func skipOnboarding(_ sender: UIButton)
    {
        UserDefaultManager.SharedInstance.setOnboardingCmplete(isComplete: true)
        skipBtn.isHidden = true
        onboardingContainer.removeFromSuperview()
    }
    
   
}

extension ViewController {
    
    //LogIn button click
    @IBAction func btnLoginClicked(_ sender: Any)
    {
        if self.doValidation()
        {
            let params = ["bsUSer":txtfdEmail.text,"bsPassword":txtfdPassword.text]
            //Call Login Service
            MainReqeustClass.BaseRequestSharedInstance.PostRequset(showLoader: true, url: "5d3b0fa83000008800a29f75", parameter: nil, success: { (response) in
                print(response)

                if let dictagentContext = response["agentContext"] as? [String : Any]
                {
                    UserDefaultManager.SharedInstance.saveLoggedUser(dict: dictagentContext)
                }
                
                // api call
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyBoard.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                let navController = UINavigationController(rootViewController: controller)
                navController.navigationBar.isHidden = true
                appDelegate.window?.rootViewController = navController

            })
            { (responseError) in
                print(responseError)
            }
        }
    }
    
    
    
    /*
     Forgot password button click event.
     - Version: 1.0
     - Remark:nil
     */
    @IBAction func btnForgotPasswordClicked(_ sender: Any) {
        
        // forgot password logic
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //set visibility for password in SignUp
    @IBAction func btnSEtVisibilityPasswordLogin(_ sender: UIButton) {
        sender.isSelected.toggle()
        self.txtfdPassword.isSecureTextEntry.toggle()
    }
    
    //MARK: User Actions
    @IBAction func rememberPasswordClicked(_ sender: UIButton)
    {
        if isRememberPassword
        {
            isRememberPassword = false

            btnRememberPassword.isSelected = false
        }
        else
        {
            isRememberPassword = true
            btnRememberPassword.isSelected = true

        }
    }
    
    /*
     Validation at login time
     - Authors:
     - Version: 1.0
     - Remark: nil
     */
    //LogIn Screen
    func doValidation() -> Bool
    {
        //Validation: Check For Username
        if !((self.txtfdEmail.text?.trimmingCharacters(in: CharacterSet.whitespaces).count ?? 0) > 0) {
            self.txtfdEmail.errorMessage = kAlertEnterEmailId
            return false
        }
        else {
            if validEmailAddress(txtfdEmail.text!) == false
            {
                self.txtfdEmail.errorMessage = kAlertInvalidEmailId
                return false
            }
        }
        //Validation: Check For password
        if !((self.txtfdPassword.text?.trimmingCharacters(in: CharacterSet.whitespaces).count ?? 0) > 0)
        {
            self.txtfdPassword.errorMessage = kAlertEnterPassword
            return false
        }
        return true
    }
}

extension ViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        if textField.isKind(of: SkyFloatingLabelTextField.self)
        {
            (textField as! SkyFloatingLabelTextField).errorMessage = ""
        }
        return true
    }
    
}
