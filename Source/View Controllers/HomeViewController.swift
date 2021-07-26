//
//  HomeViewController.swift
//  Signary
//
//  Created by Ameya Bhagat on 10/06/21.
//

import UIKit
import CoreData

class HomeViewController: UITableViewController {
    //MARK:- PROPERTIES
    private var logic = Logic()
    private var cellData = Note()
    private let searchController = UISearchController(searchResultsController: nil)
    private let interface = HomeInterfaceHelper()
    private var menuElements = MenuElementsHelper()
    private var cellColour: UIColor?
    private var isCollapsed: Bool?
    let sectionHeaderHeight: CGFloat = 34
    var currentSection:Int?
    
    //MARK:- INIT
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //CLEAR THE CELL SELECTION BEFORE THIS VIEW IS PRESENTED
        clearsSelectionOnViewWillAppear = true
        NavigationBarUI()
        logic.dataFilter()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerDelegates()
        logic.dataFilter()
        tableViewUI()
        NavigationBarUI()
        isCollapsed = UserDefaults.standard.bool(forKey: "isPinnedCollapsed")
        //TO CHECK THE DATABASE LOCATION ON THE COMPUTER, UNCOMMENT THIS LINE
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //ATTACHING THE SEARCHCONTOLLER HERE WILL HIDE THE SEARCHBAR BY DEFAULT
        searchUI()
    }
    
    private func registerDelegates() {
        interface.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        searchController.searchBar.delegate = self
        menuElements.delegate = self
    }
    
    //MARK:-    USER INTERFACE METHODS
    
    private func tableViewUI() {
        
        //CHANGE THE SEPARATOR BETWEEN TWO CELLS TO SINGLELINE
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = UIColor(named: K.colours.background)
        //SET THE HEIGHT OF THE ROW IN TABLEVIEW EQUAL TO THE THE CUSTOM CELL
        tableView.rowHeight = 125
        //ALLOW SELECTION OF MULTIPLE CELLS WHILE TABLEVIEW IS IN EDITING MODE
        tableView.allowsMultipleSelectionDuringEditing = true
        //REGISTER THE CUSTOM CELL TO THIS TABLEVIEW
        tableView.register(UINib(nibName: cellConstants.nibName, bundle: nil), forCellReuseIdentifier: cellConstants.indetifier)
        //REGSITER THE CUSTOM HEADER TO THIS TABLEVIEW
        let headerNib = UINib.init(nibName: K.sectionHeaderIdentifier, bundle: Bundle.main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: K.sectionHeaderIdentifier)
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
        navigationItem.title = K.appTitle
        navigationController?.navigationBar.tintColor = UIColor(named: K.accentColor)
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
            self.logic.dataSort(query: K.SortBy.dateCreated, asceding: false)
            self.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
        //2.CREATE DATE MODIFIED BUTTON
        let dateModified = UIAlertAction(title: "Date Modified", style: .default) { (action) in
            self.logic.dataSort(query: K.SortBy.dateModified, asceding: false)
            self.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
        //2.CREATE SORT BY NAME  BUTTON
        let sortName = UIAlertAction(title: "Title", style: .default) { (action) in
            self.logic.dataSort(query: K.SortBy.title, asceding: true)
            self.tableView.reloadData()
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
        
        let menuItems = ["Sort":"arrow.up.arrow.down", "Trash":"xmark.bin.fill"]
        let elements = menuElements.createActionsWithSymbols(from: menuItems)
        let moreButton = UIBarButtonItem(image: .init(systemName: "ellipsis.circle"), menu: UIMenu(title: "Options",children: elements))
        
        navigationItem.setRightBarButtonItems([interface.addButton, interface.selectButton], animated: true)
        navigationItem.setLeftBarButtonItems([moreButton], animated: true)
        searchController.searchBar.isHidden = false
        tableView.setEditing(false, animated: true)
    }
}

//MARK:- NAVIGATION METHODS
extension HomeViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case segueConstants.newEditor:
            //            prepare the EditorViewController for new note
            let destinationVC = segue.destination as! EditorViewController
            destinationVC.id = logic.data.last?.uuid
            
        case segueConstants.cellToEditor:
            //         prepare the EditorViewController for the selected note and load all the relevant data
            let destinationVC = segue.destination as! EditorViewController
            destinationVC.id = logic.selectedNote(tableView: tableView)
        default:
            return
        }
    }
}
// MARK: - TABLEVIEW DELEGATE METHODS

