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
    func doneTapped(_ helper: TrashInterFaceHelper)
    func eraseAllTapped(_ helper: TrashInterFaceHelper)
    func restoreTapped(_ helper: TrashInterFaceHelper)
    func eraseTapped(_ helper: TrashInterFaceHelper)
}

class TrashInterFaceHelper {
    //MARK:- PROPERTIES
    var delegate: TrashInterfaceDelegate?
    var selectButton: UIBarButtonItem!
    var doneButton: UIBarButtonItem!
    var eraseAllButton: UIBarButtonItem!
    var optionsButton: UIBarButtonItem!
    let dataLogic = Logic()
    
    //MARK:- INIT
    init() {
        registerButtons()
    }
    
    private func registerButtons() {
        selectButton = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectPressed))
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        eraseAllButton = UIBarButtonItem(image: .init(systemName: "trash.slash.fill"), style: .plain, target: self, action: #selector(eraseAllPressed))
        
        let restoreAction = UIAction(title:"Restore", image:.init(systemName: "arrowshape.turn.up.backward.fill")) { _ in
            print("Restore pressed")
            self.delegate?.restoreTapped(self)
            
        }
        let eraseAction = UIAction(title:"Erase", image:.init(systemName: "xmark.bin.fill"), attributes: .destructive) { _ in
            print("erase pressed")
            self.delegate?.eraseTapped(self)
        }

        let menuElements = [restoreAction, eraseAction]
        optionsButton = UIBarButtonItem(image: .init(systemName: "ellipsis.circle"), menu: UIMenu(title: "Options", children: menuElements))
    }
    
    //MARK:- BUTTON INTERACTION METHODS
    @objc func selectPressed(_ sender: UIBarButtonItem!) {
        delegate?.selectTapped(self)
    }
    
    @objc func donePressed(_ sender: UIBarButtonItem!) {
        delegate?.doneTapped(self)
    }
    
    @objc func eraseAllPressed(_ sender: UIBarButtonItem!) {
        delegate?.eraseAllTapped(self)
    }
}

