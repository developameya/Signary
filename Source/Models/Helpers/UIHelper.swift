//
//  UIHelper.swift
//  Signary
//
//  Created by Ameya Bhagat on 10/06/21.
//

import UIKit

protocol UIHelperDelegate {
    func addTapped(_ helper: UIHelper)
    func selectTapped(_ helper: UIHelper)
    func moreTapped(_ helper: UIHelper)
    func trashTapped(_ helper: UIHelper)
    func doneTapped(_ helper: UIHelper)
}

class UIHelper {
    var delegate: UIHelperDelegate?
    var addButton: UIBarButtonItem!
    var selectButton: UIBarButtonItem!
    var moreButton: UIBarButtonItem!
    var trashbutton: UIBarButtonItem!
    var donebutton: UIBarButtonItem!
    
    init() {
        registerBarButtons()
        
    }
    
    func registerBarButtons() {
        addButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(addButtonPressed))
        selectButton = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectButtonPressed))
        moreButton = UIBarButtonItem(title: "More", style: .plain, target: self, action: #selector(moreButtonPressed))
        trashbutton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashPressed))
        trashbutton.tintColor = .systemRed
        trashbutton.isEnabled = false
        donebutton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
    }
    
    //MARK:- BUTTON INTERACTION METHODS
    @objc func addButtonPressed(sender:UIBarButtonItem!) {
        delegate?.addTapped(self)
    }
    
    @objc func selectButtonPressed(sender:UIBarButtonItem!) {
        delegate?.selectTapped(self)
    }
    
    @objc func moreButtonPressed(sender:UIBarButtonItem!) {
        delegate?.moreTapped(self)
    }
    
    @objc func trashPressed(sender:UIBarButtonItem!) {
        delegate?.trashTapped(self)
    }
    
    @objc func doneButtonPressed(sender:UIBarButtonItem!) {
        delegate?.doneTapped(self)
    }
}

extension UIHelperDelegate {
    func addTapped(_ helper: UIHelper) {}
    func selectTapped(_ helper: UIHelper) {}
    func moreTapped(_ helper: UIHelper) {}
    func trashTapped(_ helper: UIHelper) {}
    func doneTapped(_ helper: UIHelper) {}
}
