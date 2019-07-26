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
        let logoutGIF = UIImage.gifImageWithName("Logout")
        imgvw.image = logoutGIF
    }
    

    @IBAction func btnLogoutClicked(_ sender: Any) {
        // Do any additional setup after loading the view.
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
        appDelegate.window?.rootViewController = controller
    }
    
    
    @IBAction func btnMoveToSideMenuClicked(_ sender: Any) {
        
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
