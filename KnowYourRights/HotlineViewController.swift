//
//  HotlineViewController.swift
//  KnowYourRights
//
//  Created by ZUWHAN KIM on 5/6/17.
//  Copyright © 2017 ZUWHAN KIM. All rights reserved.
//

import ContactsUI
import UIKit

class HotlineViewController: UIViewController, CNContactPickerDelegate {
    let maxNumCustomButtons = 5
    let minButtonWidth = CGFloat(300)
    let defaultButtonHeight = CGFloat(80)
    let addButtonHeight = CGFloat(50)
    let anyFrame = CGRect(x: 0, y: 0, width: 300, height: 100)

    let nakasecPhoneNumber = CNPhoneNumber(stringValue: "+1-844-500-3222")
    let uwdPhoneNumber = CNPhoneNumber(stringValue: "+1-844-363-1423")

    @IBOutlet weak var buttonView: UIView!
    var buttons: [UIButton] = []
    var phoneNumbers: [CNPhoneNumber] = []
    var addButton: UIButton = UIButton()

    var customContactNames: [String] = []
    var customPhoneNumbers: [String] = []

    func readUserDefaults() {
        customContactNames = []
        customPhoneNumbers = []
        if let savedContactNames : [String] = UserDefaults.standard.object(forKey: "contactNames") as! [String]? {
            customContactNames = savedContactNames
        }
        if let savedPhoneNumbers: [String] = UserDefaults.standard.object(forKey: "phoneNumbers") as! [String]? {
            customPhoneNumbers = savedPhoneNumbers
        }
        if customContactNames.count != customPhoneNumbers.count {
            // Better ignore user defaults than handle the corrupted data.
            customContactNames = []
            customPhoneNumbers = []
        }
    }

    func saveUserDefaults() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(customContactNames, forKey: "contactNames")
        userDefaults.set(customPhoneNumbers, forKey: "phoneNumbers")
        userDefaults.synchronize()
    }

    func callButtonClicked(_ sender: UIButton) {
        if let url = URL(string: "tel:" + (phoneNumbers[sender.tag].value(forKey: "digits") as! String)) {
            if UIApplication.shared.canOpenURL(url) { // TODO: change to CHECK()
                UIApplication.shared.openURL(url)
            }
        }
    }

    func deleteButtonClicked(_ sender: UIGestureRecognizer) {
        if sender.state == .began {
            let buttonIndex = (sender.view?.tag)!
            let configIndex = buttonIndex - 2
            let alert = UIAlertController(
                title: customContactNames[configIndex],
                message: NSLocalizedString("Remove confirmation", comment: ""),
                preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Remove", comment: ""),
                                          style: .destructive, handler: { (action) in
                self.buttons.remove(at: buttonIndex).removeFromSuperview()
                self.phoneNumbers.remove(at: buttonIndex)
                self.rearrangeButtons()
                self.customContactNames.remove(at: configIndex)
                self.customPhoneNumbers.remove(at: configIndex)
                self.saveUserDefaults()
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                          style: .cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func contactPicker(_ picker: CNContactPickerViewController,
                       didSelect contact: CNContact) {
        if contact.isKeyAvailable(CNContactPhoneNumbersKey) {
            let contactName = CNContactFormatter.string(from: contact, style: .fullName)
            // TODO: pop-up selector dialog in case there are multiple phone numbers.
            let phoneNumber = contact.phoneNumbers[0].value
            
            // Add buttons
            addPhoneButton(contactName: contactName!, phoneNumber: phoneNumber, deletable: true)
            rearrangeButtons()
            
            // Update & save user data.
            self.customContactNames.append(contactName!)
            self.customPhoneNumbers.append(phoneNumber.stringValue)
            saveUserDefaults()
        } else {
            // This shouldn't happen because we only show the contacts with phone numbers.
            print("Selected contact doesn't have a phone number.")
        }
    }

    func addButtonClicked(_ sender: UIButton) {
        let controller = CNContactPickerViewController()
        controller.delegate = self
        controller.predicateForEnablingContact = NSPredicate(
            format: "phoneNumbers.@count > 0", argumentArray: nil)
        self.present(controller, animated: true, completion: nil)
    }

    // Adds a phone number button.
    func addPhoneButton(contactName: String, phoneNumber: CNPhoneNumber, deletable: Bool) {
        let index = self.buttons.count
        let button = UIButton() //frame: self.anyFrame) // Frame will be re-adjusted by rearrangeButtons().
        button.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 118/255, alpha: 1) // Midnight Blue.
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.setTitle(contactName + "\n" + phoneNumber.stringValue, for: .normal)
        button.tag = index
        button.addTarget(self, action: #selector(callButtonClicked), for: .touchUpInside)
        if deletable {
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(deleteButtonClicked))
            button.addGestureRecognizer(longGesture)
        }
        self.buttons.append(button)
        self.phoneNumbers.append(phoneNumber)
        self.buttonView.addSubview(button);
    }

    // Initialize the 'add' button.
    func initializeAddButton() {
        self.addButton.backgroundColor = UIColor(red: 120/255, green: 120/255, blue: 180/255, alpha: 1)
        self.addButton.layer.cornerRadius = 20
        self.addButton.layer.borderWidth = 1
        self.addButton.setTitle("+", for: .normal)
        self.addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
    }

    func rearrangeButtons() {
        let frameWidth = self.buttonView.frame.width
        let frameHeight = self.buttonView.frame.height
        
        let buttonWidth = min(frameWidth - 60, minButtonWidth)
        let xMargin = (frameWidth - buttonWidth) / 2
        
        let numButtons = self.buttons.count
        let willShowAddButton = (numButtons < maxNumCustomButtons)
        var allButtonHeights = CGFloat(numButtons) * defaultButtonHeight
        var numMargins = numButtons + 1
        if willShowAddButton {
            allButtonHeights += addButtonHeight
            numMargins += 1
        }
        let yMargin = max(20, (frameHeight - allButtonHeights)/CGFloat(numMargins))
        
        var y = yMargin
        for i in 0..<numButtons {
            self.buttons[i].frame = CGRect(x: xMargin, y: y, width: buttonWidth, height: defaultButtonHeight)
            y += defaultButtonHeight + yMargin
        }
        if willShowAddButton {
            addButton.frame = CGRect(x: xMargin, y: y, width: buttonWidth, height: addButtonHeight)
            self.buttonView.addSubview(self.addButton);
        } else {
            self.buttonView.willRemoveSubview(self.addButton);
        }
    }

    override func viewDidLoad() {
        // 'Add' (+) button.
        initializeAddButton()
        
        // Default buttons (NAKASEC/UWD).
        addPhoneButton(
            contactName: NSLocalizedString("Call NAKASEC", comment: ""),
            phoneNumber: nakasecPhoneNumber, deletable: false)
        addPhoneButton(
            contactName: NSLocalizedString("Call UWD", comment: ""),
            phoneNumber: uwdPhoneNumber, deletable: false)
        
        // Custom phone number buttons.
        readUserDefaults()
        for i in 0..<customContactNames.count {
            addPhoneButton(
                contactName: customContactNames[i],
                phoneNumber: CNPhoneNumber(stringValue: customPhoneNumbers[i]),
                deletable: true)
        }
    }

    override func viewDidLayoutSubviews() {
        rearrangeButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
