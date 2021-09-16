//
//  TrashViewController.swift
//  Signary
//
//  Created by Ameya Bhagat on 10/06/21.
//

import UIKit

class TrashViewController: UITableViewController {
    //MARK:- PROPRTIES
    private var data = notesData
    private let interface = TrashInterFaceHelper()
    private let logic = Logic()
    
    //MARK:- INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        registerDelegates()
        setNavigationBarItems()
        tableViewUI()
        navigationItem.title = "Trash"
    }
    
    private func registerDelegates() {
        interface.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //MARK:- USER INTERFACE METHODS
    
    private func tableViewUI() {
        
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
        tableView.separatorStyle = .singleLine
    }
    
    private func setNavigationBarItems() {
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = nil

        navigationItem.setRightBarButtonItems([interface.selectButton, interface.eraseAllButton], animated: true)
    }
    
    // MARK: - TABLEVIEW DATA SOURCE
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if logic.trashData.count == 0 {
            interface.selectButton.isEnabled = false
            interface.eraseAllButton.isEnabled = false
        } else {
            interface.selectButton.isEnabled = true
            interface.eraseAllButton.isEnabled = true
        }
        
        return logic.trashData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellConstants.indetifier, for: indexPath) as! listViewCell
        let thisNote = logic.trashData[indexPath.row]
        let cellColour: UIColor
        
        cell.title.text = thisNote.title
        cell.noteDescription.text = thisNote.body
        cell.dateLabel.text = logic.dateFormatter.string(from: thisNote.dateCreated!)
        cell.colourBar.backgroundColor = .random()
        
        //SET THE COLOUR OF THE COLOURBAR
        if logic.trashData[indexPath.row].color != nil {
            let cellColour = logic.trashData[indexPath.row].color
            cell.colourBar.backgroundColor = cellColour as? UIColor
            
        } else {
            cellColour = .random()
            logic.trashData[indexPath.row].color = cellColour
            cell.colourBar.backgroundColor = cellColour
            logic.save()
        }
        return cell
    }
}

//MARK:- TABLEVIEW DELEGATE METHODS
extension TrashViewController {
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Create 'Restore' action to be shown while cell is swiped from the trail
        let restoreAction = UIContextualAction(style: .destructive, title: "Restore") { (_, _, CompeletionHandler) in
            // When restore is tapped do the following
            self.logic.restoreIndividual(indexPath: indexPath, tableView: tableView)
            CompeletionHandler(true)
            
        }
        // Change the colour of the restore button
        restoreAction.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        // Create configuration array for the buttons to show while the cell is swiped
        let configuration = UISwipeActionsConfiguration(actions: [restoreAction])
        // return the configuration
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //2. PASS THE NUMBER OF SELECTED ROWS TO THE GLOBAL 'SELECTEDROWS' OBJECT
        logic.selectedRows = tableView.indexPathsForSelectedRows
        if tableView.indexPathsForSelectedRows != nil {
            interface.optionsButton.isEnabled = true
        } else {
            interface.optionsButton.isEnabled = false
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //2. PASS THE NUMBER OF SELECTED ROWS TO THE GLOBAL 'SELECTEDROWS' OBJECT
        logic.selectedRows = tableView.indexPathsForSelectedRows
        if tableView.indexPathsForSelectedRows != nil {
            interface.optionsButton.isEnabled = true
        } else {
            interface.optionsButton.isEnabled = false
        }
    }
}

//MARK:- INTERFACE DELEGATE METHODS

extension TrashViewController: TrashInterfaceDelegate {
    func restoreTapped(_ helper: TrashInterFaceHelper) {
        print("From TrashViewController | \(#function) on line \(#line)")
        logic.restoreMany(tableView: tableView)
    }
    
    func eraseTapped(_ helper: TrashInterFaceHelper) {
        print("From TrashViewController | \(#function) on line \(#line)")
        // 1. Create an alert to confirm the deletion of the notes
        let alert = UIAlertController(title: "Erase selected notes" , message: "Selecting 'Yes' will erase selected notes permanently.", preferredStyle: .alert)
        // create the 'Yes' button
        let yesButton = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            // set the table to editing mode
            self.tableView.setEditing(false, animated: true)
            // change the properties of the barbuttons after clicking the 'Yes' Button
            self.setNavigationBarItems()
            // Call 'Erase' function with 'selection' property set to 'true' so that only selected objects are deleted permenantly
            self.logic.erase(selected: true, tableView: self.tableView)
        }
        let noButton = UIAlertAction(title: "No", style: .cancel) { (action) in
            // Revert the editing mode of the table
            self.tableView.setEditing(false, animated: true)
            // Set the properties of the barbuttons when 'No' is selected
            self.setNavigationBarItems()
            // Dismiss the alert
            self.dismiss(animated: true, completion: nil)
        }
        // 2. Add the buttons to the action
        alert.addAction(yesButton)
        alert.addAction(noButton)
        // 3. Present the alert when 'Erase' is pressed.
        self.present(alert, animated: true, completion: nil)
    }
    
    func eraseAllTapped(_ helper: TrashInterFaceHelper) {
        print("From TrashViewController | \(#function) on line \(#line)")
        // 1. Create the alert to show when 'Erase All' is tapped.
        let alert = UIAlertController(title: "Empty the trash?", message: "This action will erase all the notes in the trash permanently.", preferredStyle: .alert)
        // create the Erase button for the Alert
        let EraseButton = UIAlertAction(title: "Erase", style: .destructive) { (action) in
            // call the erase function with selection property set to 'false' to clear all the notes in trash.
            self.logic.erase(selected: false, tableView: self.tableView)
            //Navigate to the HomeView
            self.navigationController?.popToRootViewController(animated: true)
        }
        // create the cancel button for the allert
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        // 2. Add buttons to the alert
        alert.addAction(EraseButton)
        alert.addAction(cancelButton)
        // 3. Present the alert
        self.present(alert, animated: true, completion: nil)

    }

    func selectTapped(_ helper: TrashInterFaceHelper) {
        print("From TrashViewController | \(#function) on line \(#line)")
        tableView.setEditing(false, animated: true)
        tableView.setEditing(true, animated: true)
        interface.optionsButton.isEnabled = false
        navigationItem.setRightBarButtonItems([interface.doneButton, interface.optionsButton], animated: true)
    }
    
    func doneTapped(_ helper: TrashInterFaceHelper) {
        print("From TrashViewController | \(#function) on line \(#line)")
        tableView.setEditing(false, animated: true)
        setNavigationBarItems()
    }
}
