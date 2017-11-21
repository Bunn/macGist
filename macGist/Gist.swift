//
//  Gist.swift
//  macGist
//
//  Created by Fernando Bunn on 21/11/2017.
//  Copyright © 2017 Fernando Bunn. All rights reserved.
//

import Foundation

class Gist: Codable {
    let url: URL
    let identifier: String
    let publicItem: Bool
    let createdAt: Date
    let updatedAt: Date
   // let files: Dictionary<String, GistFile>

    
    enum CodingKeys: String, CodingKey {
        case url
        case identifier = "id"
        case publicItem = "public"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        //case files
    }
}
