//
//  budgetTableViewCell.swift
//  Money Coach
//
//  Created by Felicia on 12/06/2020.
//  Copyright © 2020 felicia. All rights reserved.
//

import UIKit

class budgetTableViewCell: UITableViewCell {
    
    @IBOutlet var myimage: UIImageView!
    @IBOutlet var typelbl: UILabel!
    @IBOutlet var categoylbl:  UILabel!
    @IBOutlet var datelbl:  UILabel!
    @IBOutlet var amountlbl : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
