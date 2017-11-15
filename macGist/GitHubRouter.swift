//
//  GitHubRouter.swift
//  Xgist
//
//  Created by Fernando Bunn on 27/03/17.
//  Copyright © 2017 Fernando Bunn. All rights reserved.
//

import Foundation

enum GitHubRouter {
    case auth([String : Any])
    case gist([String : Any], Bool)
    case gists
    
    private var basePath: String {
        return "https://api.github.com"
    }
    
    private var accessToken: String {
        guard let token = GitHubAPI().token else { fatalError("No Token") }
        return token
    }
    
    private var path: String {
        switch self {
        case .auth:
            return "authorizations/clients/\(GitHubCredential.clientID.value)/\(UUID.init())"
        case .gist( _ , let authenticated):
            if authenticated {
                return "gists?access_token=\(accessToken)"
            } else {
                return "gists"
            }
        case .gists:
            return "users/\("usernameToTest")/gists?access_token=\(accessToken)"
        }
    }
        
    private var method: String {
        switch self {
        case .auth:
            return "PUT"
        case .gist:
            return "POST"
        case .gists:
            return "GET"
        }
    }
    
    private var httpBody: Data? {
        switch self {
        case .auth(let params), .gist(let params, _):
            let jsonData = try? JSONSerialization.data(withJSONObject: params)
            return jsonData
        case .gists:
            return nil
        }
    }
    
    
    //MARK: - Public Functions
    
    var request: URLRequest? {
        guard let url = URL(string: "\(basePath)/\(path)") else {
            print("Invalid URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = httpBody
        return request
    }
}
