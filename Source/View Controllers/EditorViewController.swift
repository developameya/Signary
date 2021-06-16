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
    var content: NoteContent?
    @IBOutlet weak var textView: UITextView!
    private var headerAttributes: [NSAttributedString.Key : Any]?
    private var bodyAttributes: [NSAttributedString.Key : Any]?
    private var logic = Logic()
    
    //MARK:- INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewUI()
        setBarButtonsItems()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        logic.clearEmptyNote(textView: textView)
    }
    
    //MARK:- USER INTERFACE METHODS
    
    private func textViewUI() {
        textView.delegate = self
        textView.text = content?.text
        textView.highlightFirstLineInTextView()
        
        headerAttributes = [NSAttributedString.Key.font :
                                UIFont.preferredFont(forTextStyle: UIFont.TextStyle.largeTitle),
                            NSAttributedString.Key.foregroundColor :
                                UIColor(named: "editorTextColour")!]
        
        bodyAttributes = [NSAttributedString.Key.font :
                            UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body),
                          NSAttributedString.Key.foregroundColor :
                            UIColor(named: "editorTextColour")!]
    }
    
    private func setBarButtonsItems() {
        
        let micButton = UIBarButtonItem(image: UIImage(systemName: "mic.fill"), style: .plain, target: self, action: #selector(micButtonPressed))
        let trashButton = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .plain, target: self, action: #selector(trashButtonPressed))
        //        let gearButton = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(gearPressed))
        navigationItem.rightBarButtonItems = [micButton, trashButton]
    }
    
    //MARK:- UI SUPPORT METHODS
    @objc private func micButtonPressed() {
        print("EditorViewController | \(#function)")
    }
    
    @objc private func trashButtonPressed() {
        
        let alert = UIAlertController(title: "Delete Notey!", message: "Deleted notes cannot be recovered.", preferredStyle: .alert)
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


//MARK:- TEXTVIEW DELEGATE METHODS

extension EditorViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let textAsNSString = self.textView.text as NSString
        let replaceCharacters = textAsNSString.replacingCharacters(in: range, with: text) as NSString
        let boldRange = replaceCharacters.range(of: "\n")
        
        if let safeHeaderAttributes = self.headerAttributes, let safeBodyAttributes = self.bodyAttributes {
            if boldRange.location <= range.location {
                self.textView.typingAttributes = safeBodyAttributes
            } else {
                
                self.textView.typingAttributes = safeHeaderAttributes
            }
        }
        return true
    }
}
