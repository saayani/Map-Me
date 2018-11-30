//
//  MapDelegate.swift
//  Map Me
//
//  Created by Sagar Choudhary on 30/11/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import UIKit
import MapKit

//MARK: MapView Delegate
class MapDelegate: UIViewController, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // make reusable pinView
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKMarkerAnnotationView
        
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pinView?.animatesWhenAdded = true
            pinView?.titleVisibility = .hidden
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let url = view.annotation?.subtitle {
            openUrl(urlString: url!)
        }
    }
}