extension HomeViewController {
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //WHEN USER SWIPES THE CELL TO THE LEFT, DO THE FOLLWING
        //1. CREATE THE DELETE BUTTON
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            //CALL THE 'moveOneToTrash' FUNCTION AND PASS THE INDEXPATH OF THE CURRENT CELL
            self.logic.moveOneToTrash(indexPath: indexPath, tableView: tableView)
            
        }
        
        let pinAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            // CHANGE PIN STATUS OF THE NOTE
            self.logic.setPin(indexPath: indexPath, tableView: tableView, state: self.isCollapsed!)
        }
        
        //2.SET THE IMAGE OF THE BUTTON TO 'trash'
        deleteAction.image = UIImage(systemName: "trash")
        
        if let tableSection = TableSection(rawValue: indexPath.section) {
            switch tableSection {
            case .unpinned:
                pinAction.image = UIImage(systemName: "pin.fill")
                pinAction.title = "Pin"
            case .pinned:
                pinAction.image = UIImage(systemName: "pin.slash.fill")
                pinAction.title = "Unpin"
            default:
                break
            }
        }
        //3.CHANGE THE BACKGROUND COLOUR OF THE BUTTON
        deleteAction.backgroundColor = .systemRed
        pinAction.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        //4.ADD THIS BUTTON TO THE ARRAY WHICH IS SHOWN AT THE TRAIL
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, pinAction])
        //5.RETURN THE ARRAY OF BUTTONS
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            //PASS THE NUMBER OF SELECTED ROWS TO THE GLOBAL 'SELECTEDROWS' OBJECT
            logic.selectedRows = tableView.indexPathsForSelectedRows
            //CHANGE THE STATE OF THE 'TRASH BUTTON' AS PER THE CONTENT OF THE 'SELECTEDROWS' PROPERTY
            if logic.selectedRows?.count != nil {
                interface.trashbutton.isEnabled = true
            } else {
                interface.trashbutton.isEnabled = false
            }
            
        } else {
            //IF THE TABLEVIEW IS NOT IN EDITING MODE, WHEN A CELL IS SELECTED, SEGUE TO THE EDITOR
            performSegue(withIdentifier: segueConstants.cellToEditor, sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            //2. PASS THE NUMBER OF SELECTED ROWS TO THE GLOBAL 'SELECTEDROWS' OBJECT
            logic.selectedRows = tableView.indexPathsForSelectedRows
            //3. CHANGE THE STATE OF THE 'TRASH BUTTON' AS PER THE CONTENT OF THE 'SELECTEDROWS' PROPERTY
            if logic.selectedRows?.count != nil {
                interface.trashbutton.isEnabled = true
            } else {
                interface.trashbutton.isEnabled = false
            }
        }
    }
}
// MARK: - TABLEVIEW DATA SOURCE METHODS
extension HomeViewController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HomeViewSectionHeader()
        return header.view(self, tableView, section, isCollapsed!)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //1. PASS THE CURRENT NUMBER OF SECTION FOR RAWVALUE OF 'TABLESECITON' ENUM.
        //2. SET THE RETURNED CASE OF THE TABLESECTION TO 'TABLESECTION' CONSTANT
        //3. PASS THIS 'TABLESECTION' CONSTANT AS VALUE TO THE 'COMBINEDDATA' ARRAY
        //4. RETURN THE ARRAY LOADED TO THE CORRESPONDING CASE OF 'COMBINEDDATA' LOADED IN THE 'SORTDATA' FUNCTION AND RETURN 'SECITONHEADERHEIGHT' CONSTANT DEFINED EARLIER.
        //5. IF THERE IS NO OBJECT IN THE CASE, THEN RETURN '0'
        if let tableSection = TableSection(rawValue: section), let data = logic.combinedData[tableSection], data.count > 0 {
            return sectionHeaderHeight
        }
        return 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.total.rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //SET THE NUMBER OF ROWS IN SECTION
        //1. PASS THE CURRENT NUMBER OF SECTION FOR RAWVALUE OF 'TABLESECITON' ENUM.
        //2. SET THE RETURNED CASE OF THE TABLESECTION TO 'TABLESECTION' CONSTANT
        //3. PASS THIS 'TABLESECTION' CONSTANT AS VALUE TO THE 'COMBINEDDATA' ARRAY
        //4. RETURN THE ARRAY LOADED TO THE CORRESPONDING CASE OF 'COMBINEDDATA' LOADED IN THE 'SORTDATA' FUNCTION AND RETURN THE COUNT OF THE OBJECTS IN THE ARRAY AS 'NUMBER OF ROWS' IN THE RIGHT SECTION.
        //5. IF THERE IS NO OBJECT IN THE CASE, THEN RETURN '0'
        if let tableSection = TableSection(rawValue: section), let data = logic.combinedData[tableSection] {
            
            if isCollapsed == false && data == logic.combinedData[.pinned] {
                return data.count
            } else if isCollapsed == true && data == logic.combinedData[.pinned]  {
                return 0
            } else {
                return data.count
            }
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellConstants.indetifier, for: indexPath) as! listViewCell
        if let tableSection = TableSection(rawValue: indexPath.section), let data = logic.combinedData[tableSection]?[indexPath.row] {
            cellData = data
        }
        //SET THE TITLE OF THE CELL
        cell.title.text = cellData.title
        //SET THE DESCRIPTION TO THE BODY OF THE NOTE
        cell.noteDescription.text = cellData.body
        //SHOW THE NOTE CREATED
        cell.dateLabel.text = logic.dateFormatter.string(from: cellData.dateCreated!)
        //SET THE COLOUR OF THE COLOURBAR
        if cellData.color != nil {
            cellColour = cellData.color as? UIColor
            cell.colourBar.backgroundColor = cellColour
        } else {
            cellColour = .random()
            cellData.color = cellColour
            cell.colourBar.backgroundColor = cellColour
            logic.save()
        }
        
        if cellData.uuid != nil {
            let noteID = UUID()
            cellData.uuid = noteID.uuidString
            logic.save()
        }
        return cell
    }
}

