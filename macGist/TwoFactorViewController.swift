//
//  TwoFactorViewController.swift
//  macGist
//
//  Created by Fernando Bunn on 21/06/17.
//  Copyright © 2017 Fernando Bunn. All rights reserved.
//

import Cocoa

class TwoFactorViewController: NSViewController {
    @IBOutlet weak var codeTextField: NSTextField!
    weak var delegate: TwoFactorViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButtonClicked(_ sender: NSButton) {
        delegate?.didCancel(controller: self)
    }
    @IBAction func authenticateButtonClicked(_ sender: NSButton) {
        delegate?.didEnter(code: codeTextField.stringValue, controller: self)
    }
}

protocol TwoFactorViewControllerDelegate: class {
    func didEnter(code: String, controller: TwoFactorViewController)
    func didCancel(controller: TwoFactorViewController)
}
