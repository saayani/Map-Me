//
//  TabBarController.swift
//  Map Me
//
//  Created by Sagar Choudhary on 28/11/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import UIKit

class TabBarController : UITabBarController {
    
    // MARK: Activity Indicator
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    // MARK: to store logged in user Info
    var studentToAdd = Student()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set activity indicator properties
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        activityIndicator.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.46)
        activityIndicator.center = view.center
        self.navigationController?.view.addSubview(activityIndicator)
        
        // refresh students list
        refreshStudentsInfo(nil)
    }
    
    // MARK: Set constraints to view
    override func viewWillLayoutSubviews() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.navigationController?.view.addConstraints(activityIndicatorConstraints())
    }
    
    // MARK: Logout user
    @IBAction func logoutUser(_ sender: Any) {
        // start loader
        self.activityIndicator.startAnimating()
        
        // make the request to delete the session
        UdacityApiClient.shared.deleteLoginSession {
            (success, error) in
            
            // guard if logout was successful
            guard success == true else {
                self.activityIndicator.stop()
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
    
    // MARK: Refresh Students Info
    @IBAction func refreshStudentsInfo(_ sender: Any?) {
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        // get the list of students
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
            
            // yay! we got the list
            var students = [Student]()
            for student in studentsList! {
                students.append(Student(studentDict: student as! [String : AnyObject]))
            }
            // update global students list
            StudentsInfo.shared.studentsList = students
            
            // reload both tab views
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                (self.viewControllers![0] as! MapViewController).generatePins()
                (self.viewControllers![1] as! TableViewController).reloadData()
            }
        }
    }
    
    // MARK: Navigate to Add Student ViewController
    @IBAction func addStudentInfo(_ sender: Any) {
        self.activityIndicator.startAnimating()
        
        // get logged in user info
        ParseApiClient.shared.getStudentInfo(uniqueKey: UdacityApiClient.shared.userId!) {
            (pins, error) in
            
            //guard if there is error
            guard error == nil else {
                self.activityIndicator.stop()
                self.showAlertMessage(message: error!)
                return
            }
            
            // if no pin posted
            if pins == nil {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.performSegue(withIdentifier: "addInfo", sender: self)
                }
            } else {
                // pin already posted
                self.studentToAdd = Student(studentDict: pins![0] as! [String : AnyObject])
                self.activityIndicator.stop()
                
                // ask for confirmation
                self.showConfirmationAlert(message: "You already have a posted Pin at location \(self.studentToAdd.mapString)") {
                    (action) in
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "addInfo", sender: self)
                    }
                }
            }
        }
    }
    
    // MARK: Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addInfo") {
            if let viewController = segue.destination as? UINavigationController {
                if let rootViewController = viewController.topViewController as? AddLocationViewController {
                    rootViewController.student = self.studentToAdd
                }
            }
        }
    }
    
    // MARK: Activity Indicator Constraints
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
