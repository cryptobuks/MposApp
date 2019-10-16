//
//  MposPinVC.swift
//  Mpos
//
//  Created by Yash on 21/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class MposPinVC: UIViewController {

    var bViewAdded = Bool()
    @IBOutlet weak var btnClose: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if bViewAdded == true
        {
            btnClose.isHidden = true
        }
    }
    
    @IBAction func viewTapped(_ sender: UIButton)
    {
        if bViewAdded == false
        {
            let storyBoard = UIStoryboard(name: "PaymentMode", bundle: nil)
            let controller = storyBoard.instantiateViewController(withIdentifier: "PaymentSuccessVC") as! PaymentSuccessVC
            controller.strSucessMessage = "A cobrança foi efetuada com sucesso."
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    //MARK: User Actions
    @IBAction func closeTapped(_ sender: UIButton)
    {
        if bViewAdded == false
        {
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            self.view.removeFromSuperview()
        }
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