//MARK:- SEARCHBAR DELEGATE METHODS
extension HomeViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //SHOW THE CANCEL BUTTON WHEN THE SEARCHBAR IS ACTIVE
        searchController.searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let query = searchController.searchBar.text!
        if query.count == 0 {
            //WHEN THERE IS NO TEXT IN SEARCH BAR RETURN THE TABLEVIEW TO IT'S PREVIOUS STATE
            logic.dataSort(query: K.SortBy.dateModified, asceding: false)
            tableView.reloadData()
            
        } else {
            //IF THERE IS TEXT IN SEARCHBAR, QUERY THE COREDATA WITH THE STRING IN THE SEARCHBAR
            let request: NSFetchRequest<Note> = Note.fetchRequest()
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR body CONTAINS[cd] %@", query, query)
            request.predicate = predicate
            
            logic.sortSearch(query: K.SortBy.title, ascending: true, request: request)
            
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //MAKE THE SEARCHBAR ACTIVE AND SET THE TABLEVIEW ACCORDINGLY
        searchController.searchBar.setShowsCancelButton(false, animated: true)
        logic.dataSort(query: K.SortBy.dateModified, asceding: false)
        tableView.reloadData()
    }
}

//MARK:- INTERFACE DELEGATE METHODS
extension HomeViewController: HomeInterfaceHelperDelegate {
    func addTapped(_ helper: HomeInterfaceHelper) {
        print("From HomeViewController | \(#function) on line \(#line)")
        //CREATE A NEW OBJECT FROM NOTE CLASS FROM COREDATA
        let newNote = Note(context: logic.managedContext!)
        //CREATE NEW ID
        let uuid = UUID()
        let id = uuid.uuidString
        //SET THE ID PROPERTY
        newNote.uuid = id
        //SET THE TITLE TO EMPTY STRING
        newNote.title =  ""
        //SET THE BODY TO EMPTY STRING
        newNote.body = ""
        //SET THE DATES TO THE CURRENT DATE AND TIME
        newNote.dateCreated = Date()
        newNote.dateModified = Date()
        //SET THE COLOUR FOR THE COLOURBAR
        newNote.color = UIColor.random()
        //APPEND THIS NEW NOTE TO THE NOTEARRAY
        logic.attachToDataArray(newNote)
        //SEGUE TO THE EDITOR
        performSegue(withIdentifier: segueConstants.newEditor, sender: self)
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
    
    func trashTapped(_ helper: HomeInterfaceHelper) {
        print("From HomeViewController | \(#function) on line \(#line)")
        //2. PRESENT AN ALERT TO CONFIRM IF THE SELECTED NOTES ARE TO BE TRASHED
        let alert = UIAlertController(title: "Send to trash", message: "The selected notes can be recovered from the trash bin.", preferredStyle: .alert)
        //3. CREATE YES BUTTON
        let yesButton = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            self.setNavigationItems()
            self.logic.moveManyToTrash(tableView: self.tableView)
        }
        //4.CREATE NO BUTTON
        let noButton = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        //5.ADD THE BUTTONS TO THE ALERT
        alert.addAction(yesButton)
        alert.addAction(noButton)
        
        //6.PRESENT THE ALERT
        self.present(alert, animated: true, completion: nil)
    }
    
