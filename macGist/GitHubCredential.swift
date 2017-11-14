//
//  GitHubCredential.swift
//  Xgist
//
//  Created by Fernando Bunn on 28/03/17.
//  Copyright © 2017 Fernando Bunn. All rights reserved.
//

import Foundation

enum GitHubCredential: String {
    case clientSecret
    case clientID
    
    var value: String {
        guard let path = Bundle.main.path(forResource: "Credentials", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] else { fatalError("No plist found") }
        
        switch self {
        case .clientID:
            guard let value = dict["GitHubClientID"] as? String else { fatalError("GitHubClientID not found") }
            return value
        case .clientSecret:
            guard let value = dict["GitHubSecret"] as? String else { fatalError("GitHubSecret not found") }
            return value
        }
    }
}
