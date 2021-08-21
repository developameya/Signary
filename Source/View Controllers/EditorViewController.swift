//
//  EditorViewController.swift
//  Signary
//
//  Created by Ameya Bhagat on 10/06/21.
//

import UIKit
import CoreData

typealias AttributedString = NSMutableAttributedString
typealias controlParameters = (systemImageName: String, control: EditorControl)

class EditorViewController: UIViewController {
    //MARK:- PROPERTIES
    var id: String?
    @IBOutlet weak var textView: UITextView!
    private var headerTypingAttributes: DynamicFontDictionary?
    private var bodyTypingAttributes: DynamicFontDictionary?
    private var logic = Logic()
    private var notes = [Note]()
    private var menuElements = MenuElementsHelper()
    private var customFont = FontCreator()
    private var note: Note?
    private var fontController = FontController()
    private let defaults = UserDefaults()
    private let controls: [controlParameters] = [
        (systemImageName: "bold", control: BoldControl()),
        (systemImageName: "italic", control: ItalicControl())
    ]
    
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
        
        let currentFont =  fontController.getFont(forKey: "textViewFont") ?? .preferredFont(forTextStyle: .body)
        
        textView.tintColor = UIColor(named: K.accentColor)
        
        textView.font = currentFont
        
        if let safeAttributedBody = safeNote.attributedBody {
            textView.attributedText = updateBodyAttributes(of: safeAttributedBody, font: textView.font!)
        } else {
            textView.attributedText = NSAttributedString(string: "")
        }
                
        textView.textColor = UIColor(named: "editorTextColour")
        
        textView.backgroundColor = .systemBackground
        
        textView.alwaysBounceVertical = true
        
        textView.adjustsFontForContentSizeCategory = true
        
        textView.inputAccessoryView = toolBarUI()
        
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        textView.keyboardDismissMode = .onDrag

        
        let defaultHeaderAttributes: DynamicFontDictionary = [
            AttrStrKey.font: Font.preferredFont(forTextStyle: .largeTitle),
            AttrStrKey.foregroundColor : UIColor(named: "editorTextColour")!
        ]
        headerTypingAttributes = fontController.getFontAttributes(forKey: .header) ?? defaultHeaderAttributes

        textView.typingAttributes = headerTypingAttributes!

        let defaultBodyAttributes: DynamicFontDictionary = [
            AttrStrKey.font: Font.preferredFont(forTextStyle: .body),
            AttrStrKey.foregroundColor: UIColor(named: "editorTextColour")!
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
    
    private func toolBarUI() -> UIToolbar {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        
        toolBar.setItems(makeToolbarButtons(), animated: true)
        
        toolBar.sizeToFit()
        
        return toolBar
    }
    
    func makeToolbarButtons() -> [BarButton] {
        
        var buttons = [BarButton]()
        
        for (name, control) in controls {
            
            let barButton = EditorActionButton(systemImageName: name, control: control, action: #selector(runAction(sender:)))
            
            buttons.append(barButton)
        }
        
        return buttons
    }
    
    
    private func setBarButtonsItems() {
        
        let menuItems = CustomFonts.allCases
        
        let elements = menuElements.createActions(from: menuItems)
        
        let fontButton = UIBarButtonItem(image: .init(systemName: "textformat"), menu: UIMenu(title: "Select Font", children: elements))
        
        
        let trashButton = UIBarButtonItem(image: UIImage(systemName: "xmark.bin.fill"), style: .plain, target: self, action: #selector(trashButtonPressed))
        
        navigationItem.rightBarButtonItems = [trashButton, fontButton]
    }
    
    //MARK:- UI SUPPORT METHODS
    
    @objc func runAction(sender: EditorActionButton) {
        
         sender.control.perform(on: textView)
        
        let typingFontAttributes = textView.typingAttributes
        
        let font: UIFont = typingFontAttributes[.font] as! UIFont
        
        let headerFontDescriptor = FontDescriptor.CustomFontDescriptor(font: font, textStyle: .largeTitle)
        
        let headerDynamicFont = Font.dynamicFont(font: Font(descriptor: headerFontDescriptor, size: 0.0))

        headerTypingAttributes = [AttrStrKey.font: headerDynamicFont!]
        
        let bodyFontDescriptor = FontDescriptor.CustomFontDescriptor(font: font, textStyle: .body)
        
        let bodyDynamicFont = Font.dynamicFont(font: Font(descriptor: bodyFontDescriptor, size: 0.0))
        
        bodyTypingAttributes = [AttrStrKey.font : bodyDynamicFont!]
        
        updatePersistantStore()
    
    }
    
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
    
    func checkAvailableFonts() {
        
        for family in UIFont.familyNames.sorted() {
            
            let names = UIFont.fontNames(forFamilyName: family)
            
            print("Family: \(family) Font names: \(names)")
            
        }
    }
    
    func updateBodyAttributes(of attributedString: NSAttributedString?, font fontToUpdate: Font) -> NSAttributedString? {
        
        let mutableBody = attributedString?.mutableCopy() as? NSMutableAttributedString
        
        mutableBody?.updateFontAttributeWith(font: fontToUpdate)
        
        return mutableBody?.copy() as? NSAttributedString
    }
}


//MARK:- TEXTVIEW DELEGATE METHODS

extension EditorViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        updatePersistantStore()
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
    
    func updatePersistantStore() {
        guard let safeNote = note else { fatalError("\(#function) Error at line \(#line) | invalid note object or note is nil.") }
        
        safeNote.body = textView.text
        
        safeNote.attributedBody = textView.attributedText
                
        safeNote.dateModified = Date()
        
        safeNote.title = textView.text.lines[0]
        
        note = safeNote
        
        logic.save()
    }
    
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
    
    func fontsMenuTapped(_ identifier: CustomFonts) {
        
        switch identifier {
        
        case .SystemFont, .FiraSans, .OpenSans, .PTSans, .TimesNewRoman:
            
            
            let textViewFont = fontController.setFont(fontFamily: identifier, forTextStyle: .body, forKey: "textViewFont") ?? .preferredFont(forTextStyle: .body)
            print(textViewFont.familyName)
            
            let attributedText = textView.attributedText
            
            let updatedAttributedText = updateBodyAttributes(of: attributedText, font: textViewFont)
            
            textView.attributedText = updatedAttributedText

            headerTypingAttributes = fontController.setFontAttributes(forKey: .header, fontFamily: identifier, forTextStyle: .largeTitle)
            
            bodyTypingAttributes = fontController.setFontAttributes(forKey: .body, fontFamily: identifier, forTextStyle: .body)
        }
    }
}

