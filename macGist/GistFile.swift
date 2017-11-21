//
//  GistFile.swift
//  macGist
//
//  Created by Fernando Bunn on 21/11/2017.
//  Copyright © 2017 Fernando Bunn. All rights reserved.
//

import Foundation

class GistFile: Codable {
    let filename: String
    let type: String
    var language: String
    let rawURL: URL

    enum CodingKeys: String, CodingKey {
        case filename
        case type
        case language
        case rawURL = "raw_url"
    }
}
