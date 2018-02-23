//
//  GitHubCredential.swift
//  Xgist
//
//  Created by Fernando Bunn on 28/03/17.
//  Copyright © 2017 Fernando Bunn. All rights reserved.
//

import Foundation

enum GitHubCredentialManager {
    static private let keychain = Keychain()
    
    static var clientId: String? {
        get {
            return try? keychain.readGitHubClientId()
        }
        
        set {
            do {
                if let id = newValue {
                    try keychain.save(gitHubClientId: id)
                }
            } catch let error {
                print("Error trying to save client id:: \(error)")
            }
        }
    }
    
    static var clientSecret: String? {
        get {
            return try? keychain.readGitHubClientSecret()
        }
        
        set {
            do {
                if let secret = newValue {
                    try keychain.save(gitHubClientSecret: secret)
                }
            } catch let error {
                print("Error trying to save client secret:: \(error)")
            }
        }
    }
}
