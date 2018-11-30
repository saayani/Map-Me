//
//  StudentsInfo.swift
//  Map Me
//
//  Created by Sagar Choudhary on 29/11/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import Foundation

// MARK: Class to store list of students
class StudentsInfo {
    var studentsList = [Student]()
    static let shared = StudentsInfo()
}
