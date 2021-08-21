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

    static let accentColor = "Accent Colour"
    static let sectionHeaderIdentifier = "SectionHeaderView"
    static let appTitle = "Signary"
    
    /// This struct contains constants for strings of cell indentifiers
    struct Cell {
        static let nibName = "listViewCell"
        static let indetifier = "ReusableCell"
    }
    /// This struct contains constant for the defaults keys used to save and retrieve userDefaults
    struct DefaultKeys {
        static let textViewFont = "textViewFont"
        static let header = "header"
        static let body = "body"
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
    
    struct colours {
        static let background = "TableBackground"
        static let textColour = "editorTextColour"
    }
    
}

