//
//  APIClient.swift
//  Map Me
//
//  Created by Sagar Choudhary on 27/11/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import Foundation


class APIClient {
    let session = URLSession.shared
    
    var headers: [String:String] = [String: String]()
    var scheme: String = ""
    var host: String = ""
    
    enum apiMethod: String {
        case GET
        case POST
        case Delete
        case PUT
    }
    enum requestType: String {
        case Udacity
        case Parse
    }
    
    // MARK: Build Url froom params
    private func buildUrlWithParam(parameters: [String: AnyObject], baseUrl: String) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = self.scheme
        urlComponents.host = self.host
        urlComponents.path = baseUrl
        urlComponents.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            urlComponents.queryItems!.append(queryItem)
        }
        return urlComponents.url!
    }
    
    // MARK: Create Request
    func createRequest(parameters: [String:AnyObject] = [String: AnyObject](), method: apiMethod = .GET, baseUrl: String, body: AnyObject? = nil) -> URLRequest {
        
        var request = URLRequest(url: buildUrlWithParam(parameters: parameters, baseUrl: baseUrl))
        
        // http method
        request.httpMethod = method.rawValue.uppercased()
        
        // add headers to the request
        for (header, value) in self.headers {
            request.addValue(value, forHTTPHeaderField: header)
        }
        
        if (body != nil) {
            request.httpBody = (body as! Data)
        }
        
        return request
    }
    
    func makeRequest(request: URLRequest, requestType: requestType, completionHandler: @escaping (_ result: AnyObject?, _ error: String?) -> Void) {
        let task = session.dataTask(with: request) {
            (data, response, error) in
            // if an error occurs, print it and re-enable the UI
            guard(error == nil) else {
                completionHandler(nil, "Connection Error")
                return
            }
            
            // guard for successful http response
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                if (requestType == .Udacity) {
                    completionHandler(nil, "Incorrect Username and Password")
                } else {
                    completionHandler(nil, "Your request returned a status code other than 2xx!")
                }
                return
            }
            
            // guard if any data is returned or not
            guard var data = data else {
                completionHandler(nil, "No data was returned by the API")
                return
            }
            
            // parse the result
            let parsedResult: [String: AnyObject]!
            
            do {
                // if request was for udacity api format data before parsing
                if (requestType == .Udacity) {
                    data = self.getFormattedData(data: data)
                }
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject]
            } catch {
                completionHandler(nil, "Could not parse the data as JSON: '\(data)'")
                return
            }
            
            // yay!! we got the data from request
            completionHandler(parsedResult as AnyObject, nil)            
        }
        
        // resume the task
        task.resume()
    }
    
    private func getFormattedData(data: Data) -> Data {
        let range = (5..<data.count)
        return data.subdata(in: range)
    }
}
