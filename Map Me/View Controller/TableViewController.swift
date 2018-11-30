//
//  TableViewController.swift
//  Map Me
//
//  Created by Sagar Choudhary on 29/11/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    // MARK: Reload table data
    func reloadData() {
        self.tableView.reloadData()
    }
    
    // MARK: Number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentsInfo.shared.studentsList.count
    }
    
    // MARK: Populate the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")!
        let student = StudentsInfo.shared.studentsList[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        cell.detailTextLabel?.text = student.mediaUrl
        return cell
    }
    
    // MARK: Action on Cell selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = StudentsInfo.shared.studentsList[(indexPath as NSIndexPath).row].mediaUrl
        openUrl(urlString: url)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
