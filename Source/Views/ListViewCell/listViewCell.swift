//
//  listViewCell.swift
//  Notey 2.0
//
//  Created by Ameya Bhagat on 15/10/20.
//  Copyright © 2020 Ameya Bhagat. All rights reserved.
//

import UIKit

typealias TableViewCell = UITableViewCell

class listViewCell: TableViewCell {
    @IBOutlet weak var title: Label!
    @IBOutlet weak var colourBar: UIView!
    @IBOutlet weak var dateLabel: Label!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var noteDescription: Label!
        
    override func awakeFromNib() {
        colourBar.alpha = 0.0
        super.awakeFromNib()
        contentView.backgroundColor = Colour(named: "cellBackground")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
