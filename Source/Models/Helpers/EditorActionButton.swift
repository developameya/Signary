//
//  EditorActionButton.swift
//  Signary
//
//  Created by Ameya Bhagat on 18/08/21.
//

import UIKit

public typealias BarButton = UIBarButtonItem

public class EditorActionButton: BarButton {
    let control: EditorControl
    
    init(systemImageName: String, control: EditorControl, action: Selector?) {
        self.control = control
        super.init()
        image = UIImage(systemName: systemImageName)
        self.action = action
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
