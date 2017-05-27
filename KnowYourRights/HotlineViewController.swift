//
//  HotlineViewController.swift
//  KnowYourRights
//
//  Created by ZUWHAN KIM on 5/6/17.
//  Copyright © 2017 ZUWHAN KIM. All rights reserved.
//

import UIKit

class HotlineViewController: UIViewController {
    @IBOutlet weak var callNakasecButton: UIButton!
    @IBOutlet weak var callUwdButton: UIButton!

    @IBAction func callNakasecButtonClicked(_ sender: UIButton) {
        if let url = URL(string: "tel:1-844-500-3222") {
            UIApplication.shared.open(url)
        }
        
    }

    @IBAction func callUwdButtonClicked(_ sender: UIButton) {
        if let url = URL(string: "tel:1-844-363-1423") {
            UIApplication.shared.open(url)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
