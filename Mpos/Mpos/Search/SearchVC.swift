//
//  SearchVC.swift
//  Mpos
//
//  Created by kaushal panchal on 20/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//
/*Class Purpose:The general search screen allows users to search for invoices. The screen is represented in figure 5. Users can search for two types of invoices (i.e. “Meus” and “Terceiros”) in the data input bar shown in the middle of the screen. The components of the general search screen are as follows:
1. The blue cross icon on the top right corner of the screen directs the user back to the Home Page screen;
2. There is a light blue design element with the standard text “Pesquisa”, which indicates that this is a search screen;
3. Two radio buttons with the options “Meus” and “Terceiros”. Users can only choose one of these options. The screen represented in figure 5 shows the “Meus” option being selected;
4. Standard text under the radio buttons. Please note that this standard text changes depending on the radio button selected by users, as outlined in figure 6. When the “Meus” option is selected the standard text is “Introduza um NIF, uma Apólice ou um Recibo”. When the “Terceiros” option is selected the standard text is “Introduza uma Apólice ou um Recibo”. Essentially, this means that there are 3 search criteria available (handled and detected by the web service described in point 6 below and in Annex 1):
a. “NIF” (i.e. “National Tax Number”);
b. “Apólice” (i.e. “Insurance Policy”);
c. “Recibo” (i.e. “Invoice”);
d. N.B. The “NIF” search criteria is disregarded by the search web service when the “Terceiros” radio button is selected;
5. A data input bar on which users can insert data. Please note that the native keyboard function of the device should appear on this screen by default, and not only when users press the data input bar;
6. A blue and white magnifying glass icon which actually performs the search by calling WS007 (as described in Annex 1) and directs users to the general search results screen (Mpos_resultado), as described in the next section.*/
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
        
        txtfdSearch.text = ""
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
            
            txtfdSearch.text = ""
            break
        case 2:
            btnRadio1.isSelected = false
            btnRadio2.isSelected = true
            lblSeachSelectionInstruction.text = "Introduza uma Apólice ou um Recibo"
            txtfdSearch.text = ""
            break
        default:
            break
        }
        
    }
    
    @IBAction func btnSearchClicked(_ sender: Any)
    {
        MainReqeustClass.BaseRequestSharedInstance.getSearchResult(parameter: nil, header: nil, strMethodName: "5d3b117d3000008600a29f84", successCall: { (response) in
            print(response)

            let storyBoard = UIStoryboard(name: "InvoiceList", bundle: nil)
            let clientWiseInvoiceVC = storyBoard.instantiateViewController(withIdentifier: "ClientWiseInvoiceListing") as! ClientWiseInvoiceListing
            clientWiseInvoiceVC.InvoiceType = 4
            
            //set data for client Listing
            clientWiseInvoiceVC.arrCompanies.removeAllObjects()
            if let arrCompanies = response["companies"] as? NSArray
            {
                clientWiseInvoiceVC.arrCompanies.addObjects(from: arrCompanies as! [Any])
            }
            
            if let dictClientRef = response["clientRef"] as? [String:Any]
            {
                clientWiseInvoiceVC.objClientRef = dictClientRef
            }
            
            if (self.btnRadio2.isSelected == true)
            {
                clientWiseInvoiceVC.bTerceirosSelected = true
            }
            else
            {
                clientWiseInvoiceVC.bTerceirosSelected = false
            }
            self.navigationController?.pushViewController(clientWiseInvoiceVC, animated: true)
        })
        { (responseError) in
            print(responseError)
        }
        
//        let storyBoard = UIStoryboard(name: "Search", bundle: nil)
//        let clientWiseInvoiceVC = storyBoard.instantiateViewController(withIdentifier: "GeneralSearchResultVC") as! GeneralSearchResultVC
//        self.navigationController?.pushViewController(clientWiseInvoiceVC, animated: true)
    }
    
    @IBAction func btnCrossClicked(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
