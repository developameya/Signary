//
//  TrashInterfaceHelper.swift
//  Signary
//
//  Created by Ameya Bhagat on 10/06/21.
//

import UIKit

//MARK:- PROTOCOL
protocol TrashInterfaceDelegate {
    
    func selectTapped(_ helper: TrashInterFaceHelper)
    func optionsTapped(_ helper: TrashInterFaceHelper)
    func doneTapped(_ helper: TrashInterFaceHelper)
}

class TrashInterFaceHelper {
    //MARK:- PROPERTIES
    var delegate: TrashInterfaceDelegate?
    var selectButton: UIBarButtonItem!
    var optionsButton: UIBarButtonItem!
    var doneButton: UIBarButtonItem!
    
    //MARK:- INIT
    init() {
        registerButtons()
    }
    
    private func registerButtons() {
        selectButton = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectPressed))
        optionsButton = UIBarButtonItem(title: "Options", style: .plain, target: self, action: #selector(optionsTapped))
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
    }
    
    //MARK:- BUTTON INTERACTION METHODS
    @objc func selectPressed(_ sender: UIBarButtonItem!) {
        delegate?.selectTapped(self)
    }
    
    @objc func optionsTapped(_ sender: UIBarButtonItem!) {
        delegate?.optionsTapped(self)
    }
    
    @objc func donePressed(_ sender: UIBarButtonItem!) {
        delegate?.doneTapped(self)
    }
}

