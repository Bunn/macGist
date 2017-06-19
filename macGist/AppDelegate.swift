//
//  AppDelegate.swift
//  macGist
//
//  Created by Fernando Bunn on 23/05/17.
//  Copyright © 2017 Fernando Bunn. All rights reserved.
//

import Cocoa

@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate {

    let menu = Menu()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        menu.setupMenu()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
    }
}

