//
//  GistDetailHeader.swift
//  macGist
//
//  Created by Fernando Bunn on 20/01/2018.
//  Copyright © 2018 Fernando Bunn. All rights reserved.
//

import Cocoa

class GistDetailHeader: NSView {

    @IBOutlet private weak var titleLabel: NSTextField!
    @IBOutlet private weak var createdAtLabel: NSTextField!
    @IBOutlet private weak var updatedAtLabel: NSTextField!
    
    var dateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    var gist: Gist? {
        didSet {
            if let gist = gist {
                if gist.description.count == 0 {
                    if let file = gist.gistFiles.first {
                        titleLabel.stringValue = file.name
                    }
                } else {
                    titleLabel.stringValue = gist.description
                }
                createdAtLabel.stringValue = "Created at: \(dateFormatter.string(from: gist.createdAt))"
                updatedAtLabel.stringValue = "Updated at: \(dateFormatter.string(from: gist.updatedAt))"
            }
        }
    }
    
    @IBAction func openURL(_ sender: NSButton) {
        if let url = gist?.htmlURL {
            NSWorkspace.shared.open(url)
        } else {
            //TODO: handle it properly
            print("No Url?")
        }
    }
}
