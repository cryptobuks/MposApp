//
//  PaymentMethodListVC.swift
//  Mpos
//
//  Created by Yash on 21/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit
import CoreLocation

class PaymentMethodListVC: UIViewController
{
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSidebar: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblPaymentList: UITableView!
    @IBOutlet weak var btnContinue: UIButton!
    var txtStatus = String()

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
    var dicChipPin = [String:AnyObject]()
    var objChipPinView = MposPinVC()
    
    //ChipPin Variable
    var pp: PaymentProviderProtocol?
    let locationMgr = CLLocationManager()

    
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
        
        let status = CLLocationManager.authorizationStatus()
        switch status {
            // 1
        case .notDetermined:
                locationMgr.requestWhenInUseAuthorization()
                return
            // 2
        case .denied, .restricted:
            let alert = UIAlertController(title: "Location Services disabled", message: "Please enable Location Services in Settings to accept payments mPOS needs to access your location.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)

            present(alert, animated: true, completion: nil)
            return
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
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
                
                self.dicChipPin = response
                var dicChippinRegisterRequest = [String:Any]()
                dicChippinRegisterRequest["appTx_id"] = response["merchantTransactionId"] as! String
                dicChippinRegisterRequest["statusControle"] = "2"
                MainReqeustClass.BaseRequestSharedInstance.postRequestWithHeader(showLoader: true, url: basemock_Url + registerChipPinUrl, parameter: dicChippinRegisterRequest as [String : AnyObject], header: [String : String](), success: { (response) in
                    print(response)
                    
                    //Call SDK Process
                    let storyBoard = UIStoryboard(name: "PaymentMode", bundle: nil)
                    self.objChipPinView = storyBoard.instantiateViewController(withIdentifier: "MposPinVC") as! MposPinVC
                    self.objChipPinView.bViewAdded = true
                    self.view.addSubview(self.objChipPinView.view)
                    MainReqeustClass.ShowActivityIndicatorInStatusBar(shouldShowHUD: true)
                    self.processPurchase()
                    /*
                    let storyBoard = UIStoryboard(name: "PaymentMode", bundle: nil)
                    let controller = storyBoard.instantiateViewController(withIdentifier: "MposPinVC") as! MposPinVC
                    self.navigationController?.pushViewController(controller, animated: true)*/
                })
                { (responseError) in
                    print(responseError)
                    addErrorView(senderViewController: self, strErrorMessage: responseError)
                }
            })
            { (responseError) in
                print(responseError)
                addErrorView(senderViewController: self, strErrorMessage: responseError)
            }
            
            break
        default:
            break
        }
        
    }
    
    //MARK: Process Chip Pin SDK Methods
    func processPurchase()
    {
        pp = MPos.createProviderMock()
        let paymentInfo = PaymentInfo.buildCardPurchaseInfo("ID GENERATED ON YOUR SYSTEM", amount: objSelectedCompany["amount"] as! Double, description: "Card Purchase")
        pp!.processAsync(self, info: paymentInfo)
    }
    
    func setCredentials()
    {
        let credentials = PaymentCredentials.create(withMerchantId: Int32(self.dicChipPin["merchantId"] as! String)!, terminalId: Int32(self.dicChipPin["terminalId"] as! String)!, merchantAuthId: self.dicChipPin["merchantAuthId"] as! String, merchantAuthKey: self.dicChipPin["merchantAuthKey"] as! String)
        
        pp?.setCredentials(credentials)
        addStatus("Credentials SET")
        processPurchase()
    }
    
    func chooseDevice(fromList deviceNames: [String], onCompletion completion: @escaping (Int) -> Void)
    {
        let defaultDevice = MPos.getDefaultDevice()
        if(defaultDevice != nil)
        {
            for i in 0..<deviceNames.count
            {
                let name = deviceNames[i]
                if(name == defaultDevice!.getName())
                {
                    DispatchQueue.global(qos: .background).async {
                        // Background Thread
                            completion(i)
                        DispatchQueue.main.async {
                            // Run UI Updates
                        }
                    }
                    return
                }
            }
        }
    }
    
    func addStatus(_ text: String?) {
        let newText = txtStatus + ("\(text ?? "")\n")
        txtStatus = newText
        print(txtStatus)
    }

    
    //MARK: Go back action
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

