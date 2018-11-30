//
//  TextFieldDelegate.swift
//  Map Me
//
//  Created by Sagar Choudhary on 26/11/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//
import UIKit

// MARK: TextField Delegate
class TextFieldDelegate : NSObject, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.isFirstResponder) {
            textField.resignFirstResponder()
        }
        return true
    }
}
