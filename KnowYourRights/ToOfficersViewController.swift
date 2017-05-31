//
//  ToOfficersViewController.swift
//  KnowYourRights
//
//  Created by ZUWHAN KIM on 5/6/17.
//  Copyright © 2017 ZUWHAN KIM. All rights reserved.
//

import AVFoundation
import UIKit

class ToOfficersViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    let player = AVQueuePlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let filePath = Bundle.main.path(forResource: "to_officers", ofType: "html", inDirectory: "Resources.bundle")
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
            guard let url = request.url else { return true }
            if (url.lastPathComponent == "to_officers.html") {
                let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
                let speak = (queryItems?.first(where: { $0.name == "speak" })?.value)!
                if (speak == "true") {
                    let filePath = Bundle.main.path(forResource: "to_officers", ofType: "m4a", inDirectory: "Resources.bundle")
                    let url = URL(fileURLWithPath: filePath!)
                    player.removeAllItems()
                    player.insert(AVPlayerItem(url: url), after: nil)
                    player.play()
                    return false
                }
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
