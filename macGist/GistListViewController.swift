//
//  GistListViewController.swift
//  macGist
//
//  Created by Fernando Bunn on 23/11/2017.
//  Copyright © 2017 Fernando Bunn. All rights reserved.
//

import Cocoa

protocol GistListViewControllerDelegate: class {
    func didSelect(gist: Gist, controller: GistListViewController)
}

class GistListViewController: NSViewController {
    weak var delegate: GistListViewControllerDelegate?
    @IBOutlet weak var tableView: NSTableView!
    let githubAPI = GitHubAPI()
    var gists: [Gist] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        updateData()
    }
    
    private func updateData() {
        githubAPI.fetchGists { (error, gists) in
            guard let gists = gists else { return }
            self.gists = gists
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension GistListViewController: NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return gists.count
    }
}

extension GistListViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) as? NSTableCellView
        let gist = gists[row]
        cell?.textField?.stringValue = gist.description
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if tableView.selectedRow >= 0 {
            let gist = gists[tableView.selectedRow]
            delegate?.didSelect(gist: gist, controller: self)
        }
    }
}
