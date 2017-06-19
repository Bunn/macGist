//
//  GitHubAPI.swift
//  Xgist
//
//  Created by Fernando Bunn on 27/03/17.
//  Copyright © 2017 Fernando Bunn. All rights reserved.
//

import Foundation

struct GitHubAPI {
    let twoFactorHeader = "X-GitHub-OTP"
    
    enum GitHubAPIError: Error {
        case badHHTPStatus
        case invalidRequest
        case invalidJSON
        case tokenNotFound
        case twoFactorRequired
    }
    
    
    //MARK: - Variables
    var isAuthenticated: Bool {
        if let _ = token {
            return true
        } else {
            return false
        }
    }
    
    var token: String? {
        do {
            let password = try Keychain().readPassword()
            return password
        } catch {
            return nil
        }
    }
    
    
    //MARK: - Public Functions
    
    func logout() {
        do {
            try Keychain().deleteItem()
        } catch {
            fatalError("Error deleting keychain item - \(error)")
        }
    }
    
    func post(gist: String, fileExtension: String, authenticated: Bool, completion: @escaping (Error?, String?) -> Void) {
        var file = [String : Any]()
        file["content"] = gist
        
        var files = [String : Any]()
        files["macGist.\(fileExtension)"] = file
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        let dateString = formatter.string(from: Date())
        
        var jsonDictionary = [String : Any]()
        jsonDictionary["description"] = "Generated by macGist (https://github.com/Bunn/macGist) at \(dateString)"
        jsonDictionary["public"] = false
        jsonDictionary["files"] = files
        
        guard let request = GitHubRouter.gist(jsonDictionary, authenticated).request else {
            completion(GitHubAPIError.invalidRequest, nil)
            return
        }
        
        //Setup Session
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(error, nil)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 201 {
                completion(GitHubAPIError.badHHTPStatus, nil)
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String : Any] {
                if let htmlURL = json["html_url"] as? String {
                    completion(nil, htmlURL)
                }
            }
        }
        
        task.resume()
    }
    
    func authenticate (username: String, password: String, twoFactorCode: String? = nil, completion: @escaping (Error?) -> Void) {
        let scopes = ["gist"]
        let params  = ["client_secret" : GitHubCredential.clientSecret.rawValue,
                       "scopes" : scopes,
                       "note" : "testNote"] as [String : Any]
        
        guard var request = GitHubRouter.auth(params).request else {
            completion(GitHubAPIError.invalidRequest)
            return
            
        }
        if let code = twoFactorCode {
            request.setValue(code, forHTTPHeaderField: twoFactorHeader)
        }
        let loginData = base64Login(username: username, password: password)
        request.setValue("Basic \(loginData)", forHTTPHeaderField: "Authorization")
        
        //Setup Session
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let responseData = data, error == nil,
                let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: []) else {
                    completion(error)
                    return
            }
            
            guard let json = jsonObject as? [String : Any] else {
                completion(GitHubAPIError.invalidJSON)
                return
            }
            
            guard let httpStatus = response as? HTTPURLResponse else {
                completion(GitHubAPIError.invalidRequest)
                return
            }
            
            guard httpStatus.allHeaderFields[self.twoFactorHeader] == nil else {
                completion(GitHubAPIError.twoFactorRequired)
                return
            }
            
            guard let token = json["token"] as? String else {
                completion(GitHubAPIError.tokenNotFound)
                return
            }
            
            do {
                try Keychain().savePassword(token)
                completion(nil)
            } catch {
                completion(error)
            }
        }
        task.resume()
    }
    
    
    //MARK: - Private Functions
    
    fileprivate func base64Login(username: String, password: String) -> String {
        let loginString = "\(username):\(password)"
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        return base64LoginString
    }
}
