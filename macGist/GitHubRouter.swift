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

    var basePath: String {
        return "https://api.github.com"
    }
    
    var path: String {
        switch self {
        case .auth:
            return "authorizations/clients/\(GitHubCredential.clientID.rawValue)/\(UUID.init())"
        case .gist( _ , let authenticated):
            if authenticated {
                guard let token = GitHubAPI().token else { fatalError("No Token") }
                return "gists?access_token=\(token)"
            } else {
                return "gists"
            }
        }
    }
    
    var method: String {
        switch self {
        case .auth:
            return "PUT"
        case .gist:
            return "POST"
        }
    }
    
    var httpBody: Data? {
        switch self {
        case .auth(let params), .gist(let params, _):
            let jsonData = try? JSONSerialization.data(withJSONObject: params)
            return jsonData
        }
    }
    
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
