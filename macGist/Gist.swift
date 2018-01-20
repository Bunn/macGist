//
//  Gist.swift
//  macGist
//
//  Created by Fernando Bunn on 21/11/2017.
//  Copyright © 2017 Fernando Bunn. All rights reserved.
//

import Foundation

struct Gist: Codable {
    let url: URL
    let identifier: String
    let publicItem: Bool
    let createdAt: Date
    let updatedAt: Date
    let description: String
    let htmlURL: URL

    /*
     GitHub API returns the files inside a dictionary with dynamic keys instead of an array
     the files property is a mapping one to one to the API, which is an object that contains multiple objects
     gistFiles is just a flatMap on files to access the files as an array.
     This can probably be improved at encoding time, but I decided to mantain the GitHub API structure for now.
    */
    private let files: GistFiles
    var gistFiles : [GistFile] {
        return files.gists.flatMap{$0}
    }
    
    enum CodingKeys: String, CodingKey {
        case url
        case description
        case identifier = "id"
        case publicItem = "public"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case htmlURL = "html_url"
        case files
    }
}
