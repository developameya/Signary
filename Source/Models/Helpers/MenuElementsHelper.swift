//
//  MenuElements.swift
//  Signary
//
//  Created by Ameya Bhagat on 20/07/21.
//

import UIKit

protocol MenuElementsDelegate {
    func menuTapped(_ identifier: String)
    func fontsMenuTapped(_ identifier: String)
}

/// Use this struct to construct UIMenu elements either with  or without SFSymbols.
///
/// Use the 'identifier' parameter in the 'menuButtonTapped' delegate method to pass actions to each of the item in the menu.
///
/// The identifer can be switched according to the name of the items in the menu.
struct MenuElementsHelper {
    //MARK:- PROPETIES
    var delegate: MenuElementsDelegate?
    
    /// This method creates menu actions for UIMenu with SFSymbols.
    /// - Parameter menuItems: Pass a dictionary where the key is the name of the menu item and the value is the SFSymbol for the item.
    /// - Returns: The method will return an array of UIElements which can be passed to UIMenu as its 'children'.
    func createActionsWithSymbols(from menuItems: [String : String]) -> [UIMenuElement] {
        
        let orderedMenuItems = menuItems.sorted(by:{$0.value < $1.value})
        var elements = [UIMenuElement]()
        
        for (itemName, itemSymbol) in orderedMenuItems {
            let customIdentifier = UIAction.Identifier(itemName)
            let action = UIAction(title: itemName, image: .init(systemName: itemSymbol), identifier: customIdentifier) { _ in
                delegate?.menuTapped(customIdentifier.rawValue)
            }
            elements.append(action)
        }
        return elements
    }
    
    /// This method creates menu actions for UIMenu.
    /// - Parameter menuItems: Pass an array with the names of the items to be shown in the UIMenu
    /// - Returns: The method will return an array of UIElements which can be passed to UIMenu as its 'children'.
    func createActions(from menuItems: [String]) -> [UIMenuElement] {
        var elements = [UIMenuElement]()
        
        for itemName in menuItems {
            let customIdentifier = UIAction.Identifier(itemName)
            let action = UIAction(title: itemName, identifier: customIdentifier) { _ in
                delegate?.fontsMenuTapped(itemName)
            }
            elements.append(action)
        }
        return elements
    }
}

extension MenuElementsDelegate {
    
    func menuTapped(_ identifier: String) {
        
    }
    
    func fontsMenuTapped(_ identifier: String) {
        
    }
}
