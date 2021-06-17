//
//  SectionHeaderView.swift
//  Signary
//
//  Created by Ameya Bhagat on 17/06/21.
//

import UIKit

protocol SectionHeaderViewDelegate {
    func toggleSection(_ header: SectionHeaderView)
    
    func toggleHeaderRotation(_ header: SectionHeaderView)
}

class SectionHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    var delegate: SectionHeaderViewDelegate?
    
    @IBAction func buttonPressed(_ sender: UIButton) {
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
