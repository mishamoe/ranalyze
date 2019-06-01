//
//  AuthenticationSession.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/31/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation
import SafariServices
import AuthenticationServices

protocol AuthenticationSessionProtocol {
    init(url URL: URL,
         callbackURLScheme: String?,
         completionHandler: @escaping (URL?, Error?) -> Void)
    
    func start() -> Bool
    func cancel()
}

extension SFAuthenticationSession: AuthenticationSessionProtocol { }

@available(iOS 12.0, *)
extension ASWebAuthenticationSession: AuthenticationSessionProtocol { }

class AuthenticationSession: AuthenticationSessionProtocol {
    
    private let innerAuthenticationSession: AuthenticationSessionProtocol
    
    required init(url URL: URL,
                  callbackURLScheme: String?,
                  completionHandler: @escaping (URL?, Error?) -> Void) {
        
        if #available(iOS 12, *) {
            innerAuthenticationSession = ASWebAuthenticationSession(url: URL, callbackURLScheme: callbackURLScheme, completionHandler: completionHandler)
        } else {
            innerAuthenticationSession = SFAuthenticationSession(url: URL, callbackURLScheme: callbackURLScheme, completionHandler: completionHandler)
        }
    }
    
    func start() -> Bool {
        return innerAuthenticationSession.start()
    }
    
    func cancel() {
        innerAuthenticationSession.cancel()
    }
}
