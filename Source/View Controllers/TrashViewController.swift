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
    
    //MARK:- INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        registerDelegates()
        setNavigationItems()
        tableViewUI()
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
    }
    
    private func setNavigationItems() {
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = nil
        navigationItem.title = "Trash"
        navigationItem.setRightBarButton(interface.selectButton, animated: true)
    }
    
    private func eraseAllPressed() {
        
        // 1. Create the alert to show when 'Erase All' is tapped.
        let alert = UIAlertController(title: "Erase All", message: "This action will erase all the notes in the trash permanently.", preferredStyle: .actionSheet)
        // create the Erase button for the Alert
        let EraseButton = UIAlertAction(title: "Erase", style: .destructive) { (action) in
            // call the erase function with selection property set to 'false' to clear all the notes in trash.
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

//MARK:- INTERFACE DELEGATE METHODS

extension TrashViewController: TrashInterfaceDelegate {
    
    func selectTapped(_ helper: TrashInterFaceHelper) {
        print("From TrashViewController | \(#function) on line \(#line)")
        tableView.setEditing(false, animated: true)
        tableView.setEditing(true, animated: true)
        navigationItem.setLeftBarButton(helper.optionsButton, animated: true)
        navigationItem.setRightBarButton(helper.doneButton, animated: true)
    }
    
    func optionsTapped(_ helper: TrashInterFaceHelper) {
        print("From TrashViewController | \(#function) on line \(#line)")
        let alert = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        
        //3. Show options to Restore or erase selected notes
        let restoreAction = UIAlertAction(title: "Restore", style: .default) { (action) in
            // set the table to editing mode
            self.tableView.setEditing(false, animated: true)
            // change the properties of the barbuttons after clicking the 'Yes' Button
            self.setNavigationItems()
            // Call the restore function to change the 'isTrash' property of the selected notes to false and reload the tableView
        }
        
        let eraseAction = UIAlertAction(title: "Erase", style: .destructive) { (action) in
            
            // 1. Create an alert to confirm the deletion of the notes
            let alert = UIAlertController(title: "Erase selected notes" , message: "Erase selected notes permanently?", preferredStyle: .alert)
            // create the 'Yes' button
            let yesButton = UIAlertAction(title: "Yes", style: .destructive) { (action) in
                // set the table to editing mode
                self.tableView.setEditing(false, animated: true)
                // change the properties of the barbuttons after clicking the 'Yes' Button
                self.setNavigationItems()
                // Call 'Erase' function with 'selection' property set to 'true' so that only selected objects are deleted permenantly
                
            }
            let noButton = UIAlertAction(title: "No", style: .cancel) { (action) in
                // Revert the editing mode of the table
                self.tableView.setEditing(false, animated: true)
                // Set the properties of the barbuttons when 'No' is selected
                self.setNavigationItems()
                // Dismiss the alert
                self.dismiss(animated: true, completion: nil)
            }
            // 2. Add the buttons to the action
            alert.addAction(yesButton)
            alert.addAction(noButton)
            // 3. Present the alert when 'Erase' is pressed.
            self.present(alert, animated: true, completion: nil)
            
        }
        let eraseAll = UIAlertAction(title: "Erase All", style: .destructive) { (action) in
            self.eraseAllPressed()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(restoreAction)
        alert.addAction(eraseAction)
        alert.addAction(eraseAll)
        alert.addAction(cancelAction)
        //3. Present the popup sheet
        self.present(alert, animated: true, completion: nil)
    }
    
    func doneTapped(_ helper: TrashInterFaceHelper) {
        print("From TrashViewController | \(#function) on line \(#line)")
        tableView.setEditing(false, animated: true)
        setNavigationItems()
    }
}
