//
//  HistoryTableViewCell.swift
//  Drops
//
//  Created by Josh Lopez on 12/30/15.
//  Copyright © 2015 Josh Lopez. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet var updateLabel: UILabel!
    @IBOutlet var timeAgoLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
