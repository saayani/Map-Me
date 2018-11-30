//
//  MapViewController.swift
//  Map Me
//
//  Created by Sagar Choudhary on 24/11/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Map Delegate
    let mapDelegate = MapDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        // set the delegate
        mapView.delegate = mapDelegate
    }
    
    // MARK: generate Markers
    func generatePins() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        var annotations = [MKPointAnnotation]()
        for student in StudentsInfo.shared.studentsList {
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = student.latitude
            annotation.coordinate.longitude = student.longitude
            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.subtitle = student.mediaUrl
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
    }
}
