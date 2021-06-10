//
//  TrashViewController.swift
//  Signary
//
//  Created by Ameya Bhagat on 10/06/21.
//

import UIKit

class TrashViewController: UITableViewController {
private var data = notesData
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewUI()
    }
    
    //MARK:- USER INTERFACE METHODS
    
    private func tableViewUI() {
        
        //Set the datasource and delegate as the current ViewController
        tableView.dataSource = self
        tableView.delegate = self
        //Remove the separator displayed between two cells.
        tableView.separatorStyle = .none
        //Prevent selection of cell by the user.
        tableView.allowsSelection = false
        //Register the custom cell to the current tableViewController
        tableView.register(UINib(nibName: cellConstants.nibName, bundle: nil), forCellReuseIdentifier: cellConstants.indetifier)
        //Allow Selection of mutiple rows that can be access via 'tableView.indexPathForSelectedRows!'
        tableView.allowsMultipleSelectionDuringEditing = true
        //SET THE HEIGHT OF THE ROW IN TABLEVIEW EQUAL TO THE THE CUSTOM CELL
        tableView.rowHeight = 125
    }

    // MARK: - TABLEVIEW DATA SOURCE

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return notesData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellConstants.indetifier, for: indexPath) as! listViewCell
        let cellData = data[indexPath.row]
        cell.noteDescription.text = cellData.body
        cell.noteTitle.text = cellData.title
        cell.dateLabel.text = "0"
        cell.colourBar.backgroundColor = .green
        
        return cell
        
    }

}
