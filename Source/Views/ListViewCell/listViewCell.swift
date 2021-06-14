//
//  listViewCell.swift
//  Notey 2.0
//
//  Created by Ameya Bhagat on 15/10/20.
//  Copyright © 2020 Ameya Bhagat. All rights reserved.
//

import UIKit

class listViewCell: UITableViewCell {
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var colourBar: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor(named: "cellBackground")
        content.lineBreakMode = .byCharWrapping
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
