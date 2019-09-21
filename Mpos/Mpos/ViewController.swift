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
        self.txtfdPassword.isSecureTextEntry = true
        lblEmail.text = lblEmail.text!.uppercased()
        lblPassword.text = lblPassword.text!.uppercased()
        
        txtfdEmail.text = "joao.luis"
        txtfdPassword.text = "abc123"
        
        if Device.IS_IPHONE && Device.SCREEN_HEIGHT < 568
        {
            scrvwLogin.isScrollEnabled = true
        }
        else
        {
            scrvwLogin.isScrollEnabled = false
        }
        
        if userDefaults.bool(forKey: kbIsRememberPassword)
        {
            txtfdEmail.text = (userDefaults.value(forKey: kkey_email) as! String)
            txtfdPassword.text = userDefaults.value(forKey: kkey_password) as? String
            btnRememberPassword.isSelected = true
        }
        
        
        
        if UserDefaultManager.SharedInstance.isOnboardingComplete()
        {
            do {
                try self.initMSAL()
            } catch let error {
                addErrorView(senderViewController: self, strErrorMessage: "Unable to create Application Context \(error)")
            }

            //Normal Login View
            onboardingContainer.removeFromSuperview()
            self.skipBtn.isHidden = true
        }
        else
        {
            self.setOnboardingUI()
        }
        
        
        
    }
    
    
    
    /**
     
     Initialize a MSALPublicClientApplication with a given clientID and authority
     
     - clientId:            The clientID of your application, you should get this from the app portal.
     - redirectUri:         A redirect URI of your application, you should get this from the app portal.
     If nil, MSAL will create one by default. i.e./ msauth.<bundleID>://auth
     - authority:           A URL indicating a directory that MSAL can use to obtain tokens. In Azure AD
     it is of the form https://<instance/<tenant>, where <instance> is the
     directory host (e.g. https://login.microsoftonline.com) and <tenant> is a
     identifier within the directory itself (e.g. a domain associated to the
     tenant, such as contoso.onmicrosoft.com, or the GUID representing the
     TenantID property of the directory)
     - error                The error that occurred creating the application object, if any, if you're
     not interested in the specific error pass in nil.
     */
    func initMSAL() throws {
        
        //https://login.microsoftonline.com/e7f9d69c-13f3-457c-a04c-f555c1134fa4
        /*let authority = try MSALAADAuthority(cloudInstance: .publicCloudInstance, audienceType: .azureADMyOrgOnlyAudience, rawTenant: "e7f9d69c-13f3-457c-a04c-f555c1134fa4")
        
        let msalConfiguration = MSALPublicClientApplicationConfig(clientId: appDelegate.kClientID, redirectUri: nil, authority: authority)
        appDelegate.applicationContext = try MSALPublicClientApplication(configuration: msalConfiguration)*/
        
        guard let authorityURL = URL(string: appDelegate.kAuthority) else {
            addErrorView(senderViewController: self, strErrorMessage: "Unable to create authority URL")
            return
        }

        let authority = try MSALAADAuthority(url: authorityURL)
        
        let msalConfiguration = MSALPublicClientApplicationConfig(clientId: appDelegate.kClientID, redirectUri: nil, authority: authority)
        appDelegate.applicationContext = try MSALPublicClientApplication(configuration: msalConfiguration)

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
        do {
            try self.initMSAL()
        } catch let error {
            addErrorView(senderViewController: self, strErrorMessage: "Unable to create Application Context \(error)")
        }
    }
}

extension ViewController {
    
    //LogIn button click
    @IBAction func btnLoginClicked(_ sender: UIButton)
    {
        callGraphAPI(sender)
        
        
//        if userDefaults.bool(forKey: kbIsRememberPassword)
//        {
//            userDefaults.set(txtfdEmail.text, forKey: kkey_email)
//            userDefaults.set(txtfdPassword.text, forKey: kkey_password)
//        }
//        else
//        {
//            userDefaults.removeObject(forKey: kkey_email)
//            userDefaults.removeObject(forKey: kkey_password)
//        }
//
//        if self.doValidation()
//        {
//            let params = ["username":txtfdEmail.text!,"password":txtfdPassword.text!]
//            //Call Login Service
//
//            MainReqeustClass.BaseRequestSharedInstance.postRequestWithHeader(showLoader: true, url: base_Url, parameter: params as [String : AnyObject], header: CommonMethods().createHeaderDic(strMethod: loginUrl), success: { (response) in
//                print(response)
//
//                if let dictagentContext = response["agentContext"] as? [String : Any]
//                {
//                    let dictTemp = NSMutableDictionary(dictionary: dictagentContext)
//                    UserDefaultManager.SharedInstance.saveLoggedUser(dict: dictTemp as! [String : Any])
//                }
//
//                // api call
//                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                let controller = storyBoard.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
//                let navController = UINavigationController(rootViewController: controller)
//                navController.navigationBar.isHidden = true
//                appDelegate.window?.rootViewController = navController
//
//            })
//            { (responseError) in
//                print(responseError)
//                addErrorView(senderViewController: self, strErrorMessage: responseError)
////                CommonMethods().displayAlertView("Error", aStrMessage: responseError, aStrOtherTitle: "ok")
//            }
//        }
    }
    
