//
//  Menu.swift
//  macGist
//
//  Created by Fernando Bunn on 23/05/17.
//  Copyright © 2017 Fernando Bunn. All rights reserved.
//

import Foundation
import AppKit

enum Images {
    case standardIcon
    case checkmarkIcon
    
    var image: NSImage? {
        var image: NSImage?
        
        switch self {
        case .standardIcon:
            image = NSImage(named: "icon")
        case .checkmarkIcon:
            image = NSImage(named: "check_white_icon")
        }
        image?.isTemplate = true
        return image
    }
}

class Menu {
    fileprivate let item = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    fileprivate let notificationHelper = NotificationHelper()
    
    func setupMenu() {
        item.image = Images.standardIcon.image
        let menu = NSMenu()
        
        let gistMenuItem = NSMenuItem(title: "Create Gist", action: #selector(Menu.createGist), keyEquivalent: "g")
        gistMenuItem.target = self
        menu.addItem(gistMenuItem)
        
        let quitMenuItem = NSMenuItem(title: "Quit", action: #selector(Menu.quit), keyEquivalent: "q")
        quitMenuItem.target = self
        menu.addItem(quitMenuItem)
        
        item.menu = menu
    }

    @objc fileprivate func quit() {
        NSApplication.shared().terminate(self)
    }
    
    fileprivate func displaySuccessIcon() {
        item.image = Images.checkmarkIcon.image
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.item.image = Images.standardIcon.image        }
    }
    
    @objc fileprivate func createGist() {
        guard let copiedItem = PasteboardHelper().getPasteboardString() else { return }
        GitHubAPI().post(gist: copiedItem, fileExtension: "file", authenticated: false) { (error, string) in
            if let value = string {
                PasteboardHelper().save(string: value)
                self.displaySuccessIcon()
                self.notificationHelper.sendNotification(withIdentifier: value)
            }
        }
    }
}
