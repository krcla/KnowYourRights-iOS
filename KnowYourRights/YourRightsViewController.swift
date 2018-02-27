//
//  YourRightsViewController.swift
//  KnowYourRights
//
//  Created by ZUWHAN KIM on 5/6/17.
//  Copyright © 2017 ZUWHAN KIM. All rights reserved.
//

import UIKit

class YourRightsViewController: UIViewController, UIWebViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var languagePicker: UIPickerView!

    var locale: String = ""
    var pickerData: [String] = [String]()
    var localeData: [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        pickerData = ["English", "Español", "한국어", "Português", "中文"]
        localeData = ["en_US", "es_US", "ko_KR", "pt_PT", "zh_CN"]
        languagePicker.delegate = self
        languagePicker.dataSource = self

        languageButton.addTarget(self, action: #selector(languageButtonClicked), for: .touchUpInside)

        locale = (Locale.current as NSLocale).object(forKey: .languageCode) as! String
        loadInstructionView()
        webView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadInstructionView() {
        var htmlFile = "your_rights_en"
        if (locale.hasPrefix("es")) {
            htmlFile = "your_rights_es"
        } else if (locale.hasPrefix("ko")) {
            htmlFile = "your_rights_ko"
        } else if (locale.hasPrefix("pt")) {
            htmlFile = "your_rights_pt"
        } else if (locale.hasPrefix("zh")) {
            htmlFile = "your_rights_zh"
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

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        languagePicker.isHidden = true
        webView.isUserInteractionEnabled = true
        webView.alpha = 1.0
        languageButton.isEnabled = true
        locale = localeData[row]
        loadInstructionView()
    }
    
    @objc func languageButtonClicked(_ sender: UIButton) {
        languagePicker.isHidden = false
        self.view.addSubview(languagePicker)
        webView.isUserInteractionEnabled = false
        webView.alpha = 0.3
        languageButton.isEnabled = false
    }
}
