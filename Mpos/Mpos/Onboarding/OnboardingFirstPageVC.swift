//
//  OnboardingFirstPageVC.swift
//  Mpos
//
//  Created by Yash on 23/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class OnboardingFirstPageVC: UIViewController
{
    @IBOutlet weak var imgVW: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let jeremyGif = UIImage.gifImageWithName("onb_1")
        imgVW.image = jeremyGif
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