    func doneTapped(_ helper: HomeInterfaceHelper) {
        print("From HomeViewController | \(#function) on line \(#line)")
        tableView.setEditing(false, animated: true)
        tableView.allowsSelection = true
        setNavigationItems()
    }
}

//MARK:- SectionHeaderViewDelegate
extension HomeViewController: SectionHeaderViewDelegate {
    
    func toggleSection(_ header: SectionHeaderView) {
        
        let section = 0
        var indexPaths = [IndexPath]()
        
        if let tableSection = TableSection(rawValue: section),
           let data = logic.combinedData[tableSection]?.indices {
            for row in data {
                let indexPath = IndexPath(row: row, section: section)
                indexPaths.append(indexPath)
            }
        }
        guard let safeBool = isCollapsed else {fatalError()}
        let collapsed = safeBool
        isCollapsed = !collapsed
        header.setExpansion(isCollapsed: isCollapsed!)
        UserDefaults.standard.setValue(isCollapsed, forKey: "isPinnedCollapsed")
        isCollapsed = UserDefaults.standard.bool(forKey: "isPinnedCollapsed")
        
        if isCollapsed! {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
    }
    
    func toggleHeaderRotation(_ header: SectionHeaderView) {
        print("SectionHeaderViewDelegate Method | \(#function) on line \(#line) | \(String(describing: isCollapsed!))")
    }
}

//MARK:- MENU ELEMENTS DELEGATE METHODS
extension HomeViewController: MenuElementsDelegate {

    
    func menuTapped(_ identifier: String) {
        switch identifier {
        case "Sort":
            sortUI()
        case "Settings":
            print("Settings")
        case "Trash":
            performSegue(withIdentifier: segueConstants.trash, sender: self)
        default:
            break
        }
    }
}
