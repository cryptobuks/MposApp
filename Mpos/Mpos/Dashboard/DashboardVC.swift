//
//  DashboardVC.swift
//  Mpos
//
//  Created by Yash on 20/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController
{
    @IBOutlet weak var tblCategoryList: UITableView!
    var arrRows = NSMutableArray()
    @IBOutlet weak var lblAgentCode: UILabel!
    @IBOutlet weak var lblAgentName: UILabel!
    @IBOutlet weak var lblAgentID: UILabel!
    @IBOutlet weak var btnChageAgent: UIButton!
    var categoryColor = UIColor()
    var dictNotificationobject = [String:Any]()
    var arrListofAgents = NSMutableArray()
    var iCurrentInvoiceType:Int = 0
    var arrDashboardCategories = ["RISCO DE ANULAÇÃO","POR COBRAR","COBRADOS"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        
        UserDefaultManager.SharedInstance.saveString(str: dateString, strKeyName: UserDefaultKey.COBRADOSLastVisitTime.rawValue)

        
        //Call KPI api is called to fill up the three main buttons (KPIs) in the home screen
        self.tblCategoryList.estimatedRowHeight = 80
        self.tblCategoryList.rowHeight = UITableView.automaticDimension
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.4671765566, green: 0.8079167008, blue: 0.8608521223, alpha: 1)
        let yourBackImage = UIImage(named: "ic_back")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
//            self.getKPI()
            self.getListofAgents()
        })
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if let dictagentContext = UserDefaultManager.SharedInstance.getLoggedUser()
        {
            lblAgentName.text = "\(dictagentContext["name"] ?? "")"
            lblAgentID.text = "ASF: \(dictagentContext["asfNumber"] ?? "")"
            let myMutableString = NSMutableAttributedString(string: "Agente:\(dictagentContext["agentId"] ?? "")", attributes: [NSAttributedString.Key.font : lblAgentCode.font])
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 103.0/255.0, green: 196.0/255.0, blue: 211.0/255.0, alpha: 1.0), range: NSRange(location:7,length:"\(dictagentContext["agentId"] ?? "")".count))

            lblAgentCode.attributedText = myMutableString
        }
        
        if iCurrentInvoiceType == 3
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.getKPI(strTimeStamp: UserDefaultManager.SharedInstance.getString(strKeyName: UserDefaultKey.COBRADOSLastVisitTime.rawValue)!)
            })
        }
    }

    func getKPI(strTimeStamp:String)
    {
        arrRows = NSMutableArray()
        let loggedUser = UserDefaultManager.SharedInstance.getLoggedUser()
        let params = ["agentContext":loggedUser!,"timestamp": strTimeStamp] as [String : Any]
        
        MainReqeustClass.BaseRequestSharedInstance.postRequestWithHeader(showLoader: true, url: base_Url, parameter: params as [String : AnyObject], header: CommonMethods().createHeaderDic(strMethod: kpiUrl), success: { (response) in
            print(response)
            
            if let arrKPIList = response["kpiList"] as? NSArray
            {
                for index in 0..<arrKPIList.count
                {
                    self.arrRows.add(arrKPIList[index])
                }
                
                let searchPredicate = NSPredicate(format: "type contains [cd] %@", "Novos")
                let filteredArray = arrKPIList.filtered(using: searchPredicate)
                if filteredArray.count > 0
                {
                    self.dictNotificationobject = filteredArray[0] as! [String : Any]
                    self.arrRows.remove(self.dictNotificationobject)
                }
                
                UserDefaultManager.SharedInstance.saveArrayData(arr: self.arrRows, strKeyName: "SidebarData")
                self.tblCategoryList.reloadData()

            }
        })
        { (responseError) in
//            CommonMethods().displayAlertView("Error", aStrMessage: responseError, aStrOtherTitle: "ok")
            addErrorView(senderViewController: self, strErrorMessage: responseError)
//            UserDefaultManager.SharedInstance.saveArrayData(arr: self.arrRows, strKeyName: "SidebarData")
        }
        self.tblCategoryList.reloadData()
    }
    
    func getListofAgents()
    {
        MainReqeustClass.BaseRequestSharedInstance.getRequestWithHeader(showLoader: true, url: base_Url, parameter: nil, header: CommonMethods().createHeaderDic(strMethod: asfAgentsUrl), success: { (response) in
            print(response)
            
            if let dictAgentContext = response["agentContext"] as?  [String : Any]
            {
                UserDefaultManager.SharedInstance.saveLoggedUser(dict: dictAgentContext)
                
                self.lblAgentName.text = "\(dictAgentContext["name"] ?? "")"
                self.lblAgentID.text = "ASF: \(dictAgentContext["asfNumber"] ?? "")"
                let myMutableString = NSMutableAttributedString(string: "Agente:\(dictAgentContext["agentId"] ?? "")", attributes: [NSAttributedString.Key.font : self.lblAgentCode.font])
                myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 103.0/255.0, green: 196.0/255.0, blue: 211.0/255.0, alpha: 1.0), range: NSRange(location:7,length:"\(dictAgentContext["agentId"] ?? "")".count))
                
                self.lblAgentCode.attributedText = myMutableString
                
                //- Android and iOS: When the agent changes (/asfAgents), app should invoke KPI service once again, in order to refresh invoices numbers
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    self.getKPI(strTimeStamp: UserDefaultManager.SharedInstance.getString(strKeyName: UserDefaultKey.COBRADOSLastVisitTime.rawValue)!)
                })
            }
            
            if let agentList = response["agentList"] as? NSArray
            {
                self.arrListofAgents = NSMutableArray(array: agentList)
            }
            
            if let arrErrors = response["Errors"] as? NSArray
            {
                if let errorobject = arrErrors[0] as? [String:Any]
                {
                    addErrorView(senderViewController: self, strErrorMessage: errorobject["errorMessage"] as! String)
                }
            }
                
        })
        { (responseError) in
//            CommonMethods().displayAlertView("Error", aStrMessage: responseError, aStrOtherTitle: "ok")
            addErrorView(senderViewController: self, strErrorMessage: responseError)
        }
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
    
    @IBAction func openSearch(_ sender: UIButton)
    {
        let storyBoard = UIStoryboard(name: "Search", bundle: nil)
        let searchVC = storyBoard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @IBAction func btnChangeAgentDropDownAction(_ sender: UIButton)
    {
        var arrtemp = [Any]()
        for index in 0..<self.arrListofAgents.count
        {
            let dictTemp = self.arrListofAgents[index] as! [String:Any]
            arrtemp.append("\(dictTemp["agentId"] ?? "" ) - \(dictTemp["name"] ?? "")")
        }

        ActionSheetStringPicker.show(withTitle: "", rows: arrtemp , initialSelection: 0, doneBlock:
            {
                picker, value, index in
                
                let dictTemp = self.arrListofAgents[value] as! [String:Any]
                
                let myMutableString = NSMutableAttributedString(string: "Agente:\(dictTemp["agentId"] ?? "")", attributes: [NSAttributedString.Key.font : self.lblAgentCode.font])
                myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 103.0/255.0, green: 196.0/255.0, blue: 211.0/255.0, alpha: 1.0), range: NSRange(location:7,length:"\(dictTemp["agentId"] ?? "")".count))
                
                self.lblAgentCode.attributedText = myMutableString
                
                if let dictagentContext = UserDefaultManager.SharedInstance.getLoggedUser()
                {
                    let dictUserObject = NSMutableDictionary(dictionary: dictagentContext)
                    dictUserObject.setValue(dictTemp["agentId"], forKey: "agentId")
                    UserDefaultManager.SharedInstance.saveLoggedUser(dict: dictUserObject as! [String : Any])
                    
                    //- Android and iOS: When the agent changes (/asfAgents), app should invoke KPI service once again, in order to refresh invoices numbers
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        self.getKPI(strTimeStamp: UserDefaultManager.SharedInstance.getString(strKeyName: UserDefaultKey.COBRADOSLastVisitTime.rawValue)!)
                    })
                }
                return
        }, cancel: { ActionStringCancelBlock in return }, origin: self.btnChageAgent)
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
extension DashboardVC: UITableViewDataSource,UITableViewDelegate
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
        return arrDashboardCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryListTableViewCell", for: indexPath) as! CategoryListTableViewCell
        
        cell.imgBack.layer.masksToBounds = false
        cell.imgBack.layer.shadowOffset = CGSize(width: 3, height: 3)
        cell.imgBack.layer.shadowColor = UIColor.lightGray.cgColor
        cell.imgBack.layer.shadowOpacity = 0.8
        //        cell.imgBack.layer.shadowRadius = 8
        
        cell.selectionStyle  = .none
        cell.imgBadge.isHidden = true
        cell.lblBadgeCount.isHidden = true
        
        cell.lblCategoryName.text = (arrDashboardCategories[indexPath.row]).uppercased()
        
        switch indexPath.row
        {
        case 0:
            cell.imgCategoryColor.backgroundColor = AppColors.kOrangeColorWithAlpha
            cell.lblCount.textColor = AppColors.kOrangeColor
            let searchPredicate = NSPredicate(format: "type contains [cd] %@", "Anulacao")
            let filteredArray = arrRows.filtered(using: searchPredicate)
            if filteredArray.count > 0
            {
                let dicData = filteredArray[0] as! [String : Any]
                cell.lblCount.text =  "\(dicData["quantity"] ?? "")"
                print("\(dicData["amount"] ?? "")".toCurrencyFormat())
                cell.lblPrice.text = "\(dicData["amount"] ?? "")".toCurrencyFormat()
            }
            break
        case 1:
            cell.imgCategoryColor.backgroundColor = AppColors.kPurpulColorWithAlpha
            cell.lblCount.textColor = AppColors.kPurpulColor
            let searchPredicate = NSPredicate(format: "type contains [cd] %@", "Cobrar")
            let filteredArray = arrRows.filtered(using: searchPredicate)
            if filteredArray.count > 0
            {
                let dicData = filteredArray[0] as! [String : Any]
                cell.lblCount.text =  "\(dicData["quantity"] ?? "")"
                print("\(dicData["amount"] ?? "")".toCurrencyFormat())
                cell.lblPrice.text = "\(dicData["amount"] ?? "")".toCurrencyFormat()
            }
            break
        case 2:
            cell.imgCategoryColor.backgroundColor = AppColors.kGreenColorWithAlpha
            cell.lblCount.textColor = AppColors.kGreenColor
            let searchPredicate = NSPredicate(format: "type contains [cd] %@", "Cobrados")
            let filteredArray = arrRows.filtered(using: searchPredicate)
            if filteredArray.count > 0
            {
                let dicData = filteredArray[0] as! [String : Any]
                cell.lblCount.text =  "\(dicData["quantity"] ?? "")"
                print("\(dicData["amount"] ?? "")".toCurrencyFormat())
                cell.lblPrice.text = "\(dicData["amount"] ?? "")".toCurrencyFormat()
            }
            if(self.dictNotificationobject.count > 0)
            {
                //- Home screen: When the COBRADOS notification icon is equal to 0, app must hide the notification. (err1.png)
                if Int(truncating: self.dictNotificationobject["quantity"] as! NSNumber) > 0
                {
                    cell.imgBadge.isHidden = false
                    cell.lblBadgeCount.isHidden = false
                    cell.lblBadgeCount.text =  "\(self.dictNotificationobject["quantity"] ?? "")"
                }
            }
            break
        default:
            cell.imgCategoryColor.backgroundColor = AppColors.kOrangeColorWithAlpha
            cell.lblCount.textColor = AppColors.kOrangeColor
            break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "InvoiceList", bundle: nil)
        let invoiceListingVC = storyBoard.instantiateViewController(withIdentifier: "InvoiceListingVC") as! InvoiceListingVC
        
        /*
            Therefore, every time user enters COBRADOS section, the current timestamp must be stored in the app. Then, when the Home screen is invoked, kpi service is called with the stored timestamp.
         */
        if indexPath.row == 2
        {
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = Date()
            let dateString = dateFormatter.string(from: date)

            UserDefaultManager.SharedInstance.saveString(str: dateString, strKeyName: UserDefaultKey.COBRADOSLastVisitTime.rawValue)
        }
        
        switch indexPath.row {
        case 0:
            let searchPredicate = NSPredicate(format: "type contains [cd] %@", "Anulacao")
            let filteredArray = arrRows.filtered(using: searchPredicate)
            if filteredArray.count > 0
            {
                let dicData = filteredArray[0] as! [String : Any]
                invoiceListingVC.StrType = ((dicData["type"] as? String)!)
            }
            break
        case 1:
            let searchPredicate = NSPredicate(format: "type contains [cd] %@", "Cobrar")
            let filteredArray = arrRows.filtered(using: searchPredicate)
            if filteredArray.count > 0
            {
                let dicData = filteredArray[0] as! [String : Any]
                invoiceListingVC.StrType = ((dicData["type"] as? String)!)
            }
            break
        case 2:
            let searchPredicate = NSPredicate(format: "type contains [cd] %@", "Cobrados")
            let filteredArray = arrRows.filtered(using: searchPredicate)
            if filteredArray.count > 0
            {
                let dicData = filteredArray[0] as! [String : Any]
                invoiceListingVC.StrType = ((dicData["type"] as? String)!)
            }
            break
        default:
            break
        }
        
        invoiceListingVC.InvoiceType = indexPath.row + 1
        iCurrentInvoiceType = invoiceListingVC.InvoiceType
        self.navigationController?.pushViewController(invoiceListingVC, animated: true)
    }
  
}
