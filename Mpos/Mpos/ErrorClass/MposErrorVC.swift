//
//  MposErrorVC.swift
//  Mpos
//
//  Created by Yash on 21/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class MposErrorVC: UIViewController {

    @IBOutlet weak var lblErrorMessage: UILabel!
    var strErrorMessage = String()
    @IBOutlet weak var imgvw: UIImageView!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        let logoutGIF = UIImage.gifImageWithName("erro")
        imgvw.image = logoutGIF

        // Do any additional setup after loading the view.
        lblErrorMessage.text = strErrorMessage

    }
    
    //MARK: User Actions
    @IBAction func closeTapped(_ sender: UIButton)
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
