//
//  TrashInterfaceHelper.swift
//  Signary
//
//  Created by Ameya Bhagat on 10/06/21.
//

import UIKit

typealias Action = UIAction
typealias Menu = UIMenu
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
    var selectButton: BarButton!
    var doneButton: BarButton!
    var eraseAllButton: BarButton!
    var optionsButton: BarButton!
    let dataLogic = Logic()
    
    //MARK:- INIT
    init() {
        registerButtons()
    }
    
    private func registerButtons() {
        selectButton = BarButton(title: "Select", style: .plain, target: self, action: #selector(selectPressed))
        doneButton = BarButton(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        eraseAllButton = BarButton(image: .init(systemName: "trash.slash.fill"), style: .plain, target: self, action: #selector(eraseAllPressed))
        
        let restoreAction = Action(title:"Restore", image:.init(systemName: "arrowshape.turn.up.backward.fill")) { _ in
            print("Restore pressed")
            self.delegate?.restoreTapped(self)
            
        }
        let eraseAction = Action(title:"Erase", image:.init(systemName: "xmark.bin.fill"), attributes: .destructive) { _ in
            print("erase pressed")
            self.delegate?.eraseTapped(self)
        }

        let menuElements = [restoreAction, eraseAction]
        optionsButton = BarButton(image: .init(systemName: "ellipsis.circle"), menu: Menu(title: "Options", children: menuElements))
    }
    
    //MARK:- BUTTON INTERACTION METHODS
    @objc func selectPressed(_ sender: BarButton!) {
        delegate?.selectTapped(self)
    }
    
    @objc func donePressed(_ sender: BarButton!) {
        delegate?.doneTapped(self)
    }
    
    @objc func eraseAllPressed(_ sender: BarButton!) {
        delegate?.eraseAllTapped(self)
    }
}

