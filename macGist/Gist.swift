//
//  Gist.swift
//  macGist
//
//  Created by Fernando Bunn on 21/11/2017.
//  Copyright © 2017 Fernando Bunn. All rights reserved.
//

import Foundation

class Gist: Codable {
    let url: String
    let identifier: String
    
    enum CodingKeys: String, CodingKey {
        case url
        case identifier = "id"
    }
}
