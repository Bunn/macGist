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
    
    /*
     This only seems to work for Xcode pasted items, since the app that creates the paste can
     add tags as it see fit there's no standardize way to get an extension from a pasteboard
     */
    func getFileExtension() -> String {
        let xcodeExtensionType = "DVTSourceTextViewLanguagePboardType"
        guard let data = NSPasteboard.general().data(forType: xcodeExtensionType),
            let string = String(data: data, encoding: .utf8),
            let fileExtension = string.components(separatedBy: ".").last else { return "file" }
        
        //Gists doesn't highlight items with some file extensions
        let types = ["Objective-C-Plus-Plus" : "mm",
                     "Objective-C" : "m"]
        
        if let newExtension = types[fileExtension] {
            return newExtension
        }
        
        return fileExtension
    }
    
    func save(string: String) {
        let pasteboard = NSPasteboard.general()
        pasteboard.clearContents()
        pasteboard.writeObjects([string as NSPasteboardWriting])
        
    }
}
