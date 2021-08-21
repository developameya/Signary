//
//  FontTraitChangeControl.swift
//  Signary
//
//  Created by Ameya Bhagat on 17/08/21.
//

import UIKit
/// Editor control that toggles given font trait to the selected range in the Editor.
public class FontTraitChangeControl: EditorControl {
    public var name: ControlName
    public let trait: FontDescriptor.SymbolicTraits
    public var typingAttributes: [DynamicFontDictionary]?
    
    public init(name: ControlName, trait: FontDescriptor.SymbolicTraits) {
        self.name = name
        self.trait = trait
    }
    
    public func perform(on editor: UITextView) {
        let selectedText = editor.selectedText
        if editor.isEmpty || editor.selectedRange == .zero || selectedText.length == 0 {
            guard let font = editor.typingAttributes[.font] as? UIFont else { return }
            let toggledFont = font.toggle(trait: trait)
            editor.typingAttributes[.font] = toggledFont
            return
        }
        //GET THE FONT OF THE SELECTED TEXT
        guard let initFont = selectedText.attribute(.font, at: 0, effectiveRange: nil) as? Font else { return }
        
        editor.attributedText.enumerateAttribute(.font, in: editor.selectedRange, options: .longestEffectiveRangeNotRequired) { font, range, _ in
            if let safeFont = font as? Font {
                let fontToApply = initFont.contains(trait: trait) ? safeFont.remove(trait: trait) : safeFont.add(trait: trait)
                editor.addAttribute(.font, value: fontToApply, at: range)
            }
        }
    }
}
