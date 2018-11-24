//
//  ViewController.swift
//  Map Me
//
//  Created by Sagar Choudhary on 22/11/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
}

// Hide keyboard if tapped outside TextField
extension LoginViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: TextField delegate methods
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.isFirstResponder) {
            textField.resignFirstResponder()
        }
        return true
    }
}
