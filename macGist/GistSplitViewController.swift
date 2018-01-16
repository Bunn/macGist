//
//  GistSplitViewController.swift
//  macGist
//
//  Created by Fernando Bunn on 23/11/2017.
//  Copyright © 2017 Fernando Bunn. All rights reserved.
//

import Cocoa

class GistSplitViewController: NSSplitViewController {
    
    let listViewController = GistListViewController()
    let detailsViewController = GistDetailsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.frame = NSMakeRect(0, 0, 850, 650)
        setupSplitView()
    }
    
    private func setupSplitView() {
        listViewController.delegate = self
        
        let masterItem = NSSplitViewItem(viewController: listViewController)
        let detailsItem = NSSplitViewItem(viewController: detailsViewController)
        
        addSplitViewItem(masterItem)
        addSplitViewItem(detailsItem)
    }
}

extension GistSplitViewController: GistListViewControllerDelegate {
    
    func didSelect(gist: Gist, controller: GistListViewController) {
        detailsViewController.gist = gist
    }
}
