//
//  listViewCell.swift
//  Notey 2.0
//
//  Created by Ameya Bhagat on 15/10/20.
//  Copyright © 2020 Ameya Bhagat. All rights reserved.
//

import UIKit

class listViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var colourBar: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var noteDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor(named: "cellBackground")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
