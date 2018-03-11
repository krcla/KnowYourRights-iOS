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

    // TODO: change local handling to a separate class so that the related vars cannot be
    // altered outside these three methods.

    // Reads the user default or use the system locale.
    func setLocale() {
        if let savedLocale : String = UserDefaults.standard.object(forKey: "locale") as! String? {
            locale = savedLocale
        } else {
            locale = (Locale.current as NSLocale).object(forKey: .languageCode) as! String
        }
    }

    func changeLocale(_ toLocale: String!) {
        locale = toLocale
        UserDefaults.standard.set(locale, forKey: "locale")
    }

    // Returns the picker data (= button title) for the locale.
    func getPickerDataForLocale() -> String {
        for i in 0..<localeData.count {
            if (locale.hasPrefix(localeData[i])) { return pickerData[i] }
        }
        return "" // This shouldn't happen.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerData = ["English", "Español", "한국어", "Português", "中文", "Kreyòl Ayisyen"]
        localeData = ["en", "es", "ko", "pt", "zh", "ht"]
        languagePicker.delegate = self
        languagePicker.dataSource = self

        languageButton.addTarget(self, action: #selector(languageButtonClicked), for: .touchUpInside)

        setLocale()
        languageButton.setTitle(getPickerDataForLocale(), for: .normal)
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
        } else if (locale.hasPrefix("ht")) {
            htmlFile = "your_rights_ht"
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
        languageButton.setTitle(pickerData[row], for: .normal)
        languageButton.isEnabled = true
        changeLocale(localeData[row])
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
