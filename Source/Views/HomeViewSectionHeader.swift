//
//  HomeViewSectionHeader.swift
//  Signary
//
//  Created by Ameya Bhagat on 17/06/21.
//

import UIKit

public class HomeViewSectionHeader {
    //    let sectionHeaderHeight: CGFloat = 34
    
    func view(_ target:SectionHeaderViewDelegate, _ tableView: UITableView,_ section: Int,_ isCollapsed: Bool) -> UIView {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeaderView") as! SectionHeaderView
        header.delegate = target
        header.label.font = UIFont.boldSystemFont(ofSize: 22)
        header.label.textColor = UIColor(named: "editorTextColour")
        
        header.button.tintColor = UIColor(named: "editorTextColour")
        
        if let safeTableSection = TableSection(rawValue: section) {
            switch safeTableSection {
            case .pinned:
                header.button.isHidden = false
                print(isCollapsed)
                header.button.setTitle(">", for: .normal)
                header.setExpansion(isCollapsed: isCollapsed)
                header.label.text = "Pinned"
                
            case .unpinned:
                header.button.isHidden = true
                header.label.text = "Notes"
                
            default:
                break
            }
        }
        return header
    }
}
