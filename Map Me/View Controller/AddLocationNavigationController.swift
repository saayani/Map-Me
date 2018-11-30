//
//  AddLocationNavigationController.swift
//  Map Me
//
//  Created by Sagar Choudhary on 30/11/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import UIKit

class AddLocationNavigationController: UINavigationController {
    
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        activityIndicator.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.46)
        activityIndicator.center = view.center
        self.navigationController?.view.addSubview(activityIndicator)
    }
    
    override func viewWillLayoutSubviews() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.navigationController?.view.addConstraints(activityIndicatorConstraints())
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
