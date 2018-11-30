//
//  UdacityApiClient.swift
//  Map Me
//
//  Created by Sagar Choudhary on 28/11/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import Foundation

// MARK: UdacityApiClient
class UdacityApiClient : APIClient {
    
    // Logged in User/session Id
    var sessionId: String? = nil
    var userId: String? = nil
    
    // shared singleton Api Instance
    static let shared = UdacityApiClient()
    
    override init() {
        super.init()
        self.host = Constants.Udacity.APIHost
        self.scheme = Constants.Udacity.APIScheme
        self.headers = generateHeader()
    }
    
    // MARK: generate headers for request
    private func generateHeader() -> Dictionary<String, String> {
        return [Constants.UdacityHeaderKeys.Accept: Constants.UdacityHeaderValues.ContentTypeJSON,
                Constants.UdacityHeaderKeys.ContentType: Constants.UdacityHeaderValues.ContentTypeJSON]
    }
    
    // MARK: Login User
    func createLoginSession(email: String, password: String, completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        // request body
        let httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        // create request
        let request = createRequest(method: .POST, baseUrl: Constants.Udacity.APIBaseSessionURL, body: httpBody as AnyObject)
        
        // make the request
        makeRequest(request: request, requestType: .Udacity) {
            (result, error) in
            
            // guard if there was an error
            guard error == nil else {
                completionHandler(false, error)
                return
            }
            
            // check for the userId and session id
            guard let account = result![Constants.UdacityResponseKeys.Account] as? [String: AnyObject], let userId = account[Constants.UdacityResponseKeys.Key] as? String, let session = result![Constants.UdacityResponseKeys.Session] as? [String: AnyObject], let sessionId = session[Constants.UdacityResponseKeys.Id] as? String else {
                completionHandler(false, "Invalid Username and Password")
                return
            }
            
            // successfully logged in
            self.sessionId = sessionId
            self.userId = userId
            completionHandler(true, nil)
        }
    }
    
    // MARK: Logout User
    func deleteLoginSession (completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        // Create request
        let request = createRequest(method: .Delete,baseUrl: Constants.Udacity.APIBaseSessionURL)
        
        // make request
        makeRequest(request: request, requestType: .Udacity) {
            (result, error) in
            
            // guard if there was an error
            guard error == nil else {
                completionHandler(false, error)
                return
            }
            
            // check for the sessionId
            guard let session = result![Constants.UdacityResponseKeys.Session] as? [String: AnyObject], let sessionId = session[Constants.UdacityResponseKeys.Id] as? String else {
                completionHandler(false, "Unable to logout")
                return
            }
            
            // successfully logged out
            self.sessionId = sessionId
            self.userId = nil
            completionHandler(true, nil)
        }
    }
    
    // MARK: get Logged in user name
    func getUsername(completionHandler: @escaping (_ firstName: String?, _ lastName: String?, _ error : String?) -> Void) {
        // create request
        let request = createRequest(method: .GET, baseUrl: Constants.Udacity.APIBaseUserURL + "/\(self.userId!)")
        
        // make the request
        makeRequest(request: request, requestType: .Udacity) {
            (result, error) in
            
            // guard if there was an error
            guard error == nil else {
                completionHandler(nil, nil, error)
                return
            }
            
            // check for the User key
            guard let user = result![Constants.UdacityResponseKeys.User] as? [String: AnyObject], let nickName = user[Constants.UdacityResponseKeys.NickName] as? String else {
                completionHandler(nil, nil, "Cannot find User Info")
                return
            }
            
            // Yay! we got your name
            completionHandler(nickName, "", nil)
        }
    }
}
