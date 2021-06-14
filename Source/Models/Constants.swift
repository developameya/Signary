//
//  Constants.swift
//  Notey 2.0
//
//  Created by Ameya Bhagat on 07/10/20.
//  Copyright © 2020 Ameya Bhagat. All rights reserved.
//

import Foundation

/// Use this struct to find constants for commonly used Strings
public struct K {
    
//    static let dataModel = "Notey_2_0"
//    static let dataModelDebug = "Notey_2_0_debug"
    
    /// This struct contains constants for strings of cell indentifiers
    struct Cell {
        static let nibName = "listViewCell"
        static let indetifier = "ReusableCell"
    }
    
    /// This struct contains string identifiers for 'Segues'
    struct Segue {
        static let newEditor = "newEditor"
        static let cellToEditor = "cellToEditor"
        static let trash = "ToTrash"
        static let settings = "toSettings"
        static let dimissBio = "dismissBioMetrics"
        static let toBiometricView = "toBiometricsView"
        static let speech = "toSpeechView"
        static let editorSettings = "fromEditorToSettings"
    }
    
    /// This struct contains string identifiers for 'Storyboards'
    struct storyboard {
        static let biometricView = "biometricView"
        static let homeView = "homeView"
    }
    
    /// This struct contains string identifiers for sort descriptors
    struct SortBy {
        static let dateCreated = "dateCreated"
        static let dateModified = "dateModified"
        static let title = "title"
    }
    
    struct features {
        
        static let firstLaunch = "If everything goes as planned, you should be able to see this!\n\nThere's no More textField but one giant canvas to type on!\n-- From now on the first line of the note will be automatically set as the title of the note.\n\nBut what about the titles of my previous notes?\n-- They are still there, though the editor won't be able to show it. Sorry!\n\nIn Home, tap on select to select multiple notes and then tap on the trash icon in the top left corner to move them to trash\n\nIn the trash bin, you can left swipe any note restore it.\n\nIn the trash bin, tap on 'select' in top right corner, to select multiple notes and then tap on 'options' in the top left corner to either restore or permanently erase the selected notes."
    }
    
}

#if DEVELOPMENT

let baseUrl = "https://dev.google.com"

#else

let baseUrl = "https://prod.google.com"


#endif
