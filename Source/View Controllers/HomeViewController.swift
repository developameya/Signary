//
//  HomeViewController.swift
//  Signary
//
//  Created by Ameya Bhagat on 10/06/21.
//

import UIKit

class HomeViewController: UITableViewController {
    //MARK:- PROPERTIES
    //THIS IS TEMPORARY PLACEHOLDER DATA
    private let data = notesData
    private let searchController = UISearchController(searchResultsController: nil)
    private let interface = HomeInterfaceHelper()
    
    //MARK:- INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        registerDelegates()
        tableViewUI()
        searchUI()
        NavigationBarUI()
    }
    
  private func registerDelegates() {
        interface.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        searchController.searchBar.delegate = self
    }
    
    //MARK:-    USER INTERFACE METHODS
    
    private func tableViewUI() {
        
        //CHANGE THE SEPARATOR BETWEEN TWO CELLS TO SINGLELINE
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = UIColor(named: "TableBackground")
        //SET THE HEIGHT OF THE ROW IN TABLEVIEW EQUAL TO THE THE CUSTOM CELL
        tableView.rowHeight = 125
        //ALLOW SELECTION OF MULTIPLE CELLS WHILE TABLEVIEW IS IN EDITING MODE
        tableView.allowsMultipleSelectionDuringEditing = true
        //REGISTER THE CUSTOM CELL TO THIS TABLEVIEW
        tableView.register(UINib(nibName: cellConstants.nibName, bundle: nil), forCellReuseIdentifier: cellConstants.indetifier)
        //REGSITER THE CUSTOM HEADER TO THIS TABLEVIEW
        let headerNib = UINib.init(nibName: "SectionHeaderView", bundle: Bundle.main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "SectionHeaderView")
    }
    
    private func searchUI() {

        //DO NOT OBSCURE THE BACKGROUND WHILE SEARCHBAR IS ACTIVE
        searchController.obscuresBackgroundDuringPresentation = false
        //SET THE PLACEHOLDER
        searchController.searchBar.placeholder = "Find Notes"
        //HIDE THE CANCEL BUTTON WHILE THE SEARCH CONTROLLER IS NOT ACTIVE
        searchController.searchBar.setShowsCancelButton(false, animated: true)
        //ADD THE SEARCH CONTROLLER TO THE NAVIGATION CONTROLLER
        navigationItem.searchController = searchController
        //DO NOT COVER THIS VIEW CONTROLLER WHILE IT'S DECENDANTS ARE ACTIVE
        definesPresentationContext = true
    }
    
    private func NavigationBarUI() {
        setNavigationItems()
        navigationController?.navigationBar.tintColor = UIColor(named: "Accent Colour")
        navigationController?.navigationBar.prefersLargeTitles = true
        let defaultAppearance = UINavigationBarAppearance()
        defaultAppearance.configureWithTransparentBackground()
        navigationController?.navigationBar.scrollEdgeAppearance = defaultAppearance
    }
    
   private func sortUI() {
        //1. CREATE AN ALERT FOR SORT BY
        let alert = UIAlertController(title: "Sort By...", message: nil, preferredStyle: .actionSheet)
        //2.CREATE DATE CREATED BUTTON
        let dateCreated = UIAlertAction(title: "Date Created", style: .default) { (action) in
            
            
            self.dismiss(animated: true, completion: nil)
        }
        //2.CREATE DATE MODIFIED BUTTON
        let dateModified = UIAlertAction(title: "Date Modified", style: .default) { (action) in
            
            self.dismiss(animated: true, completion: nil)
        }
        //2.CREATE SORT BY NAME  BUTTON
        let sortName = UIAlertAction(title: "Title", style: .default) { (action) in
            
            self.dismiss(animated: true, completion: nil)
        }
        //3.CREATE CANCEL BUTTON
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //4.ADD ALL THE BUTTONS TO THE ALERT
        alert.addAction(sortName)
        alert.addAction(dateModified)
        alert.addAction(dateCreated)
        alert.addAction(cancelButton)
        
        //5.PRESENT THE ALERT
        self.present(alert, animated: true, completion: nil)
    }
    
    func setNavigationItems() {
        navigationItem.setRightBarButtonItems([interface.addButton, interface.selectButton], animated: true)
        navigationItem.setLeftBarButtonItems([interface.moreButton], animated: true)
        searchController.searchBar.isHidden = false
        tableView.setEditing(false, animated: true)
    }
}

