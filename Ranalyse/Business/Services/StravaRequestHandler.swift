//
//  StravaRequestHandler.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 6/1/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation
import Alamofire

//class StravaRequestHandler: RequestAdapter {
//    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
//        var urlRequest = urlRequest
//        if let urlString = urlRequest.url?.absoluteString,
//            urlString.range(of: Constants.Service.Url.vivintSubstring) != nil,
//            let token = tokens?.accessToken {
//            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        }
//        if urlRequest.value(forHTTPHeaderField: "Accept") == nil {
//            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
//        }
//        urlRequest.timeoutInterval = Constants.Service.timeoutInterval
//        return urlRequest
//    }
//    
//    
//}
