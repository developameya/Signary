//
//  EditorControl.swift
//  Signary
//
//  Created by Ameya Bhagat on 17/08/21.
//

import UIKit
/// Describes a control that can perform an action on `Editor`. An instance of control can be created in the `Editor`, however, Ideally these should be invoked via  `EditorControlPerformer`.
public protocol EditorControl: AnyObject {
     ///Creates a global identity of the control. Any functions that are registered to this value is available anyhwere in the editor. Adding a new control with the same name will replace the fuction of the cuurently registered control.
    var name: ControlName { get }
    /// Perform the action of the control on the given `TextView`. You may use `selectedRange` property of `TextView` if the command operates on
    /// the selected text only. for e.g. a control to make selected text bold.
    /// - Parameter editor: `UITextView` to execute the command on.
    func perform(on editor: UITextView)
}
