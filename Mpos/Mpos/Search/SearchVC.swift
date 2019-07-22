//
//  SearchVC.swift
//  Mpos
//
//  Created by kaushal panchal on 20/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var btnRadio1: UIButton!
    @IBOutlet weak var btnRadio2: UIButton!
    
    @IBOutlet weak var lblSeachSelectionInstruction: UILabel!
    
    @IBOutlet weak var txtfdSearch: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtfdSearch.becomeFirstResponder()
        btnRadio1.isSelected = true
        btnRadio2.isSelected = false
        lblSeachSelectionInstruction.text = "Introduza um NIF, uma Apólice ou um Recibo"
        
        txtfdSearch.text = "ULK1983919"
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: txtfdSearch.frame.size.height))
        txtfdSearch.leftView = paddingView
        txtfdSearch.leftViewMode = .always
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    @IBAction func radioBtnSelectionForSearch(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            btnRadio1.isSelected = true
            btnRadio2.isSelected = false
            lblSeachSelectionInstruction.text = "Introduza um NIF, uma Apólice ou um Recibo"
            
            txtfdSearch.text = "ULK1983919"
            break
        case 2:
            btnRadio1.isSelected = false
            btnRadio2.isSelected = true
            lblSeachSelectionInstruction.text = "Introduza uma Apólice ou um Recibo"
            txtfdSearch.text = "245319873"
            break
        default:
            break
        }
        
    }
    
    @IBAction func btnSearchClicked(_ sender: Any) {
        
    }
    
    @IBAction func btnCrossClicked(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
