//
//  EditorViewController.swift
//  Signary
//
//  Created by Ameya Bhagat on 10/06/21.
//

import UIKit
import CoreData



class EditorViewController: UIViewController {
    //MARK:- PROPERTIES
    var id: String?
    @IBOutlet weak var textView: UITextView!
    private var headerTypingAttributes: FontFormattingDictionary?
    private var bodyTypingAttributes: FontFormattingDictionary?
    private var logic = Logic()
    private var notes = [Note]()
    private var menuElements = MenuElementsHelper()
    private var customFont = FontCreator()
    private var note: Note?
    private var fontController = FontController()
    private let defaults = UserDefaults()
    
    //MARK:- INIT
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        note = logic.fetchNote(withId: id!)
        
        registerDelegate()
        
        textViewUI()
        
        setBarButtonsItems()
        
        checkAvailableFonts()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(true)
        
        ifClear()
    }
    
    private func registerDelegate() {
        
        textView.delegate = self
        
        menuElements.delegate = self
    }
    
    //MARK:- USER INTERFACE METHODS
    
    private func textViewUI() {
        
        guard let safeNote = note else {fatalError()}
        
        textView.tintColor = UIColor(named: K.accentColor)
        
        textView.text = safeNote.body
        
        textView.textColor = UIColor(named: "editorTextColour")
        
        textView.backgroundColor = .systemBackground
        
        textView.alwaysBounceVertical = true
        
        textView.adjustsFontForContentSizeCategory = true
        
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        textView.font = fontController.getFont(forKey: "textViewFont") ?? .preferredFont(forTextStyle: .body)
        
        let highlightFont = fontController.getFont(forKey: "highlightFont") ?? .preferredFont(forTextStyle: .largeTitle)
        textView.highlightFirstLineInTextView(font: highlightFont)
        
        let defaultHeaderAttributes: FontFormattingDictionary = [
            AttrStrKey.font: UIFont.preferredFont(forTextStyle: .largeTitle),
            AttrStrKey.foregroundColor : UIColor(named: "editorTextColour")!
        ]
        headerTypingAttributes = fontController.getFontAttributes(forKey: .header) ?? defaultHeaderAttributes
        
        let defaultBodyAttributes: FontFormattingDictionary = [
            AttrStrKey.font: UIFont.preferredFont(forTextStyle: .body), AttrStrKey.foregroundColor: UIColor(named: "editorTextColour")!
        ]
        bodyTypingAttributes = fontController.getFontAttributes(forKey: .body) ?? defaultBodyAttributes
    
        
        if textView.isFirstResponder {
            
            navigationController?.hidesBarsWhenKeyboardAppears = true
            
        } else {
            
            navigationController?.hidesBarsWhenKeyboardAppears = false
            
        }
        
        if textView.text == "" || textView.text.hasPrefix(" ") == true {
            
            textView.becomeFirstResponder()
            
        } else {
            
            textView.resignFirstResponder()
        }
    }
    
    private func setBarButtonsItems() {

        let menuItems = Fonts.allCases
        
        let elements = menuElements.createActions(from: menuItems)
        
        let fontButton = UIBarButtonItem(image: .init(systemName: "textformat"), menu: UIMenu(title: "Select Font", children: elements))
        
        let trashButton = UIBarButtonItem(image: UIImage(systemName: "xmark.bin.fill"), style: .plain, target: self, action: #selector(trashButtonPressed))
        
        navigationItem.rightBarButtonItems = [trashButton, fontButton]
    }
    
    //MARK:- UI SUPPORT METHODS
    
    @objc private func trashButtonPressed() {
        
        let alert = UIAlertController(title: "Delete Note", message: "Deleted notes cannot be recovered.", preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "Delete", style: .destructive) { _ in
            
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(delete)
        
        alert.addAction(cancelButton)
        
        present(alert, animated: true, completion: nil)
    }
}

func checkAvailableFonts() {
    
    for family in UIFont.familyNames.sorted() {
        
        let names = UIFont.fontNames(forFamilyName: family)
        
        print("Family: \(family) Font names: \(names)")
        
    }
}


//MARK:- TEXTVIEW DELEGATE METHODS

extension EditorViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        guard let safeNote = note else { fatalError("\(#function) Error at line \(#line) | invalid note object or note is nil.") }
        
        safeNote.body = textView.text
        
        safeNote.dateModified = Date()
        
        safeNote.title = textView.text.lines[0]
        
        note = safeNote
        
        logic.save()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        guard let safeNote = note else { fatalError("\(#function) Error at line \(#line) | invalid note object or note is nil.") }
        
        if textView.text == "" || textView.text.hasPrefix(" ") == true {
            
            safeNote.isClear = true
            
        } else {
            
            safeNote.isClear = false
            
        }
        note = safeNote
        
        logic.save()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let textAsNSString = self.textView.text as NSString
        
        let replaceCharacters = textAsNSString.replacingCharacters(in: range, with: text) as NSString
        
        let boldRange = replaceCharacters.range(of: "\n")
        
        if let safeHeaderAttributes = self.headerTypingAttributes,
           let safeBodyAttributes = self.bodyTypingAttributes {
            
            if boldRange.location <= range.location {
                
                self.textView.typingAttributes = safeBodyAttributes
                
            } else {
                
                self.textView.typingAttributes = safeHeaderAttributes
            }
        }
        
        return true
    }
}

//MARK:- DATA MANIPULATION METHODS

extension EditorViewController {
    
    func ifClear() {
        
        //BEFORE THE VIEW DISAPPEARS, THIS LINE CHECKS FOR THE FINAL TIME IF BOTH TEXVIEW AND TEXTFIELD ARE CLEAR OR NOT AND SETS THE 'ISCLEAR' PROPERTY OF THE NOTE ACCORDINGLY
        guard let safeNote = note else { fatalError() }
        
        if (textView.text == "" || textView.text.hasPrefix(" ") == true) {
            
            safeNote.isClear = true
            
            note = safeNote
            
            trash()
        } else {
            
            safeNote.isClear = false
            
            note = safeNote
            
            logic.save()
        }
    }
    
    func trash() {
        
        self.dismiss(animated: true) {
            
            self.navigationController?.popToRootViewController(animated: true)
            
            guard let safeNote = self.notes.last else {
                
                print("note is nil")
                
                return
            }
            
            self.logic.managedContext?.delete(safeNote)
            
            self.logic.save()
        }
    }
}

//MARK:- MENU DELEGATE METHODS

extension EditorViewController: MenuElementsDelegate {
    
    func fontsMenuTapped(_ identifier: Fonts) {
        
        switch identifier {
        
        case .SystemFont, .FiraSans, .OpenSans, .PTSans, .TimesNewRoman, .CourierNew:
        
            let textViewFont = fontController.setFont(fontFamily: identifier, forTextStyle: .body, forKey: "textViewFont") ?? .preferredFont(forTextStyle: .body)
            textView.font = textViewFont
            
            let highlightFont = fontController.setFont(fontFamily: identifier, forTextStyle: .largeTitle, forKey: "highlightFont") ?? .preferredFont(forTextStyle: .largeTitle)
            textView.highlightFirstLineInTextView(font: highlightFont)
                
                headerTypingAttributes = fontController.setFontAttributes(forKey: .header, fontFamily: identifier, forTextStyle: .largeTitle)
                
                bodyTypingAttributes = fontController.setFontAttributes(forKey: .body, fontFamily: identifier, forTextStyle: .body)
        }
    }
}
