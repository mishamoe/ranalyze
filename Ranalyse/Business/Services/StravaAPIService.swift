//
//  StravaAPIService.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/31/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import UIKit
import Alamofire

final class StravaAPIService {
    enum C {
        static let client_id = "35343"
        static let client_secret = "40b539c6ce34f18ded0e0e79198c1a7befb4fc26"
        
        static let redirect_uri = "ranalyze://ranalyze.run"
        static let response_type = "code"
        static let approval_prompt = "auto"
        static let scope = "activity:read_all"//.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        static let state = "test"
        
        static let callbackURLScheme = "ranalyze://auth"
        
        static let grant_type = "authorization_code"
    }
    
    private let appOAuthUrlStravaScheme: URL! = {
        var urlComponents = URLComponents(string: "strava://oauth/mobile/authorize")
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: C.client_id),
            URLQueryItem(name: "redirect_uri", value: C.redirect_uri),
            URLQueryItem(name: "response_type", value: C.response_type),
            URLQueryItem(name: "approval_prompt", value: C.approval_prompt),
            URLQueryItem(name: "scope", value: C.scope),
            URLQueryItem(name: "state", value: C.state)
        ]
        return urlComponents?.url
        
    }()
    
    private let webOAuthUrl: URL! = {
        var urlComponents = URLComponents(string: "https://www.strava.com/oauth/mobile/authorize")
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: C.client_id),
            URLQueryItem(name: "redirect_uri", value: C.redirect_uri),
            URLQueryItem(name: "response_type", value: C.response_type),
            URLQueryItem(name: "approval_prompt", value: C.approval_prompt),
            URLQueryItem(name: "scope", value: C.scope),
            URLQueryItem(name: "state", value: C.state)
        ]
        return urlComponents?.url
    }()
    
    
    private var authenticationSession: AuthenticationSession!
    
    var accessToken: String?
    var refreshToken: String?
    var tokenExpiresAt: Date?
    
    func authenticate(_ completion: @escaping (Error?) -> Void) {
        _ = authenticateUsingWeb { [weak self] url, error in
            guard error == nil else {
                print("Error: \(error?.localizedDescription ?? "")")
                completion(error)
                return
            }
            
            if let url = url?.absoluteString,
                let urlComponents = URLComponents(string: url),
                let queryItems = urlComponents.queryItems {
                let code = queryItems.first { $0.name == "code" }?.value
                
                self?.exchangeToken(code: code, completion: {
                    print("Info: Did receive token")
                })
            }
            
            completion(nil)
        }
    }
    
    private func authenticateUsingWeb(_ completion: @escaping (URL?, Error?) -> Void) -> Bool {
        authenticationSession = AuthenticationSession(url: webOAuthUrl, callbackURLScheme: C.callbackURLScheme, completionHandler: { url, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let url = url {
                print("Info: Authentication is completed successfully. URL: \(url)")
            }

            completion(url, error)
        })

        return authenticationSession.start()
    }
    
    private func authenticateUsingApp(_ completion: @escaping (Bool) -> Void) -> Bool {
        if UIApplication.shared.canOpenURL(appOAuthUrlStravaScheme) {
            UIApplication.shared.open(appOAuthUrlStravaScheme, options: [:]) { success in
                if success {
                    print("Info: Strava app was successfully opened")
                } else {
                    print("Error: An error occured while opening Strava app")
                }
                
                completion(success)
            }
            
            return true
        } else {
            return false
        }
    }
    
    func exchangeToken(code: String?, completion: @escaping () -> Void) {
        let parameters: Parameters = ["client_id":C.client_id,
                                      "client_secret":C.client_secret,
                                      "code": code ?? "",
                                      "grant_type": C.grant_type]
        
        Alamofire
            .request("https://www.strava.com/oauth/token", method: .post, parameters: parameters)
            .responseJSON { [weak self] response in
                print("Request: POST https://www.strava.com/oauth/token")
                
                if let json = response.result.value as? [String: Any] {
                    print("Response: \(json)\n")
                    
                    self?.accessToken = json["access_token"] as? String
                    self?.refreshToken = json["refresh_token"] as? String
                    
                    if let expiresAt = json["expires_at"] as? TimeInterval {
                        self?.tokenExpiresAt = Date(timeIntervalSince1970: expiresAt)
                    }
                }
                
                completion()
        }
    }
    
    func activities(_ completion: @escaping () -> Void) {
        let parameters: Parameters = [:]/*["before": 0,
                                      "after": 0,
                                      "page": 1,
                                      "per_page": 30]*/
        
        Alamofire
            .request("https://www.strava.com/api/v3/athlete/activities", method: .get, parameters: parameters)
            .responseJSON { [weak self] response in
                print("Request: GET https://www.strava.com/api/v3/athlete/activities")
                if let json = response.result.value as? [String: Any] {
                    print("Response: \(json)\n")
                    
                    
                }
                
                completion()
        }
    }
    
    func deauthorize(_ completion: @escaping () -> Void) {
        Alamofire
            .request("https://www.strava.com/oauth/deauthorize", method: .post, parameters: [:])
            .responseJSON { response in
                completion()
        }
    }
}
