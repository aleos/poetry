//
//  ViewController.swift
//  Poetry
//
//  Created by Alexander Ostrovsky on 02.05.16.
//  Copyright © 2016 Alexander Ostrovsky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var dataSource: PoemsDataSource!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = PoemsDataSource()
        tableView.dataSource = dataSource
        dataSource.tableView = tableView
    }

}
