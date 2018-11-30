//
//  ViewController.swift
//  Map Me
//
//  Created by Sagar Choudhary on 22/11/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var loginButton: UIButton!
    //MARK: Delegate
    let textFieldDelegate = TextFieldDelegate()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the delegate
        emailTextField.delegate = textFieldDelegate
        passwordTextField.delegate = textFieldDelegate
        
        // make sure the activity indicator is hidden
        activityIndicator.stopAnimating()
        
        // util for keyboard
        hideKeyboardWhenTappedAround()
        
        // add styles to button
        loginButton.roundCorners()
    }
    
    //MARK: Login User
    @IBAction func LoginUser(_ sender: Any) {
        // guard for empty textfields
        guard (!(emailTextField?.text?.isEmpty)! && !(passwordTextField?.text?.isEmpty)!) else {
            showAlertMessage(message: "Please enter Email and Password to login")
            return
        }
        
        // show activity indicator
        activityIndicator.startAnimating()
        
        // make the request to login user
        UdacityApiClient.shared.createLoginSession(email: emailTextField.text!, password: passwordTextField.text!) {
            (success, error) in
            
            // guard if login was successful
            guard success == true else {
                self.activityIndicator.stop()
                self.showAlertMessage(message: error!)
                return
            }
            
            // navigate to main screen
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "mainScreen", sender: self)
            }
        }
    }
    
    //MARK: Signup User
    @IBAction func signupUser(_ sender: Any) {
        openUrl(urlString: Constants.Udacity.SignupURL)
    }
}
