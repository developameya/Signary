//
//  EditorViewController.swift
//  Signary
//
//  Created by Ameya Bhagat on 10/06/21.
//

import UIKit

class EditorViewController: UIViewController, UITextViewDelegate {
    //MARK:- PROPERTIES
    @IBOutlet weak var textView: UITextView!
    
    //MARK:- INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewUI()
        setBarButtonsItems()
    }
    
    //MARK:- USER INTERFACE METHODS
    
    private func textViewUI() {
        textView.delegate = self
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
