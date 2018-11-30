//
//  ParseApiClient.swift
//  Map Me
//
//  Created by Sagar Choudhary on 29/11/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import Foundation

// MARK: PArseApiClient
class ParseApiClient: APIClient {
    
    // shared singleton Api Instance
    static let shared = ParseApiClient()
    
    override init() {
        super.init()
        self.host = Constants.Parse.APIHost
        self.scheme = Constants.Parse.APIScheme
        self.headers = generateHeader()
    }
    
    // MARK: generate headers for request
    private func generateHeader() -> Dictionary<String, String> {
        return [Constants.ParseHeaderKeys.APIKey: Constants.ParseHeaderValues.APIKey,
                Constants.ParseHeaderKeys.ApplicationId: Constants.ParseHeaderValues.ApplicationId]
    }
    
    // MARK: generate parameters for request
    private func getParamList() -> Dictionary<String, AnyObject> {
        return [Constants.ParseParamKeys.Limit: Constants.ParseParamValues.Limit as AnyObject,
                Constants.ParseParamKeys.Order: Constants.ParseParamValues.Order as AnyObject]
    }
    
    // MARK: generate parameter for single student info
    private func getUniqueParam(uniqueKey: String) -> Dictionary<String, AnyObject> {
        return [Constants.ParseParamKeys.Where : "{\"uniqueKey\":\"\(uniqueKey)\"}" as AnyObject]
    }
    
    // MARK: Get students List
    func getStudentsList(completionHandler: @escaping(_ studentsList: NSArray?, _ error: String?) -> Void) {
        // Create request
        let request = createRequest(parameters: getParamList(), method: .GET, baseUrl: Constants.Parse.APIBaseURL)
        
        // make the request
        makeRequest(request: request, requestType: .Parse) {
            (result, error) in
            // guard if there was an error
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            // guard for the result object
            guard let studentsList = result![Constants.StudentInfo.Results] as? NSArray else {
                completionHandler(nil, "Oops! Cannot get Students List")
                return
            }
            
            // yay! we got the students List
            completionHandler(studentsList, nil)
        }
    }
    
    // MARK: Get student Info
    func getStudentInfo (uniqueKey: String, completionHandler: @escaping(_ pins: NSArray?, _ error : String?) -> Void) {
        
        // create request
        let request = createRequest(parameters: getUniqueParam(uniqueKey: uniqueKey), method: .GET, baseUrl: Constants.Parse.APIBaseURL)
        
        // make Request
        makeRequest(request: request, requestType: .Parse) {
            (result, error) in
            // guard if there was an error
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            // guard for the result object
            guard let studentPinList = result![Constants.StudentInfo.Results] as? NSArray else {
                completionHandler(nil, "Oops! Cannot get Students List")
                return
            }
            
            // guard for empty array of pins
            guard studentPinList.count > 0 else {
                completionHandler(nil, nil)
                return
            }
            // yay! we got the student pins
            completionHandler(studentPinList, nil)
        }
    }
    
    // MARK: Add/Update Student Info
    func addStudent(student: Student, requestType: apiMethod, completionHandler: @escaping(_ success: Bool, _ error: String?)-> Void) {
        
        // request body
        let httpBody =  "{\"uniqueKey\": \"\(student.uniqueKey)\", \"firstName\": \"\(student.firstName)\", \"lastName\": \"\(student.lastName)\",\"mapString\": \"\(student.mapString)\", \"mediaURL\": \"\(student.mediaUrl)\",\"latitude\": \(student.latitude), \"longitude\": \(student.longitude)}".data(using: .utf8)
        
        // create Base Url for add/update
        var baseUrl = ""
        
        if requestType == .POST {
            baseUrl = Constants.Parse.APIBaseURL
        } else {
            baseUrl = Constants.Parse.APIBaseURL + "/\(student.objectId)"
        }
        
        // create request
        var request = createRequest(method: requestType, baseUrl: baseUrl, body: httpBody as AnyObject)
        
        // add aditional header
        request.addValue(Constants.ParseHeaderValues.ContentTypeJSON, forHTTPHeaderField: Constants.ParseHeaderKeys.ContentType)
        
        // make the request
        makeRequest(request: request, requestType: .Parse) {
            (result, error) in
            
            // guard if there was an error
            guard error == nil else {
                completionHandler(false, error)
                return
            }
            
            // student info added
            completionHandler(true, nil)
        }
    }
}
