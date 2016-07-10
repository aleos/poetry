//
//  PoemsDataSource.swift
//  Poetry
//
//  Created by Alexander Ostrovsky on 03.05.16.
//  Copyright © 2016 Alexander Ostrovsky. All rights reserved.
//

import UIKit

import GoogleAPIs

class PoemsDataSource: NSObject, UITableViewDataSource {
    weak var tableView: UITableView? {
        didSet {
            poemsController.fetchPoems { (poems) in
                self.tableView?.reloadData()
            }
        }
    }
    
    private let poemsController = PoemsModelController()
    
    override init() {
        super.init()
        
        poemsController.fetchPoems { [unowned self] (poems) in
            self.tableView?.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poemsController.poems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let poemTitleCell = tableView.dequeueReusableCellWithIdentifier(String(PoemTitleCell), forIndexPath: indexPath) as! PoemTitleCell
        if indexPath.row < poemsController.poems.count {
            poemTitleCell.textLabel?.text = poemsController.poems[indexPath.row].title
        }
        return poemTitleCell
    }
}
