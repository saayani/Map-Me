//
//  AddocationViewController.swift
//  Map Me
//
//  Created by Sagar Choudhary on 26/11/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    
    let textFieldDelegate = TextFieldDelegate()
    
    let geocoder = CLGeocoder()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = textFieldDelegate
        linkTextField.delegate = textFieldDelegate
        hideKeyboardWhenTappedAround()
        findButton.roundCorners()
    }
    
    @IBAction func findStudentLocation(_ sender: Any) {
        // guard if textfields are empty
        guard (!(locationTextField?.text?.isEmpty)! && !(linkTextField?.text?.isEmpty)!) else {
            showAlertMessage(message: "Please enter your Location and mediaURL!")
            return
        }
        
        // guard for valid url
        guard let url = URL(string: linkTextField.text!), UIApplication.shared.canOpenURL(url) else {
            showAlertMessage(message: "Please enter a valid url")
            return
        }
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "getLocation", sender: self)
        }
        
    }
    
    @IBAction func closeModal() {
        self.dismiss(animated: true, completion: nil)
    }
}
