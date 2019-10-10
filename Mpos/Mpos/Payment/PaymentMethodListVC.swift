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

    var strPhonenumber = String()
    //Declare Variables
    let arrPaymentData = NSMutableArray()
//    var selectedCategoryColor = UIColor()
    var iSelectedPaymentTag = Int()
    var InvoiceType:Int = 0
    var totalAmt = String()
    var objClientRef = [String:Any]()
    var objSelectedCompany = [String:Any]()
    var arrReceipts = [[String:Any]]()
    var dicChipPin = [[String:Any]]()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        print(objClientRef,objSelectedCompany,arrReceipts)
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
        
        btnContinue.setTitle("COBRAR \(totalAmt)", for: .normal)
        // Do any additional setup after loading the view.
    }
    
    //MARK: User Actions
    @IBAction func paymentTapped(_ sender: UIButton)
    {
        switch iSelectedPaymentTag
        {
        case 0:
            var dicRequestData = [String:Any]()
            dicRequestData["nif"] = objClientRef["nif"]
            dicRequestData["phoneNumber"] = strPhonenumber
            
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let date = Date()
            let dateString = dateFormatter.string(from: date)
            
            dicRequestData["timestamp"] = dateString //Current timestamp
            dicRequestData["paymentBrand"] = "1" //Static value 2 for MbWay
            dicRequestData["internalCompany"] = objSelectedCompany["companyId"]
            dicRequestData["appOrigemId"] = "100"
            dicRequestData["totalAmount"] = objSelectedCompany["amount"]
            if let dictagentContext = UserDefaultManager.SharedInstance.getLoggedUser()
            {
               dicRequestData["userId"] = dictagentContext["agentId"]
            }
            dicRequestData["printType"] =  "E"
            var arrReceiptsforRequest = [[String:Any]]()
            for receipt in arrReceipts{
                arrReceiptsforRequest.append(["policy": receipt["policyId"] as! String,"idReceipt": receipt["receiptId"] as! String,"prefixDoc": "RC","amount": receipt["amount"] as! Double,"idDocument": "","thirdParty": false])
            }
            dicRequestData["receipts"] = arrReceiptsforRequest
            if (objClientRef["thirdParty"] as! Bool) == true {
                dicRequestData["thirdParty"] = 1

            }else{
                dicRequestData["thirdParty"] = 0

            }
            
            MainReqeustClass.BaseRequestSharedInstance.postRequestWithHeader(showLoader: true, url: basemock_Url + mbwayPaymentUrl, parameter: dicRequestData as [String : AnyObject], header: [String : String](), success: { (response) in
                print(response)
                
                let storyBoard = UIStoryboard(name: "PaymentMode", bundle: nil)
                let controller = storyBoard.instantiateViewController(withIdentifier: "PaymentSuccessVC") as! PaymentSuccessVC
                controller.strSucessMessage = "O envio foi efetuado com sucesso."
                self.navigationController?.pushViewController(controller, animated: true)
                
            })
            { (responseError) in
                print(responseError)
                addErrorView(senderViewController: self, strErrorMessage: responseError)
                //                CommonMethods().displayAlertView("Error", aStrMessage: responseError, aStrOtherTitle: "ok")
            }
            
            
            break
        case 1:
            
            var dicRequestData = [String:Any]()
            dicRequestData["nif"] = objClientRef["nif"]
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let date = Date()
            let dateString = dateFormatter.string(from: date)
            dicRequestData["timestamp"] = dateString //Current timestamp
            dicRequestData["refIntlDtTm"] = dateString //Current timestamp
            let futuredate = Date().addingTimeInterval(30*24*60*60)
            let futuredateString = dateFormatter.string(from: futuredate)
            dicRequestData["refLmtDtTm"] = futuredateString //Current timestamp
            dicRequestData["paymentBrand"] = "2" //Static value 2 for refMB
            dicRequestData["internalCompany"] = objSelectedCompany["companyId"]
            dicRequestData["appOrigemId"] = "100"
            dicRequestData["totalAmount"] = objSelectedCompany["amount"]
            if let dictagentContext = UserDefaultManager.SharedInstance.getLoggedUser()
            {
                dicRequestData["userId"] = dictagentContext["agentId"]
            }
            dicRequestData["printType"] =  "E"
            
            var arrReceiptsforRequest = [[String:Any]]()
            for receipt in arrReceipts{
                arrReceiptsforRequest.append(["policy": receipt["policyId"] as! String,"idReceipt": receipt["receiptId"] as! String,"prefixDoc": "RC","amount": receipt["amount"] as! Double,"idDocument": "","thirdParty": 0])
            }
            
            dicRequestData["receipts"] = arrReceiptsforRequest
            if (objClientRef["thirdParty"] as! Bool) == true {
                dicRequestData["thirdParty"] = 1
                
            }else{
                dicRequestData["thirdParty"] = 0
                
            }
            
            MainReqeustClass.BaseRequestSharedInstance.postRequestWithHeader(showLoader: true, url: basemock_Url + refMBPaymentUrl, parameter: dicRequestData as [String : AnyObject], header: [String : String](), success: { (response) in
                print(response)
                
                let storyBoard = UIStoryboard(name: "PaymentMode", bundle: nil)
                let controller = storyBoard.instantiateViewController(withIdentifier: "MposReferenciaVC") as! MposReferenciaVC
                controller.entityCode = response["entity"] as! String
                controller.referenceCode = response["reference"] as! String
                controller.value = "\(response["amount"] as! Double)"
                self.navigationController?.pushViewController(controller, animated: true)
            })
            { (responseError) in
                print(responseError)
                addErrorView(senderViewController: self, strErrorMessage: responseError)
                //                CommonMethods().displayAlertView("Error", aStrMessage: responseError, aStrOtherTitle: "ok")
            }
            
            break
        case 2:
            
            var dicRequestData = [String:Any]()
            dicRequestData["nif"] = objClientRef["nif"]
            dicRequestData["paymentBrand"] = "0" //Static value 2 for chio pin
            dicRequestData["internalCompany"] = objSelectedCompany["companyId"]
            dicRequestData["appOrigemId"] = "100"
            dicRequestData["totalAmount"] = objSelectedCompany["amount"]
            if let dictagentContext = UserDefaultManager.SharedInstance.getLoggedUser()
            {
                dicRequestData["userId"] = dictagentContext["agentId"]
            }
            dicRequestData["printType"] =  "E"
            
            var arrReceiptsforRequest = [[String:Any]]()
            for receipt in arrReceipts{
                arrReceiptsforRequest.append(["policy": receipt["policyId"] as! String,"idReceipt": receipt["receiptId"] as! String,"prefixDoc": "RC","amount": receipt["amount"] as! Double,"idDocument": "","thirdParty": 0])
            }
            
            dicRequestData["receipts"] = arrReceiptsforRequest
            if (objClientRef["thirdParty"] as! Bool) == true {
                dicRequestData["thirdParty"] = 1
                
            }else{
                dicRequestData["thirdParty"] = 0
                
            }
            
            MainReqeustClass.BaseRequestSharedInstance.postRequestWithHeader(showLoader: true, url: basemock_Url + chipPinPaymentUrl, parameter: dicRequestData as [String : AnyObject], header: [String : String](), success: { (response) in
                print(response)
                
                var dicChippinRegisterRequest = [String:Any]()
                dicChippinRegisterRequest["appTx_id"] = response["merchantTransactionId"] as! String
                dicChippinRegisterRequest["statusControle"] = "2"
                MainReqeustClass.BaseRequestSharedInstance.postRequestWithHeader(showLoader: true, url: basemock_Url + registerChipPinUrl, parameter: dicChippinRegisterRequest as [String : AnyObject], header: [String : String](), success: { (response) in
                    print(response)
                    
                    let storyBoard = UIStoryboard(name: "PaymentMode", bundle: nil)
                    let controller = storyBoard.instantiateViewController(withIdentifier: "MposPinVC") as! MposPinVC
                    self.navigationController?.pushViewController(controller, animated: true)
                })
                { (responseError) in
                    print(responseError)
                    addErrorView(senderViewController: self, strErrorMessage: responseError)
                    //                CommonMethods().displayAlertView("Error", aStrMessage: responseError, aStrOtherTitle: "ok")
                }
            })
            { (responseError) in
                print(responseError)
                addErrorView(senderViewController: self, strErrorMessage: responseError)
                //                CommonMethods().displayAlertView("Error", aStrMessage: responseError, aStrOtherTitle: "ok")
            }
            
            break
        default:
            break
        }
        
    }
    
    @IBAction func goBackTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: User Actions
    @IBAction func openSidebar(_ sender: UIButton)
    {
        let storyBoard = UIStoryboard(name: "SideMenu", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        let transition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(controller, animated: true)
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
                cellPaymentMethodList.txtfdPhoneNumber.delegate = self
                
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
                                self.strPhonenumber = cellPaymentMethodList.txtfdPhoneNumber.text ?? ""
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

extension PaymentMethodListVC: UITextFieldDelegate{
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        strPhonenumber = textField.text ?? ""
        return true
    }
}