extension PaymentMethodListVC:PaymentListener
{
    func onComplete(_ result: PaymentResult)
    {
        switch result.status {
        case PAYMENT_STATUS.SUCCESS:
             self.addStatus("Payment successful")
             self.addStatus("SDK ID: \(result.financial.recipientTx.id ?? "")")
             self.addStatus("External ID: \(result.financial.tx.id ?? "")")

             var dicChippinRegisterRequest = [String:Any]()
             dicChippinRegisterRequest["appTx_id"] = self.dicChipPin["merchantTransactionId"] as! String
             dicChippinRegisterRequest["appTx_dateTime"] = result.appTx.dateTime
             dicChippinRegisterRequest["appTx_details_amount"] = objSelectedCompany["amount"] as! Double
             dicChippinRegisterRequest["appTx_details_description"] = "Card Purchase"
             dicChippinRegisterRequest["error"] = result.error
             dicChippinRegisterRequest["errorCode"] = result.errorCode
             dicChippinRegisterRequest["financial_entryMode"] = "CARD_CHIP_CONTACT"
             dicChippinRegisterRequest["financial_handwrittenSignatureRequired"] = false
             dicChippinRegisterRequest["financial_receiptData_acquirerText"] = ""
             if let receiptData = result.financial.receiptData
             {
                dicChippinRegisterRequest["financial_receiptData_authId"] = receiptData.authId
                dicChippinRegisterRequest["financial_receiptData_cardData_appId"] = receiptData.cardData!.appId
                dicChippinRegisterRequest["financial_receiptData_cardData_appLabel"] = receiptData.cardData!.appLabel
                dicChippinRegisterRequest["financial_receiptData_cardData_cardholderName"] = receiptData.cardData!.cardholderName
                dicChippinRegisterRequest["financial_receiptData_cardData_maskedPAN"] = receiptData.cardData!.maskedPAN
                dicChippinRegisterRequest["financial_receiptData_clientFee"] = receiptData.clientFee
                dicChippinRegisterRequest["financial_receiptData_clientFeeCurrency"] = receiptData.clientFeeCurrency
                dicChippinRegisterRequest["financial_receiptData_discountFee"] = receiptData.discountFee
                dicChippinRegisterRequest["financial_receiptData_financialProductDescLong"] = receiptData.financialProductDescLong
                dicChippinRegisterRequest["financial_receiptData_financialProductDescMedium"] = receiptData.financialProductDescMedium
                dicChippinRegisterRequest["financial_receiptData_financialProductDescShort"] = receiptData.financialProductDescShort
                dicChippinRegisterRequest["financial_receiptData_issuerName"] = receiptData.issuerName
             }
             else
             {
                dicChippinRegisterRequest["financial_receiptData_authId"] = nil
                dicChippinRegisterRequest["financial_receiptData_cardData_appId"] = nil
                dicChippinRegisterRequest["financial_receiptData_cardData_appLabel"] = nil
                dicChippinRegisterRequest["financial_receiptData_cardData_cardholderName"] = nil
                dicChippinRegisterRequest["financial_receiptData_cardData_maskedPAN"] = nil
                dicChippinRegisterRequest["financial_receiptData_clientFee"] = nil
                dicChippinRegisterRequest["financial_receiptData_clientFeeCurrency"] = nil
                dicChippinRegisterRequest["financial_receiptData_discountFee"] = nil
                dicChippinRegisterRequest["financial_receiptData_financialProductDescLong"] = nil
                dicChippinRegisterRequest["financial_receiptData_financialProductDescMedium"] = nil
                dicChippinRegisterRequest["financial_receiptData_financialProductDescShort"] = nil
                dicChippinRegisterRequest["financial_receiptData_issuerName"] = nil
             }
             dicChippinRegisterRequest["recipientTx_dateTime"] = result.financial.recipientTx.dateTime!
             dicChippinRegisterRequest["recipientTx_details"] = "Card Purchase"
             dicChippinRegisterRequest["recipientTx_id"] = result.financial.recipientTx.id!
             dicChippinRegisterRequest["tx_dateTime"] = result.financial.tx.dateTime!
             dicChippinRegisterRequest["tx_details"] = "Card Purchase"
             dicChippinRegisterRequest["tx_id"] = result.financial.tx.id!
             if let reconciliation = result.reconciliation
             {
                dicChippinRegisterRequest["reconciliation"] = reconciliation.recipientId
                dicChippinRegisterRequest["reconciliationId"] = reconciliation.id
             }
             else
             {
                dicChippinRegisterRequest["reconciliation"] = nil
                dicChippinRegisterRequest["reconciliationId"] = 0
             }
             dicChippinRegisterRequest["status"] = "Success"
             dicChippinRegisterRequest["type"] = "PT_AUTHORISATION_WITH_CAPTURE"
             dicChippinRegisterRequest["statusControle"] = "3"
             MainReqeustClass.BaseRequestSharedInstance.postRequestWithHeader(showLoader: true, url: basemock_Url + registerChipPinUrl, parameter: dicChippinRegisterRequest as [String : AnyObject], header: [String : String](), success: { (response) in
                 print(response)
                self.objChipPinView.view.removeFromSuperview()
                 MainReqeustClass.HideActivityIndicatorInStatusBar()
                 let storyBoard = UIStoryboard(name: "PaymentMode", bundle: nil)
                 let controller = storyBoard.instantiateViewController(withIdentifier: "PaymentSuccessVC") as! PaymentSuccessVC
                 controller.strSucessMessage = "O envio foi efetuado com sucesso."
                 self.navigationController?.pushViewController(controller, animated: true)
             })
             { (responseError) in
                 print(responseError)
                self.objChipPinView.view.removeFromSuperview()
                 addErrorView(senderViewController: self, strErrorMessage: responseError)
                MainReqeustClass.HideActivityIndicatorInStatusBar()
             }
            break
        case PAYMENT_STATUS.MISSINGCREDENTIALS:
             self.addStatus("Missing credentials")
             self.setCredentials()
            break
        case PAYMENT_STATUS.DECLINED:
            self.addStatus("Payment declined: \(result.errorCode ?? "")")
            break
        case PAYMENT_STATUS.CONFIGURATIONERROR:
             self.addStatus("Configuration error")
            break
        case PAYMENT_STATUS.INTERFACEERROR:
             self.addStatus("Interface error")
            break
        case PAYMENT_STATUS.UNKNOWNDEVICE:
             self.addStatus("Unknown device")
            break
        case PAYMENT_STATUS.DEVICEERROR:
            self.addStatus("Device error")
            break
        case PAYMENT_STATUS.COMMERROR:
            self.addStatus("Communication error")
            break
        case PAYMENT_STATUS.USERCANCELLED:
            self.addStatus("User canceled")
            break
        case PAYMENT_STATUS.USERTIMEOUT:
            self.addStatus("User timeout")
            break
        case PAYMENT_STATUS.PEDUPDATING:
            self.addStatus("PED UPDATING")
            break
        case PAYMENT_STATUS.NO_GPS_LOCATION:
            self.addStatus("User must enable GPS location")
            break
        default:
            break
        }
        // onComplete destroy the Payment Provider
//        pp = nil
    }
    
