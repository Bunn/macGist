//
//  GistFile.swift
//  macGist
//
//  Created by Fernando Bunn on 21/11/2017.
//  Copyright © 2017 Fernando Bunn. All rights reserved.
//

import Foundation

struct GistFile : Codable {
    let name: String
    let type: String
    let language: String?
    let rawURL: URL
}

struct GistFiles: Codable {
    let gists : [GistFile]
    
    struct GistFileKey : CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }
        
        static let type = GistFileKey(stringValue: "type")!
        static let url = GistFileKey(stringValue: "raw_url")!
        static let language = GistFileKey(stringValue: "language")!
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: GistFileKey.self)
        
        var gists: [GistFile] = []
        for key in container.allKeys {
            let nested = try container.nestedContainer(keyedBy: GistFileKey.self, forKey: key)
            let type = try nested.decode(String.self, forKey: .type)
            let url = try nested.decode(URL.self, forKey: .url)
            let language = try? nested.decode(String.self, forKey: .language)
            gists.append(GistFile(name: key.stringValue, type: type, language:language, rawURL: url))
        }
        self.gists = gists
    }
}