    func gotoDashboardScreen()
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
        let navController = UINavigationController(rootViewController: controller)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
    }
    
}

// MARK: Acquiring and using token

extension ViewController {
    
    /**
     This will invoke the authorization flow.
     */
    
    @objc func callGraphAPI(_ sender: UIButton) {
        MainReqeustClass.ShowActivityIndicatorInStatusBar(shouldShowHUD: true)
        guard let currentAccount = appDelegate.currentAccount() else {
            // We check to see if we have a current logged in account.
            // If we don't, then we need to sign someone in.
            acquireTokenInteractively()
            return
        }
        
        acquireTokenSilently(currentAccount)
    }
    
    func acquireTokenInteractively() {
        
        guard let applicationContext = appDelegate.applicationContext else { return }
        
        let parameters = MSALInteractiveTokenParameters(scopes: appDelegate.kScopes)
        
        applicationContext.acquireToken(with: parameters) { (result, error) in
            
            if let error = error {
                addErrorView(senderViewController: self, strErrorMessage: "Could not acquire token: \(error)")
                return
            }
            
            guard let result = result else {
                addErrorView(senderViewController: self, strErrorMessage: "Could not acquire token: No result returned")
                return
            }
            
            if result.idToken != nil
            {
                appDelegate.accessToken = result.idToken!
            }
            
            self.getContentWithToken()
        }
    }
    
    func acquireTokenSilently(_ account : MSALAccount!) {
        
        guard let applicationContext = appDelegate.applicationContext else { return }
        
        /**
         
         Acquire a token for an existing account silently
         
         - forScopes:           Permissions you want included in the access token received
         in the result in the completionBlock. Not all scopes are
         guaranteed to be included in the access token returned.
         - account:             An account object that we retrieved from the application object before that the
         authentication flow will be locked down to.
         - completionBlock:     The completion block that will be called when the authentication
         flow completes, or encounters an error.
         */
        
        let parameters = MSALSilentTokenParameters(scopes: appDelegate.kScopes, account: account)
        
        applicationContext.acquireTokenSilent(with: parameters) { (result, error) in
            
            if let error = error {
                
                let nsError = error as NSError
                
                // interactionRequired means we need to ask the user to sign-in. This usually happens
                // when the user's Refresh Token is expired or if the user has changed their password
                // among other possible reasons.
                
                if (nsError.domain == MSALErrorDomain) {
                    
                    if (nsError.code == MSALError.interactionRequired.rawValue) {
                        
                        DispatchQueue.main.async {
                            self.acquireTokenInteractively()
                        }
                        return
                    }
                }
                addErrorView(senderViewController: self, strErrorMessage: "Could not acquire token silently: \(error)")

                return
            }
            
            guard let result = result else {
                addErrorView(senderViewController: self, strErrorMessage: "Could not acquire token: No result returned")
                return
            }
            
            if result.idToken != nil
            {
                appDelegate.accessToken = result.idToken!
            }
            self.getContentWithToken()
        }
    }
    
    /**
     This will invoke the call to the Microsoft Graph API. It uses the
     built in URLSession to create a connection.
     */
    
    func getContentWithToken() {
        
        // Specify the Graph API endpoint
        let url = URL(string: appDelegate.kGraphURI)
        var request = URLRequest(url: url!)
        
        // Set the Authorization header for the request. We use Bearer tokens, so we specify Bearer + the token we got from the result
        request.setValue("Bearer \(appDelegate.accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                addErrorView(senderViewController: self, strErrorMessage: "Couldn't get graph result: \(error)")
                return
            }
            
            guard let result = try? JSONSerialization.jsonObject(with: data!, options: []) else {
                addErrorView(senderViewController: self, strErrorMessage: "Couldn't deserialize result JSON")
                return
            }
            
            
            UserDefaultManager.SharedInstance.saveToken(str: "Bearer \(appDelegate.accessToken)")
             UserDefaultManager.SharedInstance.saveData(dict: result as! [String : Any], strKeyName: kAzureLoginData)
            // api call
            if Thread.isMainThread {
                MainReqeustClass.HideActivityIndicatorInStatusBar()

                self.gotoDashboardScreen()
            } else {
                DispatchQueue.main.async {
                    MainReqeustClass.HideActivityIndicatorInStatusBar()

                    self.gotoDashboardScreen()
                }
            }
            }.resume()
    }
    
}

