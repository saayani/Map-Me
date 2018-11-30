//
//  FinishAddLocationViewController.swift
//  Map Me
//
//  Created by Sagar Choudhary on 30/11/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FinishAddLocationViewController: UIViewController {
    
    // MARK: Student Info
    var student = Student()
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add styles to button
        finishButton.roundCorners()
        
        // set map region to student coordinates
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: student.latitude, longitude: student.longitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
        
        // Annotation for student marker
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = student.latitude
        annotation.coordinate.longitude = student.longitude
        
        // add the marker for student location
        self.mapView.addAnnotation(annotation)
    }
    
    // MARK: Add/Update Student
    @IBAction func addStudent(_ sender: Any) {
        // start loader
        self.activityIndicator.startAnimating()
        
        // get the name of the user
        UdacityApiClient.shared.getUsername() {
            (firstName, lastName, error) in
            
            // guard if there is error
            guard error == nil else {
                self.activityIndicator.stop()
                self.showAlertMessage(message: error!)
                return
            }
            
            // set student name
            self.student.firstName = firstName!
            self.student.lastName = lastName!
            
            // new Student
            if (self.student.objectId == "") {
                ParseApiClient.shared.addStudent(student: self.student, requestType: .POST, completionHandler: self.handleResult)
            } else {
                // update the student
                ParseApiClient.shared.addStudent(student: self.student, requestType: .PUT, completionHandler: self.handleResult)
            }
            
        }
    }
    
    // MARK: Result Handler after add/update of Student Info
    private func handleResult(success: Bool, error: String?) {
        //guard if there is error
        guard error == nil else {
            self.activityIndicator.stop()
            self.showAlertMessage(message: "Unable to add/update Student")
            return
        }
        
        // successfully added user, refresh tabBar controller Views
        let navigationController = self.presentingViewController as! UINavigationController
        let mainController = navigationController.viewControllers.first as! TabBarController
        mainController.refreshStudentsInfo(nil)
        self.activityIndicator.stop()
        
        // navigate to tabBar controller
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
