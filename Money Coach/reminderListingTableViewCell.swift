//
//  reminderListingTableViewCell.swift
//  Money Coach
//
//  Created by Felicia on 04/07/2020.
//  Copyright © 2020 felicia. All rights reserved.
//

import UIKit

class reminderListingTableViewCell: UITableViewCell {

    @IBOutlet weak var contentsLbl: UILabel!
    @IBOutlet weak var indicatorImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
