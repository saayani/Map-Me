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
    //MARK: Outlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Delegate
    let textFieldDelegate = TextFieldDelegate()
    
    // MARK: geocoder
    let geocoder = CLGeocoder()
    
    // MARK: new Student info
    var student = Student()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set delegates
        locationTextField.delegate = textFieldDelegate
        linkTextField.delegate = textFieldDelegate
        
        // util for keyboard
        hideKeyboardWhenTappedAround()
        
        // add styles to button
        findButton.roundCorners()
    }
    
    @IBAction func findStudentLocation(_ sender: Any) {
        
        // guard if textfields are empty
        guard (!(locationTextField?.text?.isEmpty)! && !(linkTextField?.text?.isEmpty)!) else {
            showAlertMessage(message: "Please enter your Location and mediaURL!")
            return
        }
        
        // start loader
        self.activityIndicator.startAnimating()
        
        // guard for valid url
        guard let url = URL(string: linkTextField.text!), UIApplication.shared.canOpenURL(url) else {
            self.activityIndicator.stop()
            self.showAlertMessage(message: "Please enter a valid url")
            return
        }
        
        // check if the location can be coverted to coordinates
        //reference --> https://stackoverflow.com/questions/42279252/convert-address-to-coordinates-swift
        geocoder.geocodeAddressString(locationTextField.text!) {
            (placemarks, error) in
            
            // guard if location is valid
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                self.showAlertMessage(message: "Cannot Find Location! Please enter other location")
                return
            }
            
            // set coordinates
            self.student.latitude = location.coordinate.latitude
            self.student.longitude = location.coordinate.longitude
            
            self.activityIndicator.stop()
            
            // perform segue to finishAddLocation
            self.performSegue(withIdentifier: "getLocation", sender: self)
        }
    }
    
    // MARK: Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "getLocation") {
            if let viewController = segue.destination as? FinishAddLocationViewController {
                self.student.mapString = locationTextField.text!
                self.student.mediaUrl = linkTextField.text!
                self.student.uniqueKey = UdacityApiClient.shared.userId!
                viewController.student = self.student
            }
        }
    }
    
    // MARK: Dismiss add Student Modal
    @IBAction func closeModal() {
        self.dismiss(animated: true, completion: nil)
    }
}
