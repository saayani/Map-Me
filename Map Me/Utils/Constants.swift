//
//  Constants.swift
//  Map Me
//
//  Created by Sagar Choudhary on 27/11/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

struct Constants {
    
    struct Parse {
        static let APIScheme = "https"
        static let APIHost = "parse.udacity.com"
        static let APIBaseURL = "/parse/classes/StudentLocation"
    }
    
    struct ParseHeaderKeys{
        static let ApplicationId = "X-Parse-Application-Id"
        static let APIKey = "X-Parse-REST-API-Key"
        static let ContentType = "Content-Type"
    }
    
    struct ParseHeaderValues {
        static let ApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ContentTypeJSON = "application/json"
    }
    
    struct ParseParamKeys {
        static let Limit = "limit"
        static let Order = "order"
        static let Where = "where"
    }
    
    struct ParseParamValues {
        static let Limit = "100"
        static let Order = "-updatedAt"
    }

    struct Udacity {
        static let APIScheme = "https"
        static let APIHost = "onthemap-api.udacity.com"
        static let APIBaseSessionURL = "/v1/session"
        static let APIBaseUserURL = "/v1/users"
        static let SignupURL = "https://auth.udacity.com/sign-up"
    }
    
    struct UdacityHeaderKeys {
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
    }
    
    struct UdacityHeaderValues {
        static let ContentTypeJSON = "application/json"
    }
    
    struct UdacityResponseKeys {
        static let Account = "account"
        static let Key = "key"
        static let Session = "session"
        static let Id = "id"
        static let User = "user"
        static let NickName = "nickname"
        static let FirstName = "first_name"
        static let LastName = "last_name"
    }
    
    struct StudentInfo {
        static let Results = "results"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaUrl = "mediaURL"
        static let UniqueKey = "uniqueKey"
        static let ObjectId = "objectId"
    }
}
