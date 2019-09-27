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
    var arrListofAgents = NSMutableArray()

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
        MainReqeustClass.BaseRequestSharedInstance.getRequestWithHeader(showLoader: true, url: base_Url, parameter: nil, header: CommonMethods().createHeaderDic(strMethod: asfAgentsUrl), success: { (response) in
            print(response)

            if let agentList = response["agentList"] as? NSArray
            {
                let arrListofAgents = NSMutableArray(array: agentList)
                
                var arrtemp = [Any]()
                for index in 0..<arrListofAgents.count
                {
                    let dictTemp = arrListofAgents[index] as! [String:Any]
                    arrtemp.append("\(dictTemp["agentId"] ?? "") - \(dictTemp["name"] ?? "")")
                }
                
                ActionSheetStringPicker.show(withTitle: "", rows: arrtemp , initialSelection: 0, doneBlock:
                    {
                        picker, value, index in
                        
                        let dictTemp = arrListofAgents[value] as! [String:Any]
                        self.lblAgentNumber.text = ("\(dictTemp["agentId"] ?? "")")
                        if let dictagentContext = UserDefaultManager.SharedInstance.getLoggedUser()
                        {
                            let dictUserObject = NSMutableDictionary(dictionary: dictagentContext)
                            dictUserObject.setValue(dictTemp["agentId"], forKey: "agentId")
                            UserDefaultManager.SharedInstance.saveLoggedUser(dict: dictUserObject as! [String : Any])
                        }
                        return
                }, cancel: { ActionStringCancelBlock in return }, origin: sender)
            }
        })
        { (responseError) in
            CommonMethods().displayAlertView("Error", aStrMessage: responseError, aStrOtherTitle: "ok")
//            addErrorView(senderViewController: self, strErrorMessage: responseError)
        }
    }
}
