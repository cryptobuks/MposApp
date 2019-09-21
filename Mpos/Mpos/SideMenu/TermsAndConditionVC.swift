//
//  TermsAndConditionVC.swift
//  Mpos
//
//  Created by kaushal panchal on 21/09/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit
import WebKit
class TermsAndConditionVC: UIViewController,WKNavigationDelegate {
    @IBOutlet weak var webview: WKWebView!
    var strUrl = String()
    @IBOutlet weak var Activity: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = URL(string: strUrl)!
        webview.load(URLRequest(url: url))
        webview.navigationDelegate = self

        self.Activity.startAnimating()
        self.Activity.hidesWhenStopped = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Activity.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Activity.stopAnimating()
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
