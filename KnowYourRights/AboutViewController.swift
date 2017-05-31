//
//  AboutViewController.swift
//  KnowYourRights
//
//  Created by ZUWHAN KIM on 5/30/17.
//  Copyright © 2017 ZUWHAN KIM. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let requestUrl = URL(fileURLWithPath: "http://nakasec.org/rights")
        let myRequest = URLRequest(url: requestUrl)
        webView.loadRequest(myRequest)
        self.view.addSubview(webView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
