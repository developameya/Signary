//
//  SectionHeaderView.swift
//  Signary
//
//  Created by Ameya Bhagat on 17/06/21.
//

import UIKit

typealias TableViewHeaderFooterView = UITableViewHeaderFooterView
typealias Label = UILabel
typealias Button = UIButton

protocol SectionHeaderViewDelegate {
    func toggleSection(_ header: SectionHeaderView)
    
    func toggleHeaderRotation(_ header: SectionHeaderView)
}

class SectionHeaderView: TableViewHeaderFooterView {
    @IBOutlet weak var label: Label!
    @IBOutlet weak var button: Button!
    var delegate: SectionHeaderViewDelegate?
    
    @IBAction func buttonPressed(_ sender: Button) {
        delegate?.toggleSection(self)
        delegate?.toggleHeaderRotation(self)
    }
    
    func setExpansion(isCollapsed: Bool) {
        print(isCollapsed)
        button.rotate(isCollapsed ? 0.0 : .pi / 2)
    }
}

extension SectionHeaderViewDelegate {
    func toggleHeaderRotation(_ header: SectionHeaderView) {
        
    }
}
