//
//  GistCell.swift
//  macGist
//
//  Created by Fernando Bunn on 09/01/2018.
//  Copyright © 2018 Fernando Bunn. All rights reserved.
//
//

import Cocoa

class GistCell: NSTableCellView {
    @IBOutlet private weak var titleLabel: NSTextField!
    @IBOutlet private weak var subtitleLabel: NSTextField!
    @IBOutlet private weak var lockImageView: NSImageView!
    
    static var dateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    var selected: Bool = false {
        didSet {
            if oldValue != selected {
                setupColors()
            }
        }
    }
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
                
                subtitleLabel.stringValue = "Created at: \(GistCell.dateFormatter.string(from: gist.createdAt))"
                lockImageView.image = gist.publicItem ? #imageLiteral(resourceName: "lock_opened") : #imageLiteral(resourceName: "lock_closed")
                
                setupColors()
            }
        }
    }
    
    private func setupColors() {
        if selected {
            titleLabel.textColor = .white
            subtitleLabel.textColor = .white
            lockImageView.image = lockImageView.image?.tinting(with: .white)
        } else {
            titleLabel.textColor = .darkGray
            subtitleLabel.textColor = .darkGray
            lockImageView.image = lockImageView.image?.tinting(with: .darkGray)
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
}
