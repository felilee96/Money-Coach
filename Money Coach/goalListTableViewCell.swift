//
//  goalListTableViewCell.swift
//  Money Coach
//
//  Created by Felicia on 14/06/2020.
//  Copyright © 2020 felicia. All rights reserved.
//

import UIKit
import SwiftUI
import ProgressMeter

class goalListTableViewCell: UITableViewCell {
    
    var initialVal: Double = 0.0
    var updatedVal: Double = 0.0
    var currentVal: Double = 0.0
    @IBOutlet weak var progressControl: ProgressMeter!

    @IBOutlet weak var goalTitlelbl: UILabel!
    @IBOutlet weak var goalIcon: UIImageView!
    
    @IBOutlet weak var goalAmountIcon: UIImageView!
    @IBOutlet weak var goalTargetlbl: UILabel!
//    @IBOutlet weak var goalProgress: UIProgressView!
    
    @IBOutlet weak var progressLBL: UILabel!
    @IBOutlet weak var goalDueIcon: UIImageView!
    @IBOutlet weak var goalDuelbl: UILabel!
    @IBOutlet weak var goalStatuslbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
            setupWithCustomData()
            visualSetup()
       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @objc func updateProgress(){
        updatedVal = initialVal + currentVal
    }
    
    //set up the progress view
        func setupWithCustomData() {
            //the maximum of the view is 100 (%)
          progressControl.maxValue = 100
            //the data should be start from 0
            progressControl.data = [0.0]
            //set the initial value as 0
            progressControl.progress = 0 / 100
        }
        
        // visually setup the progress view
        func visualSetup() {
            progressControl.progressTintColor = UIColor(named: "Color-7")!
            progressControl.trackTintColor = UIColor(named: "Color-13")!
            progressControl.borderWidth = 1
            progressControl.borderColor = UIColor(named: "Color-3")!
            progressControl.annotationTextColor = UIColor(named: "Color-4")!
            progressControl.dividerColor = UIColor(named: "Color-5")!

    }

}
