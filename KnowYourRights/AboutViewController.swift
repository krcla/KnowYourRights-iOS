//
//  AboutViewController.swift
//  KnowYourRights
//
//  Created by ZUWHAN KIM on 5/30/17.
//  Copyright © 2017 ZUWHAN KIM. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let filePath = Bundle.main.path(forResource: "about", ofType: "html", inDirectory: "Resources.bundle")
        let requestUrl = URL(fileURLWithPath: filePath!)
        let myRequest = URLRequest(url: requestUrl)
        webView.loadRequest(myRequest)
        webView.delegate = self
        self.view.addSubview(webView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch navigationType {
        case .linkClicked:
            // Open links in Safari.
            guard let url = request.url else { return true }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // openURL(_:) is deprecated in iOS 10+.
                UIApplication.shared.openURL(url)
            }
            return false
        default:
            // Handle other navigation types.
            return true
        }
    }
}
