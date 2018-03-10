//
//  MoreViewController.swift
//  KnowYourRights
//
//  Created by ZUWHAN KIM on 3/9/18.
//  Copyright © 2018 ZUWHAN KIM. All rights reserved.
//

import UIKit

class MoreViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let objectsToShare = ["", "http://nakasec.org/rights"]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            //activityVC.popoverPresentationController?.sourceView =
            self.present(activityVC, animated: true, completion: nil)
        case 1:
            guard let url = URL(string: "http://nakasec.org/rights") else {
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        default:
            assertionFailure(String(format: "Unknown row number %d", indexPath.row))
        }
    }
}
