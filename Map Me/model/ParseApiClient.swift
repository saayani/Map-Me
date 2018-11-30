//
//  ParseApiClient.swift
//  Map Me
//
//  Created by Sagar Choudhary on 29/11/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import Foundation
class ParseApiClient: APIClient {
    
    static let shared = ParseApiClient()
    
    override init() {
        super.init()
        self.host = Constants.Parse.APIHost
        self.scheme = Constants.Parse.APIScheme
        self.headers = generateHeader()
    }
    
    private func generateHeader() -> Dictionary<String, String> {
        return [Constants.ParseHeaderKeys.APIKey: Constants.ParseHeaderValues.APIKey,
                Constants.ParseHeaderKeys.ApplicationId: Constants.ParseHeaderValues.ApplicationId]
    }
    
    private func getParamList() -> Dictionary<String, AnyObject> {
        return [Constants.ParseParamKeys.Limit: Constants.ParseParamValues.Limit as AnyObject,
                Constants.ParseParamKeys.Order: Constants.ParseParamValues.Order as AnyObject]
    }
    
    private func getUniqueParam(uniqueKey: String) -> Dictionary<String, AnyObject> {
        return [Constants.ParseParamKeys.Where : "{\"uniqueKey\":\"\(uniqueKey)\"}" as AnyObject]
    }
    
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
    
    func getStudentInfo (uniqueKey: String, completionHandler: @escaping(_ pins: AnyObject?, _ error : String?) -> Void) {
        
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
}
