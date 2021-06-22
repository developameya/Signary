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
}

class TrashInterFaceHelper {
    //MARK:- PROPERTIES
    var delegate: TrashInterfaceDelegate?
    var selectButton: UIBarButtonItem!
    var doneButton: UIBarButtonItem!
    
    //MARK:- INIT
    init() {
        registerButtons()
    }
    
    private func registerButtons() {
        selectButton = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectPressed))

        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
    }
    
    //MARK:- BUTTON INTERACTION METHODS
    @objc func selectPressed(_ sender: UIBarButtonItem!) {
        delegate?.selectTapped(self)
    }
    
    @objc func donePressed(_ sender: UIBarButtonItem!) {
        delegate?.doneTapped(self)
    }
}

