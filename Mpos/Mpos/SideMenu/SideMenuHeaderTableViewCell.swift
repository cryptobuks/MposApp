//
//  SideMenuHeaderTableViewCell.swift
//  Mpos
//
//  Created by Kevin on 19/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class SideMenuHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var lblAgentTitle: UILabel!
    @IBOutlet weak var lblAgentName: UILabel!
    @IBOutlet weak var lblAgentNumber: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnChangeAgentDropDownAction(_ sender: UIButton)
    {
//        let arrtemp = ["256","257","258","259","260","261","262","263","264","265"]
//        ActionSheetStringPicker.show(withTitle: "", rows: arrtemp as [Any], initialSelection: 0, doneBlock:
//            {
//                picker, value, index in
//                self.lblAgentNumber.text = (index as? String ?? "")
//                return
//        }, cancel: { ActionStringCancelBlock in return }, origin: sender)

        let loggedUser = UserDefaultManager.SharedInstance.getLoggedUser()
        let params = ["agentContext":loggedUser]
        
        MainReqeustClass.BaseRequestSharedInstance.postRequestWithHeader(showLoader: true, url: base_Url, parameter: params as [String : AnyObject], header: CommonMethods().createHeaderDic(strMethod: asfAgentsUrl), success: { (response) in
            print(response)
            
            if let agentList = response["agentList"] as? NSArray
            {
                let arrListofAgents = NSMutableArray(array: agentList)
                
                var arrtemp = [Any]()
                for index in 0..<arrListofAgents.count
                {
                    let dictTemp = arrListofAgents[index] as! [String:Any]
                    arrtemp.append("\(dictTemp["id"] ?? "") - \(dictTemp["name"] ?? "")")
                }
                
                ActionSheetStringPicker.show(withTitle: "", rows: arrtemp , initialSelection: 0, doneBlock:
                    {
                        picker, value, index in
                        
                        let dictTemp = arrListofAgents[value] as! [String:Any]
                        self.lblAgentNumber.text = ("\(dictTemp["id"] ?? "")")
                        if let dictagentContext = UserDefaultManager.SharedInstance.getLoggedUser()
                        {
                            let dictUserObject = NSMutableDictionary(dictionary: dictagentContext)
                            dictUserObject.setValue(dictTemp["id"], forKey: "agentId")
                            UserDefaultManager.SharedInstance.saveLoggedUser(dict: dictUserObject as! [String : Any])
                        }
                        return
                }, cancel: { ActionStringCancelBlock in return }, origin: sender)
            }
        })
        { (responseError) in
            CommonMethods().displayAlertView("Error", aStrMessage: responseError, aStrOtherTitle: "ok")
        }
    }

}
