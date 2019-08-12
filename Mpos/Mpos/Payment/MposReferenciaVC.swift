//
//  MposReferenciaVC.swift
//  Mpos
//
//  Created by Yash on 21/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

//Class Purpose: Specifically, it is still worth noting that the information (i.e. other than the headings) in the “Mpos_referencia” screen is returned by WS013. Moreover, there is a blue button saying “PARTILHAR” in the bottom of this screen. Pressing it invokes the native “share” functionality of the device. All information on the text boxes of this screen should be forwarded to the chosen “sharing” application as text.

import UIKit

class MposReferenciaVC: UIViewController
{
    @IBOutlet weak var txtCode: SkyFloatingLabelTextField!
    @IBOutlet weak var txtReference: SkyFloatingLabelTextField!
    @IBOutlet weak var lblValue: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func shareTextButton(_ sender: UIButton)
    {
        // text to share
        let text = "ENTIDADE: \(txtCode.text ?? ""), REFERÊNCIA: \(txtReference.text ?? ""), VALOR TOTAL: \(lblValue.text ?? "")"
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        // present the view controller
        self.present(activityViewController, animated: true, completion: {
            
            let storyBoard = UIStoryboard(name: "PaymentMode", bundle: nil)
            let controller = storyBoard.instantiateViewController(withIdentifier: "PaymentSuccessVC") as! PaymentSuccessVC
            controller.strSucessMessage = "O envio foi efetuado com sucesso."
            self.navigationController?.pushViewController(controller, animated: true)
            
        })
    }
    @IBAction func closeTapped(_ sender: UIButton)
    {
//        self.navigationController?.popViewController(animated: true)
        let storyBoard = UIStoryboard(name: "PaymentMode", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "PaymentSuccessVC") as! PaymentSuccessVC
        controller.strSucessMessage = "O envio foi efetuado com sucesso."
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
