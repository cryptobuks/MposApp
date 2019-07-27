//
//  PaymentSuccessVC.swift
//  Mpos
//
//  Created by Yash on 21/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class PaymentSuccessVC: UIViewController
{
    @IBOutlet weak var imgvw: UIImageView!
    @IBOutlet weak var lblSucessMessage: UILabel!
    var strSucessMessage = String()

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let logoutGIF = UIImage.gifImageWithName("Sucess")
        imgvw.image = logoutGIF

        // Do any additional setup after loading the view.
        lblSucessMessage.text = strSucessMessage
        
        let timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { timer in
            self.navigationController?.popToRootViewController(animated: true)
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
