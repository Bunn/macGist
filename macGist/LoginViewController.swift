//
//  LoginViewController.swift
//  macGist
//
//  Created by Fernando Bunn on 20/06/17.
//  Copyright © 2017 Fernando Bunn. All rights reserved.
//

import Cocoa

class LoginViewController: NSViewController {
    
    @IBOutlet private weak var passwordTextField: NSSecureTextField!
    @IBOutlet private weak var usernameTextField: NSTextField!
    @IBOutlet private weak var spinner: NSProgressIndicator!
    @IBOutlet private weak var loginButton: NSButton!
    @IBOutlet weak var errorLabel: NSTextField!
    weak var delegate: LoginViewControllerDelegate?
    private let githubAPI = GitHubAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction private func loginButtonClicked(_ sender: NSButton) {
        setupUI()
        authenticate()
    }
    
    @IBAction private func cancelButtonClicked(_ sender: NSButton) {
        delegate?.didFinish(controller: self)
    }
    
    fileprivate func setupUI() {
        spinner.isHidden = true
        errorLabel.isHidden = true
    }
    
    private func showSpinner(show: Bool) {
        spinner.isHidden = !show
        loginButton.isHidden = show
        if show {
            spinner.startAnimation(nil)
        } else {
            spinner.stopAnimation(nil)
        }
    }
    
    fileprivate func displayError(message: String) {
        showSpinner(show: false)
        errorLabel.isHidden = false
        errorLabel.stringValue = message
    }
    
    private func openTwoFactorController() {
        let twoFactorController = TwoFactorViewController()
        twoFactorController.delegate = self
        presentViewControllerAsSheet(twoFactorController)
    }
    
    fileprivate func authenticate(twoFactorCode: String? = nil) {
        showSpinner(show: true)
        githubAPI.authenticate(username: usernameTextField.stringValue, password: passwordTextField.stringValue, twoFactorCode: twoFactorCode) { (error: Error?) in
            print("Error \(String(describing: error))")
            DispatchQueue.main.async {
                if error != nil {
                    if let apiError = error as? GitHubAPI.GitHubAPIError {
                        switch apiError {
                        case .twoFactorRequired:
                            self.openTwoFactorController()
                            return
                        default: break
                        }
                    }
                    self.displayError(message: "Bad username or password")
                } else {
                    UserDefaults.standard.set(self.usernameTextField.stringValue, forKey: UserDefaultKeys.usernameKey.rawValue)
                   self.delegate?.didFinish(controller: self)
                }
            }
        }
    }
}

protocol LoginViewControllerDelegate: class {
    func didFinish(controller: LoginViewController)
}

extension LoginViewController: TwoFactorViewControllerDelegate {
    
    func didEnter(code: String, controller: TwoFactorViewController) {
        authenticate(twoFactorCode: code)
        controller.dismiss(nil)
    }
    
    func didCancel(controller: TwoFactorViewController) {
        setupUI()
        displayError(message: "Two-Factor cancelled")
        controller.dismiss(nil)
    }
}
