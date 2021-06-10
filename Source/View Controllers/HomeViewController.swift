//
//  HomeViewController.swift
//  Signary
//
//  Created by Ameya Bhagat on 10/06/21.
//

import UIKit

class HomeViewController: UITableViewController {
    //THIS IS TEMPORARY PLACEHOLDER DATA
    private var data = notesData
    private var searchController = UISearchController(searchResultsController: nil)
    private var helper = UIHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerDelegates()
        tableViewUI()
        searchUI()
        NavigationBarUI()
    }
    
    func registerDelegates() {
        helper.delegate = self
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
    
    func setNavigationItems() {
        navigationItem.setRightBarButtonItems([helper.addButton, helper.selectButton], animated: true)
        navigationItem.setLeftBarButtonItems([helper.moreButton], animated: true)
        searchController.searchBar.isHidden = false
        tableView.setEditing(false, animated: true)
    }
    
    // MARK: - TABLEVIEW DATA SOURCE METHODS
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellConstants.indetifier, for: indexPath) as! listViewCell
        
        let cellData = notesData[indexPath.row]
        cell.noteTitle.text = cellData.title
        cell.noteDescription.text = cellData.body
        cell.dateLabel.text = "0"
        cell.colourBar.backgroundColor = .cyan
        
        return cell
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

//MARK:- UIHELPER DELEGATE METHODS
extension HomeViewController: UIHelperDelegate {
    func addTapped(_ helper: UIHelper) {
        print("From HomeViewController | \(#function) on line \(#line)")
    }
    
    func selectTapped(_ helper: UIHelper) {
        print("From HomeViewController | \(#function) on line \(#line)")
    }
    
    func moreTapped(_ helper: UIHelper) {
        print("From HomeViewController | \(#function) on line \(#line)")
    }
    func trashTapped(_ helper: UIHelper) {
        print("From HomeViewController | \(#function) on line \(#line)")
    }
    func doneTapped(_ helper: UIHelper) {
        print("From HomeViewController | \(#function) on line \(#line)")
    }
}
