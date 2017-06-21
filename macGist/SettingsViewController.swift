//
//  SettingsViewController.swift
//  macGist
//
//  Created by Fernando Bunn on 20/06/17.
//  Copyright © 2017 Fernando Bunn. All rights reserved.
//

import Cocoa
import ServiceManagement

class SettingsViewController: NSViewController {
    @IBOutlet weak var githubButton: NSButton!
    private let githubAPI = GitHubAPI()
    weak var delegate: SettingsViewControllerDelegate?
    @IBOutlet weak var notificationsButton: NSButton!
    @IBOutlet weak var statusLabel: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI() {
        title = "Settings"
        
        if githubAPI.isAuthenticated {
            githubButton.title = "GitHub Log Out"
            statusLabel.stringValue = "Logged in"
            if let name = UserDefaults.standard.string(forKey: UserDefaultKeys.usernameKey.rawValue) {
                statusLabel.stringValue = "Logged in as \(name)"
            }
        } else {
            githubButton.title = "GitHub Log In"
            statusLabel.stringValue = "To post authenticated Gists"
        }
        
        notificationsButton.state = UserDefaults.standard.integer(forKey: UserDefaultKeys.notificationsKey.rawValue)
    }
    
    @IBAction func notificationClicked(_ sender: NSButton) {
        UserDefaults.standard.set(sender.state, forKey: UserDefaultKeys.notificationsKey.rawValue)
    }
    
    @IBAction func githubButtonClicked(_ sender: NSButton) {
        if githubAPI.isAuthenticated {
            githubAPI.logout()
            delegate?.didUpdateAuthStatus(controller: self)
            setupUI()
        } else {
            let loginViewController = LoginViewController()
            loginViewController.delegate = self
            presentViewControllerAsSheet(loginViewController)
        }
    }
}

extension SettingsViewController: LoginViewControllerDelegate {
    func didFinish(controller: LoginViewController) {
        setupUI()
        delegate?.didUpdateAuthStatus(controller: self)
        controller.dismiss(nil)
    }
}

protocol SettingsViewControllerDelegate: class {
    func didUpdateAuthStatus(controller: SettingsViewController)
}