    func onStartDeviceConnectionStateChanged(_ event: CONNECTION_STATUS) {
        switch (event) {
        case .CONNECTED:
            self.addStatus("PED connected")
            break;
            
        case .CONNECTING:
            self.addStatus("PED connecting")
            break;
            
        case .NOTCONNECTED:
            self.addStatus("PED disconnected")
            break;
        }
    }
    
    func onDeviceDetectionError(_ event: DEVICE_DISCOVERY_STATUS) {
        
        switch (event) {
        case .BLUETOOTHNOTAVAILABLE:
            self.addStatus("Not Available")
            break
            
        case .BLUETOOTHNOTENABLE:
            self.addStatus("Not enabled")
            break
            
        case .NODEVICEDETECTED:
            self.addStatus("No device detected")
            break

        case .INVALIDDEVICEINDEX:
            self.addStatus("Invalid device index")
            break
        }
    }
    
    func onBatteryStatusChange(_ batteryStatus: BatteryEvent) {
        
        switch (batteryStatus.state) {
        case .ON_BATTERY:
            self.addStatus("BATTERY STATUS: On batttery")
            break
            
        case .CHARGING:
            self.addStatus("BATTERY STATUS: Charging")
            break
            
        case .CHARGED:
            self.addStatus("BATTERY STATUS: Charged")
            break
            
        case .BATTERY_LOW:
            self.addStatus("BATTERY STATUS: Battery low")
            break
        }
        self.addStatus("BATTERY PERCENTAGE: \(batteryStatus.level))")
    }
    
    func onDeviceStatusChange(_ event: DeviceEvent) {
        self.addStatus("DEVICE STATUS: \(event.status))")
    }
    
    func onCardStatusChange(_ event: CardEvent)
    {
        if(event.chip)
        {
           self.addStatus("Pagamento com chip")
        }

        if(event.magStripe)
        {
            self.addStatus("Pagamento com pista")
        }
    }
    
    func onKeyStatusChange(_ event: KeyEvent) {
        self.addStatus(String(format:"KEY STATUS KEY: %i", event.key))
    }
    
    func onInfo(_ event: InfoEvent)
    {
        switch (event.type)
        {
        case .WAIT_CARD_INSERTED:
            self.addStatus("Client should insert card")
            break
            
        case .WAIT_ACTIVATE_CONTACTLESS:
            self.addStatus("Contactless payment")
            break
            
        case .WAIT_CARD_REMOVED:
            self.addStatus("Client should remove card")
            break
            
        case .PED_UPDATING:
            self.addStatus("PED updating")
            break
        }
    }
    
    func onAuthorisationProcessing() {
        self.addStatus("Processing payment")
    }
}
