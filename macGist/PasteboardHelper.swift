//
//  PasteboardHelper.swift
//  macGist
//
//  Created by Fernando Bunn on 17/06/17.
//  Copyright © 2017 Fernando Bunn. All rights reserved.
//

import Foundation
import AppKit


struct PasteboardHelper {
    
    func getPasteboardString() -> String? {
        let pasteboard = NSPasteboard.general()
        
        if let copiedItems = pasteboard.readObjects(forClasses: [NSString.self], options: nil) {
            for item in copiedItems {
                if let stringItem = item as? String {
                    return stringItem;
                }
            }
        }
        return nil
    }
    
    func save(string: String) {
        let pasteboard = NSPasteboard.general()
        pasteboard.clearContents()
        pasteboard.writeObjects([string as NSPasteboardWriting])
        
    }
}
