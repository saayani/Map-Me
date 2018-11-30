//
//  UdacityApiClient.swift
//  Map Me
//
//  Created by Sagar Choudhary on 28/11/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import Foundation

class UdacityApiClient : APIClient {
    
    var sessionId: String? = nil
    var userId: String? = nil
    
    static let shared = UdacityApiClient()
    override init() {
        super.init()
        self.host = Constants.Udacity.APIHost
        self.scheme = Constants.Udacity.APIScheme
        self.headers = generateHeader()
    }
    
    private func generateHeader() -> Dictionary<String, String> {
        return [Constants.UdacityHeaderKeys.Accept: Constants.UdacityHeaderValues.ContentTypeJSON,
                Constants.UdacityHeaderKeys.ContentType: Constants.UdacityHeaderValues.ContentTypeJSON]
    }
    
    func createLoginSession(email: String, password: String, completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
        let httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)

        let request = createRequest(method: .POST, baseUrl: Constants.Udacity.APIBaseSessionURL, body: httpBody as AnyObject)
        
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
    
    func deleteLoginSession (completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        // Create request
        var request = createRequest(method: .Delete,baseUrl: Constants.Udacity.APIBaseSessionURL)
        
        // add Cookie/Token to the request
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: Constants.UdacityHeaderKeys.XSRFToken)
        }
        
        // make request to logout user
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
    
    func getUsername(completionHandler: @escaping (_ username: String?, _ error : String?) -> Void) {
        // create request
        let request = createRequest(method: .GET, baseUrl: Constants.Udacity.APIBaseUserURL + "/\(self.userId!)")
        
        // make the request
        makeRequest(request: request, requestType: .Udacity) {
            (result, error) in
            print(result as Any)
            // guard if there was an error
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            // check for the User key
            guard let user = result![Constants.UdacityResponseKeys.User] as? [String: AnyObject], let firstName = user[Constants.UdacityResponseKeys.FirstName] as? String, let lastName = user[Constants.UdacityResponseKeys.LastName] else {
                completionHandler(nil, "Cannot find User Info")
                return
            }
            
            completionHandler("\(firstName) \(lastName)", nil)
        }
    }
}
