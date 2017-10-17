//
//  NotificationHelper.swift
//  macGist
//
//  Created by Fernando Bunn on 19/06/17.
//  Copyright © 2017 Fernando Bunn. All rights reserved.
//

import Foundation
import AppKit

class NotificationHelper : NSObject {
    
    func sendNotification(withIdentifier identifier: String) {
        guard UserDefaults.standard.bool(forKey: UserDefaultKeys.notificationsKey.rawValue) == true else { return }
        
        let notification = NSUserNotification()
        notification.title = "Gist URL Copied to your clipboard"
        notification.informativeText = "Click here to open it"
        notification.identifier = identifier
        NSUserNotificationCenter.default.scheduleNotification(notification)
        NSUserNotificationCenter.default.delegate = self
    }
}


extension NotificationHelper: NSUserNotificationCenterDelegate {
    
    func userNotificationCenter(_: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        guard let identifier = notification.identifier else { return }
        guard let url = URL(string: identifier) else { return }
        NSWorkspace.shared.open(url)
        NSUserNotificationCenter.default.removeDeliveredNotification(notification)
    }
}
