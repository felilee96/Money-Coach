//
//  goalTableViewCell.swift
//  Money Coach
//
//  Created by Felicia on 14/06/2020.
//  Copyright © 2020 felicia. All rights reserved.
//

import UIKit

class goalTableViewCell: UITableViewCell {

    //link the UI item from custom table cell to coding
    @IBOutlet weak var goalIcon: UIImageView!
    @IBOutlet weak var goalTitle: UILabel!
    @IBOutlet weak var goalAmountIcon: UIImageView!
    @IBOutlet weak var goalAmountlbl: UILabel!
    @IBOutlet weak var goalStatuslbl: UILabel!
    @IBOutlet weak var goalDueIcon: UIImageView!
    @IBOutlet weak var goalDuelbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
