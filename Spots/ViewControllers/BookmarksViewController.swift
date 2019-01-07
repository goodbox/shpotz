//
//  BookmarksViewController.swift
//  goodspots
//
//  Created by Alexander Grach on 1/6/19.
//  Copyright © 2019 goodbox. All rights reserved.
//

import Foundation

public class BookmarksViewController : UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tblBookmarks: UITableView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tblBookmarks.delegate = self
        tblBookmarks.dataSource = self
    }
}

extension BookmarksViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
