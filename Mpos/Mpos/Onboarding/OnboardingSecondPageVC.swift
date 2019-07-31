//
//  OnboardingSecondPageVC.swift
//  Mpos
//
//  Created by Yash on 24/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class OnboardingSecondPageVC: UIViewController {

    @IBOutlet weak var imgVW: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gifName = "onb_2.gif"
        
        do {
            let gifImage = try UIImage(gifName: gifName)
            imgVW.setGifImage(gifImage)
        } catch let error {
            print("Error : \(error.localizedDescription)")
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
