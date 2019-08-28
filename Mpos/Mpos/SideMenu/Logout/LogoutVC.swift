//
//  LogoutVC.swift
//  Mpos
//
//  Created by kaushal panchal on 21/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class LogoutVC: UIViewController {

    @IBOutlet weak var imgvw: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gifName = "Logout.gif"
        
        do {
            let gifImage = try UIImage(gifName: gifName)
            imgvw.setGifImage(gifImage)
        } catch let error {
            print("Error : \(error.localizedDescription)")
        }
    }
    

    @IBAction func btnLogoutClicked(_ sender: Any)
    {
        // Do any additional setup after loading the view.
        let loggedUser = UserDefaultManager.SharedInstance.getLoggedUser()
        let params = ["agentContext":loggedUser]
        
        MainReqeustClass.BaseRequestSharedInstance.postRequestWithHeader(showLoader: true, url: base_Url, parameter: params as [String : AnyObject], header: CommonMethods().createHeaderDic(strMethod: logoutUrl), success: { (response) in
            print(response)
            UserDefaultManager.SharedInstance.removeUser()
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
            appDelegate.window?.rootViewController = controller
        })
        { (responseError) in
//            CommonMethods().displayAlertView("Error", aStrMessage: responseError, aStrOtherTitle: "ok")
            addErrorView(senderViewController: self, strErrorMessage: responseError)
        }
    }
    
    @IBAction func btnMoveToSideMenuClicked(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
