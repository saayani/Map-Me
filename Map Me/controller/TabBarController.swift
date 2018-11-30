//
//  TabBarController.swift
//  Map Me
//
//  Created by Sagar Choudhary on 28/11/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import UIKit

class TabBarController : UITabBarController {
    
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        activityIndicator.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.46)
        activityIndicator.center = view.center
        self.navigationController?.view.addSubview(activityIndicator)
        refreshStudentsInfo(nil)
    }
    
    override func viewWillLayoutSubviews() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.navigationController?.view.addConstraints(activityIndicatorConstraints())
    }
    
    @IBAction func logoutUser(_ sender: Any) {
        self.activityIndicator.startAnimating()
        
        UdacityApiClient.shared.deleteLoginSession {
            (success, error) in
            
            // guard if login was successful
            guard success == true else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                self.showAlertMessage(message: error!)
                return
            }
            
            // navigate to main screen
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                StudentsInfo.shared.studentsList = []
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func refreshStudentsInfo(_ sender: Any?) {
        
        self.activityIndicator.startAnimating()
        
        ParseApiClient.shared.getStudentsList() {
            (studentsList, error) in
             //guard if there is error
            guard error == nil else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                self.showAlertMessage(message: error!)
                return
            }
            
            var students = [Student]()
            for student in studentsList! {
                students.append(Student(studentDict: student as! [String : AnyObject]))
            }
            StudentsInfo.shared.studentsList = students
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                (self.viewControllers![0] as! MapViewController).generatePins()
                (self.viewControllers![1] as! TableViewController).reloadData()
            }
        }
        
//        UdacityApiClient.shared.getUsername() {
//            (username, error) in
//
//            // guard if there is error
//            guard error == nil else {
//                DispatchQueue.main.async {
//                    self.activityIndicator.stopAnimating()
//                }
//                self.showAlertMessage(title: "Error", message: error!)
//                return
//            }
//
//            //show userName
//            DispatchQueue.main.async {
//                self.activityIndicator.stopAnimating()
//            }
//            self.showAlertMessage(title: "Username Found", message: username!)
//        }
    }
    
    
    @IBAction func addStudentInfo(_ sender: Any) {
        self.activityIndicator.startAnimating()
        ParseApiClient.shared.getStudentInfo(uniqueKey: UdacityApiClient.shared.userId!) {
            (pins, error) in
            
            //guard if there is error
            guard error == nil else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                self.showAlertMessage(message: error!)
                return
            }
            
            if pins == nil {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.performSegue(withIdentifier: "addInfo", sender: self)
                }
            } else {
                self.showConfirmationAlert(message: "")
            }
            
        }
    }
    
    
    private func activityIndicatorConstraints() -> [NSLayoutConstraint] {
        let horizontalLeftConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .leading, relatedBy: .equal, toItem: self.navigationController?.view, attribute: .leading, multiplier: 1, constant: 0)
        let horizontalRightConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .trailing, relatedBy: .equal, toItem: self.navigationController?.view, attribute: .trailing, multiplier: 1, constant: 0)
        let centerXConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self.navigationController?.view, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self.navigationController?.view, attribute: .centerY, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .bottom, relatedBy: .equal, toItem: self.navigationController?.view, attribute: .bottom, multiplier: 1, constant: 0)
        
        return [horizontalLeftConstraint, horizontalRightConstraint, centerXConstraint, centerYConstraint, topConstraint, bottomConstraint]
    }
}
