//
//  GistDetailsViewController.swift
//  macGist
//
//  Created by Fernando Bunn on 23/11/2017.
//  Copyright © 2017 Fernando Bunn. All rights reserved.
//

import Cocoa

class GistDetailsViewController: NSViewController {
    @IBOutlet var textView: NSTextView!
    var gist: Gist? {
        didSet {
            if let gist = gist {
                //Test
                for file in gist.gistFiles {
                    let data = try? String(contentsOf: file.rawURL)
                    textView.string = data!
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
