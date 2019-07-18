//
//  AppDelegate.swift
//  Mpos
//
//  Created by Kevin on 17/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var onboardingContainer: UIView!
    @IBOutlet weak var skipBtn: UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
//        if UserDefaultManager.SharedInstance.isOnboardingComplete()
//        {
//            //Normal Login View
//            self.skipBtn.isHidden = true
//        }
//        else
//        {
            self.setOnboardingUI()
//        }
       
    }
    
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

