//
//  Student.swift
//  Map Me
//
//  Created by Sagar Choudhary on 29/11/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import Foundation

// MARK: Student Struct
struct Student {
    var firstName = ""
    var lastName = ""
    var latitude = Double()
    var longitude = Double()
    var mapString = ""
    var mediaUrl = ""
    var uniqueKey = ""
    var objectId = ""
    
    init() {
        return
    }
    
    // Initializer
    init(studentDict: [String: AnyObject]) {
        firstName = studentDict[Constants.StudentInfo.FirstName] as? String ?? ""
        lastName = studentDict[Constants.StudentInfo.LastName] as? String ?? ""
        latitude = studentDict[Constants.StudentInfo.Latitude] as! Double
        longitude = studentDict[Constants.StudentInfo.Longitude] as! Double
        mapString = studentDict[Constants.StudentInfo.MapString] as! String
        mediaUrl = studentDict[Constants.StudentInfo.MediaUrl] as? String ?? ""
        uniqueKey = studentDict[Constants.StudentInfo.UniqueKey] as! String
        objectId = studentDict[Constants.StudentInfo.ObjectId] as! String
    }
}
