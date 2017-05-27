//
//  YourRightsViewController.swift
//  KnowYourRights
//
//  Created by ZUWHAN KIM on 5/6/17.
//  Copyright © 2017 ZUWHAN KIM. All rights reserved.
//

import UIKit

class YourRightsViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var languageView: UIWebView!
    @IBOutlet weak var webView: UIWebView!
    var locale: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadView(view: languageView, htmlFile: "your_rights_languages")
        languageView.delegate = self

        loadInstructionView()
        webView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadInstructionView() {
        var htmlFile = "your_rights_en"
        switch locale {
        case "es_US":
            htmlFile = "your_rights_es"
            break
        case "ko_KR":
            htmlFile = "your_rights_ko"
            break
        case "pt_PT":
            htmlFile = "your_rights_pt"
            break
        case "zh_CN":
            htmlFile = "your_rights_zh"
            break
        default:
            break
        }
        loadView(view: webView, htmlFile: htmlFile)
    }

    func loadView(view: UIWebView!, htmlFile: String!) {
        let filePath = Bundle.main.path(forResource: htmlFile, ofType: "html", inDirectory: "Resources.bundle")
        let requestUrl = URL(fileURLWithPath: filePath!)
        let myRequest = URLRequest(url: requestUrl)
        view.loadRequest(myRequest)
        self.view.addSubview(view)
    }

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch navigationType {
        case .linkClicked:
            guard let url = request.url else { return true }
            if (url.lastPathComponent == "your_rights_languages.html") {
                let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
                locale = (queryItems?.first(where: { $0.name == "locale" })?.value)!
                loadInstructionView()
                return false
            }
            
            // Open links in Safari.
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
