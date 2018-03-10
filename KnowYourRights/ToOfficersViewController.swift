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
    @IBOutlet weak var speakButton: UIButton!

    let player = AVQueuePlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let filePath = Bundle.main.path(forResource: "to_officers", ofType: "html", inDirectory: "Resources.bundle")
        let requestUrl = URL(fileURLWithPath: filePath!)
        let myRequest = URLRequest(url: requestUrl)
        webView.loadRequest(myRequest)
        self.view.addSubview(webView)

        speakButton.addTarget(self, action: #selector(speakButtonClicked), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func speakButtonClicked(_ sender: UIButton) {
        if (player.rate != 0 && player.error == nil) {
            player.pause()
        } else {
            let filePath = Bundle.main.path(forResource: "to_officers", ofType: "m4a", inDirectory: "Resources.bundle")
            let url = URL(fileURLWithPath: filePath!)
            player.removeAllItems()
            player.insert(AVPlayerItem(url: url), after: nil)
            player.play()
        }
    }
}
