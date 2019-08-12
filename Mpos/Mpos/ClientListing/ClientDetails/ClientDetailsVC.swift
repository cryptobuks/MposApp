//
//  ClientDetailsVC.swift
//  Mpos
//
//  Created by kaushal panchal on 21/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//


import UIKit

class ClientDetailsVC: UIViewController
{
    @IBOutlet weak var tblClientDetails: UITableView!
    let arrRows = NSMutableArray()
    var invoiceType :Int = 3
    var objClientRef = [String:Any]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tblClientDetails.estimatedRowHeight = 30
        self.tblClientDetails.estimatedSectionHeaderHeight = UITableView.automaticDimension
        self.tblClientDetails.rowHeight = UITableView.automaticDimension
        
        var dictTemp = [String:Any]()
        
        dictTemp = ["details":objClientRef["name"] as? String ?? "","Title":"CLIENTE"]
        arrRows.add(dictTemp)
        
        dictTemp = ["details": "\(objClientRef["quantity"] as? Int ?? 0 )","Title":"Nº RECIBOS"]
        arrRows.add(dictTemp)
        
        let amount = "\(objClientRef["amount"])".toCurrencyFormat()
        dictTemp = ["details":"\(amount)","Title":"A PAGAR"]
        arrRows.add(dictTemp)
        
        dictTemp = ["details":"\(objClientRef["nif"] as? Int ?? 0)","Title":"NIF"]
        arrRows.add(dictTemp)
        
        dictTemp = ["details":"\(objClientRef["phone"] as? String ?? "")","Title":"CONTACTO"]
        arrRows.add(dictTemp)
        
        dictTemp = ["details":"\(objClientRef["email"] as? String ?? "")","Title":"E-MAIL"]
        arrRows.add(dictTemp)
        
        
        self.tblClientDetails.reloadData()
        // Do any additional setup after loading the view.
    }
    
    //MARK: User Actions
    @IBAction func goBackTapped(_ sender: UIButton)
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
extension ClientDetailsVC: UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let clientHeaderDetails = tableView.dequeueReusableCell(withIdentifier: "clientHeaderDetails", for: indexPath) as! clientHeaderDetails
        
        let clientDetails = tableView.dequeueReusableCell(withIdentifier: "clientDetails", for: indexPath) as! clientDetails
        
        let dicData = arrRows[indexPath.row] as? [String:AnyObject]
        
        switch indexPath.row {
        case 0:
            
            switch(invoiceType)
            {
            case 1:
                clientHeaderDetails.lblCaption.textColor = AppColors.kOrangeColor
                break
                
            case 2:
                clientHeaderDetails.lblCaption.textColor = AppColors.kPurpulColor
                break
                
            case 3:
                clientHeaderDetails.lblCaption.textColor = AppColors.kGreenColor
                break
            case 4:
                clientHeaderDetails.lblCaption.textColor = AppColors.kGeneralSearchColor
                break
            default:
                break
            }
            clientHeaderDetails.lblCaption.text = dicData!["Title"] as? String
            clientHeaderDetails.lblDetails.text = dicData!["details"] as? String

            return clientHeaderDetails
        default:
            
            switch(invoiceType)
            {
            case 1:
                clientDetails.lblCaption.textColor = AppColors.kOrangeColor
                break
                
            case 2:
                clientDetails.lblCaption.textColor = AppColors.kPurpulColor
                break
                
            case 3:
                clientDetails.lblCaption.textColor = AppColors.kGreenColor
                break
            case 4:
                clientDetails.lblCaption.textColor = AppColors.kGeneralSearchColor
                break
            default:
                break
            }

            clientDetails.lblCaption.text = dicData!["Title"] as? String
            clientDetails.lblDetails.text = dicData!["details"] as? String

            return clientDetails
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
}


class clientHeaderDetails: UITableViewCell {
    @IBOutlet weak var lblCaption: UILabel!
    @IBOutlet weak var lblDetails: UILabel!

}


class clientDetails: UITableViewCell {
    @IBOutlet weak var lblCaption: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
}
