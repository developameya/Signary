//
//  UIHelper.swift
//  Signary
//
//  Created by Ameya Bhagat on 10/06/21.
//

import UIKit

//MARK:- PROTOCOL
protocol HomeInterfaceHelperDelegate {
    func addTapped(_ helper: HomeInterfaceHelper)
    func selectTapped(_ helper: HomeInterfaceHelper)
    func trashTapped(_ helper: HomeInterfaceHelper)
    func doneTapped(_ helper: HomeInterfaceHelper)
}

class HomeInterfaceHelper {
    //MARK:- PROPERTIES
    var delegate: HomeInterfaceHelperDelegate?
    var addButton: BarButton!
    var selectButton: BarButton!
    var trashbutton: BarButton!
    var donebutton: BarButton!
    
    
    //MARK:- INIT
    init() {
        registerBarButtons()

    }

   private func registerBarButtons() {
        addButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(addButtonPressed))
        selectButton = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectButtonPressed))

        trashbutton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashPressed))
        trashbutton.tintColor = .systemRed
        trashbutton.isEnabled = false
        donebutton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
    }
    
    //MARK:- BUTTON INTERACTION METHODS
    @objc func addButtonPressed(sender:BarButton!) {
        delegate?.addTapped(self)
    }
    
    @objc func selectButtonPressed(sender:BarButton!) {
        delegate?.selectTapped(self)
    }
    
    @objc func trashPressed(sender:BarButton!) {
        delegate?.trashTapped(self)
    }
    
    @objc func doneButtonPressed(sender:BarButton!) {
        delegate?.doneTapped(self)
    }
}

