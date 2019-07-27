//
//  PaymentMethodListVC.swift
//  Mpos
//
//  Created by Yash on 21/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class PaymentMethodListVC: UIViewController
{
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSidebar: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblPaymentList: UITableView!
    @IBOutlet weak var btnContinue: UIButton!

    //Declare Variables
    let arrPaymentData = NSMutableArray()
//    var selectedCategoryColor = UIColor()
    var iSelectedPaymentTag = Int()
    var InvoiceType:Int = 0

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var lblColor = UIColor()
        switch InvoiceType {
        case 1: //RISCO DE ANULAÇÃO
            lblColor = AppColors.kOrangeColor
            break
        case 2: //POR COBRAR
            lblColor = AppColors.kPurpulColor
            break
        case 3: // COBRADOS
            lblColor = AppColors.kGreenColor
            break
        case 4: // General Search
            lblColor = AppColors.kGeneralSearchColor
            break
        default:
            break
        }
        
        btnBack.tintColor = lblColor
        btnSidebar.tintColor = lblColor
        lblTitle.textColor = lblColor

        self.tblPaymentList.tableFooterView = UIView(frame: .zero)
        self.tblPaymentList.estimatedRowHeight = 80
        self.tblPaymentList.rowHeight = UITableView.automaticDimension

        var dictTemp = ["imgPayment":"ic_MBway","Title":"MBWAY","subtitle":"Definir contacto","bHasICon":true,"bisSelected":false] as [String : Any]
        arrPaymentData.add(dictTemp)
        
        dictTemp = ["imgPayment":"ic_MB","Title":"REFERÊNCIA MULTIBANCO","subtitle":"","bHasICon":false,"bisSelected":false] as [String : Any]
        arrPaymentData.add(dictTemp)

        dictTemp = ["imgPayment":"ic_ChipPin","Title":"CARTÃO DE DÉBITO","subtitle":"","bHasICon":false,"bisSelected":false] as [String : Any]
        arrPaymentData.add(dictTemp)
        self.tblPaymentList.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: User Actions
    @IBAction func paymentTapped(_ sender: UIButton)
    {
        switch iSelectedPaymentTag
        {
        case 0:
            break
        case 1:
            let storyBoard = UIStoryboard(name: "PaymentMode", bundle: nil)
            let controller = storyBoard.instantiateViewController(withIdentifier: "MposReferenciaVC") as! MposReferenciaVC
            self.navigationController?.pushViewController(controller, animated: true)
            break
        case 2:
            let storyBoard = UIStoryboard(name: "PaymentMode", bundle: nil)
            let controller = storyBoard.instantiateViewController(withIdentifier: "MposPinVC") as! MposPinVC
            self.navigationController?.pushViewController(controller, animated: true)
            break
        default:
            break
        }
        
    }
    
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
extension PaymentMethodListVC: UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrPaymentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = UITableViewCell()
        
        var lblColor = UIColor()
        switch InvoiceType {
        case 1: //RISCO DE ANULAÇÃO
            lblColor = AppColors.kOrangeColor
            break
        case 2: //POR COBRAR
            lblColor = AppColors.kPurpulColor
            break
        case 3: // COBRADOS
            lblColor = AppColors.kGreenColor
            break
        case 4: // General Search
            lblColor = AppColors.kGeneralSearchColor
            break
        default:
            break
        }
        if let dicData = arrPaymentData[indexPath.row] as? [String:Any]
        {
            if indexPath.row == 0
            {
                let cellPaymentMethodList =  tableView.dequeueReusableCell(withIdentifier: "PaymentMethodListTableViewCell", for: indexPath) as! PaymentMethodListTableViewCell
                
                cellPaymentMethodList.imgPaymentMethod.image = UIImage(named: (dicData["imgPayment"] as? String)!)
                cellPaymentMethodList.lblName.text = dicData["Title"] as? String
                cellPaymentMethodList.lblsubTitle.text = dicData["subtitle"] as? String
                cellPaymentMethodList.btnEdit.isHidden = !(dicData["bHasICon"] as? Bool)!
                cellPaymentMethodList.lblPhoneTitle.textColor = lblColor

                
                cellPaymentMethodList.btnEditTapped =
                 {
                        if cellPaymentMethodList.btnEdit.isSelected
                        {
                            cellPaymentMethodList.btnEdit.isSelected = false
                            cellPaymentMethodList.vwPhoneView.isHidden = true
                            cellPaymentMethodList.ctHeightPhoneView.constant = 0
                            self.tblPaymentList.reloadData()

                        }
                        else
                        {
                            cellPaymentMethodList.ctHeightPhoneView.constant = 70
                            cellPaymentMethodList.vwPhoneView.isHidden = false
                            cellPaymentMethodList.layoutIfNeeded()
                            cellPaymentMethodList.btnEdit.isSelected = true
                            self.tblPaymentList.reloadData()

                            DispatchQueue.main.async {
                                cellPaymentMethodList.txtfdPhoneNumber.becomeFirstResponder()
                            }
                        }
                    
                }
                
                if cellPaymentMethodList.btnEdit.isSelected == true
                {
                    cellPaymentMethodList.ctHeightPhoneView.constant = 70
                    cellPaymentMethodList.vwPhoneView.isHidden = false
                    cellPaymentMethodList.txtfdPhoneNumber.becomeFirstResponder()
                    cellPaymentMethodList.lblsubTitle.text = "Sem contacto"

                }
                else
                {
                    cellPaymentMethodList.vwPhoneView.isHidden = true
                    cellPaymentMethodList.ctHeightPhoneView.constant = 0
                    cellPaymentMethodList.lblsubTitle.text = dicData["subtitle"] as? String

                }
                
                if ((dicData["bisSelected"] as! Bool) == true)
                {
                    cellPaymentMethodList.imgSelected.backgroundColor = lblColor
                    cellPaymentMethodList.contentView.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.6)

                }
                else
                {
                    cellPaymentMethodList.imgSelected.backgroundColor = UIColor.clear
                    cellPaymentMethodList.contentView.backgroundColor = UIColor.white

                }
                cell = cellPaymentMethodList
            }
            else
            {
                let cellPaymentMethodListNormal =  tableView.dequeueReusableCell(withIdentifier: "PaymentMethodListNormalTableViewCell", for: indexPath) as! PaymentMethodListNormalTableViewCell
                
                cellPaymentMethodListNormal.imgPaymentMethod.image = UIImage(named: (dicData["imgPayment"] as? String)!)
                cellPaymentMethodListNormal.lblName.text = dicData["Title"] as? String
                
                if ((dicData["bisSelected"] as! Bool) == true)
                {
                    cellPaymentMethodListNormal.imgSelected.backgroundColor = lblColor
                    cellPaymentMethodListNormal.contentView.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.6)
                }
                else
                {
                    cellPaymentMethodListNormal.imgSelected.backgroundColor = UIColor.clear
                    cellPaymentMethodListNormal.contentView.backgroundColor = UIColor.white
                }
                cell = cellPaymentMethodListNormal
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var iReplaceObjIndex = Int()

        for dictemp in arrPaymentData
        {
            if var dicData = dictemp as? [String:Any]
            {
                iReplaceObjIndex = arrPaymentData.index(of: dicData)
                dicData["bisSelected"] = false
                arrPaymentData.replaceObject(at: iReplaceObjIndex, with: dicData)
            }
        }
        
        iSelectedPaymentTag = indexPath.row
        
        var dicData = arrPaymentData[indexPath.row] as? [String:Any]
        dicData!["bisSelected"] = true
        arrPaymentData.replaceObject(at: indexPath.row, with: dicData!)
        btnContinue.backgroundColor = AppColors.kButtonSelectedColor
        tblPaymentList.reloadData()
    }
}
