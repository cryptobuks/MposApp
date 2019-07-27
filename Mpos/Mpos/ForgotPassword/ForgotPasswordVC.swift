//
//  ForgotPasswordVC.swift
//  Mpos
//
//  Created by Yash on 27/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var txtfdEmail: SkyFloatingLabelTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goBackTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmitTapped(_ sender: UIButton)
    {
        
    }
    
    func doValidation() -> Bool {
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
        return true
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
