//
//  TestTitle.swift
//  PopView
//
//  Created by weiwei.li on 2020/7/10.
//  Copyright © 2020 dd01.leo. All rights reserved.
//

import UIKit

class TestTitle: UIView, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    var closeAction: (() -> ())?

    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
}