// MARK: - TABLEVIEW DELEGATE METHODS

extension HomeViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueConstants.tapToEditor, sender: self)
    }
}
// MARK: - TABLEVIEW DATA SOURCE METHODS
extension HomeViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellConstants.indetifier, for: indexPath) as! listViewCell
        
        let cellData = notesData[indexPath.row]
        cell.noteDescription.text = cellData.body
        highlightFirstLine(cell: cell)
        cell.dateLabel.text = "0"
        cell.colourBar.backgroundColor = .cyan
        
        return cell
    }
    
    private func highlightFirstLine(cell: listViewCell, font: UIFont = UIFont.preferredFont(forTextStyle: .headline)) {
        
        let textAsNSString = cell.noteDescription.text! as NSString
        let lineBreakRange = textAsNSString.range(of: "\n")
        let boldRange: NSRange
        let newAttributedText = NSMutableAttributedString(attributedString: cell.noteDescription.attributedText!)
        if lineBreakRange.location < textAsNSString.length {
            boldRange = NSRange(location: 0, length: lineBreakRange.location)
        } else {
            boldRange = NSRange(location: 0, length: textAsNSString.length)
        }
        newAttributedText.addAttribute(NSAttributedString.Key.font, value: font, range: boldRange)
        cell.noteDescription.attributedText = newAttributedText
    }
}

//MARK:- SEARCHBAR DELEGATE METHODS
extension HomeViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //SHOW THE CANCEL BUTTON WHEN THE SEARCHBAR IS ACTIVE
        searchController.searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //MAKE THE SEARCHBAR ACTIVE AND SET THE TABLEVIEW ACCORDINGLY
        searchController.searchBar.setShowsCancelButton(false, animated: true)
//        self.tableView.reloadData()
    }
}

//MARK:- INTERFACE DELEGATE METHODS
extension HomeViewController: HomeInterfaceHelperDelegate {
    func addTapped(_ helper: HomeInterfaceHelper) {
        print("From HomeViewController | \(#function) on line \(#line)")
    }
    
    func selectTapped(_ helper: HomeInterfaceHelper) {
        print("From HomeViewController | \(#function) on line \(#line)")
        //1. Hide the searchController
        searchController.searchBar.isHidden = true
        //2. Change the mode to editing of TableView
        tableView.allowsSelection = false
        tableView.setEditing(true, animated: true)
        //3. change the barButtonItems
        helper.trashbutton.isEnabled = false
        navigationItem.setRightBarButtonItems([helper.donebutton], animated: true)
        navigationItem.setLeftBarButtonItems([helper.trashbutton], animated: true)
    }
    
    func moreTapped(_ helper: HomeInterfaceHelper) {
        print("From HomeViewController | \(#function) on line \(#line)")
        //1. CREATE AN ALERT WITH TITLE 'OPTIONS
        let alert = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        //2. CREATE 'SORT BY' BUTTON
        let sortBy = UIAlertAction(title: "Sort By...", style: .default) { (action) in
            //PRESENT SORTING OPTIONS
            self.sortUI()
            
        }
        //3.CREATE TRASH BUTTON
        let trashButton = UIAlertAction(title: "Trash Bin", style: .destructive) { (action) in
            //PRESENT TRASH VIEW
            self.performSegue(withIdentifier: segueConstants.trash, sender: self)
        }
        let settings = UIAlertAction(title: "Settings", style: .default) { (action) in
            
        }
        //4.CREATE CANCEL BUTTON
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //5.ADD ALL THE BUTTONS TO THE ACTIONSHEET
        alert.addAction(sortBy)
        alert.addAction(settings)
        alert.addAction(trashButton)
        alert.addAction(cancelButton)
        //6.PRESENT THE ALERT
        present(alert, animated: true, completion: nil)

    }
    
    func trashTapped(_ helper: HomeInterfaceHelper) {
        print("From HomeViewController | \(#function) on line \(#line)")
    }
    
    func doneTapped(_ helper: HomeInterfaceHelper) {
        print("From HomeViewController | \(#function) on line \(#line)")
        tableView.setEditing(false, animated: true)
        tableView.allowsSelection = true
        setNavigationItems()
    }
}
