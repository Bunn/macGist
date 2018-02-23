
//https://developer.apple.com/library/content/samplecode/GenericKeychain/Introduction/Intro.html

import Foundation

typealias QueryDictionary = [CFString:AnyObject]

struct KeychainConfiguration {
    static let serviceName = "macGist"
    static let accessGroup = "com.idevzilla.macGist"
    static let account = "macGistAccount"
    
    struct GitHub {
        static let serviceName = "GitHub"
        static let account = "GitHubAccount"
        
        struct Gist {
            
            enum Account: String {
                case clientId
                case clientSecret
                
                func query() -> QueryDictionary {
                    let query = KeychainConfiguration.keychainQuery(withService: KeychainConfiguration.GitHub.serviceName,
                                                                    account: self.rawValue,
                                                                    accessGroup: KeychainConfiguration.accessGroup)
                    return query
                }
            }
        }
        
        static func query() -> QueryDictionary {
            let query = KeychainConfiguration.keychainQuery(withService: KeychainConfiguration.GitHub.serviceName,
                                                            account: KeychainConfiguration.GitHub.account,
                                                            accessGroup: KeychainConfiguration.accessGroup)
            return query
        }
    }
    
    static func query() -> QueryDictionary {
        let query = KeychainConfiguration.keychainQuery(withService: KeychainConfiguration.serviceName,
                                                        account: KeychainConfiguration.account,
                                                        accessGroup: KeychainConfiguration.accessGroup)
        return query
    }
    
    private static func keychainQuery(withService service: String, account: String? = nil, accessGroup: String? = nil) -> QueryDictionary {
        var query = QueryDictionary()
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrService] = service as AnyObject
        
        if let account = account {
            query[kSecAttrAccount] = account as AnyObject
        }
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup] = accessGroup as AnyObject
        }
        
        return query
    }
}

struct Keychain {
    
    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unexpectedItemData
        case unhandledError(status: OSStatus)
        case noGitHubClientSecret
        case noGitHubClientId
        case unexpectedGitHubClientIdData
        case unexpectedGitHubClientSecretData
    }
    
    func save(token password: String) throws {
        let encodedPassword = password.data(using: .utf8)!
        
        do {
            try readToken()
            
            var attributesToUpdate = QueryDictionary()
            attributesToUpdate[kSecValueData] = encodedPassword as AnyObject
            
            let query = KeychainConfiguration.query()
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        } catch KeychainError.noPassword {
            var newItem = KeychainConfiguration.query()
            newItem[kSecValueData] = encodedPassword as AnyObject
            
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        }
    }
    
    @discardableResult func readToken() throws -> String  {
        var query = KeychainConfiguration.query()
        
        query[kSecMatchLimit] = kSecMatchLimitOne
        query[kSecReturnAttributes] = kCFBooleanTrue
        query[kSecReturnData] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        
        guard let existingItem = queryResult as? QueryDictionary,
            let passwordData = existingItem[kSecValueData] as? Data,
            let password = String(data: passwordData, encoding: .utf8)
            else {
                throw KeychainError.unexpectedPasswordData
        }
        
        return password
    }
    
    func deleteToken() throws {
        let query = KeychainConfiguration.query()
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
    }
    
    func deleteGitHubClientId() throws {
        let query = KeychainConfiguration.GitHub.Gist.Account.clientId.query()
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
    }
    
    func deleteGitHubClientSecret() throws {
        let query = KeychainConfiguration.GitHub.Gist.Account.clientSecret.query()
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
    }
    
    func save(gitHubClientId: String) throws {
        let encodedGitHubClientId = gitHubClientId.data(using: .utf8)!
        
        do {
            try readGitHubClientId()
            
            var attributesToUpdate = QueryDictionary()
            attributesToUpdate[kSecValueData] = encodedGitHubClientId as AnyObject
            
            let query = KeychainConfiguration.GitHub.Gist.Account.clientId.query()
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        } catch KeychainError.noGitHubClientId {
            var newItem = KeychainConfiguration.GitHub.Gist.Account.clientId.query()
            newItem[kSecValueData] = encodedGitHubClientId as AnyObject
            
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        }
    }
    
    @discardableResult func readGitHubClientId() throws -> String {
        var query = KeychainConfiguration.GitHub.Gist.Account.clientId.query()
        
        query[kSecMatchLimit] = kSecMatchLimitOne
        query[kSecReturnAttributes] = kCFBooleanTrue
        query[kSecReturnData] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        guard status != errSecItemNotFound else { throw KeychainError.noGitHubClientId }
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        
        guard let existingItem = queryResult as? QueryDictionary,
            let passwordData = existingItem[kSecValueData] as? Data,
            let password = String(data: passwordData, encoding: .utf8)
            else {
                throw KeychainError.unexpectedGitHubClientIdData
        }
        
        return password
    }
    
    func save(gitHubClientSecret: String) throws {
        let encodedGitHubClientSecret = gitHubClientSecret.data(using: .utf8)!
        
        do {
            try readGitHubClientSecret()
            
            var attributesToUpdate = QueryDictionary()
            attributesToUpdate[kSecValueData] = encodedGitHubClientSecret as AnyObject
            
            let query = KeychainConfiguration.GitHub.Gist.Account.clientSecret.query()
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        }
        catch KeychainError.noGitHubClientSecret {
            var newItem = KeychainConfiguration.GitHub.Gist.Account.clientSecret.query()
            newItem[kSecValueData] = encodedGitHubClientSecret as AnyObject
            
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        }
    }
    
    @discardableResult func readGitHubClientSecret() throws -> String {
        var query = KeychainConfiguration.GitHub.Gist.Account.clientSecret.query()
        
        query[kSecMatchLimit] = kSecMatchLimitOne
        query[kSecReturnAttributes] = kCFBooleanTrue
        query[kSecReturnData] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        guard status != errSecItemNotFound else { throw KeychainError.noGitHubClientSecret }
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        
        guard let existingItem = queryResult as? QueryDictionary,
            let passwordData = existingItem[kSecValueData] as? Data,
            let password = String(data: passwordData, encoding: .utf8)
            else {
                throw KeychainError.unexpectedGitHubClientSecretData
        }
        
        return password
    }
}
