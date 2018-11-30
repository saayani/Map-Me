//
//  extensions.swift
//  Map Me
//
//  Created by Sagar Choudhary on 27/11/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import UIKit

public extension UIViewController {
    // show alert message
    func showAlertMessage(message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error!", message: message, preferredStyle: UIAlertController.Style.alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(alertAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // Hide keyboard if tapped outside TextField
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action:    #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // open url in browser
    func openUrl(urlString : String) {
        if let url = URL(string: urlString) {
            if (UIApplication.shared.canOpenURL(url)) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                showAlertMessage(message: "Cannot Open URL: \(urlString)")
            }
        }
    }
    
    // show confirmation modal
    func showConfirmationAlert(message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Confirm", message: message, preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(cancelAction)
            let confirmAction = UIAlertAction(title: "Update Pin", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(confirmAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension UIView {
    
    func roundCorners(radius: CGFloat = 4) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
}
