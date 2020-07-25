//
//  AnalysisViewController.swift
//  Money Coach
//
//  Created by Felicia on 19/06/2020.
//  Copyright © 2020 felicia. All rights reserved.
//

import UIKit

class AnalysisViewController: UIViewController {
   
 
    @IBOutlet weak var expensesReport: UIView!
    
    @IBOutlet weak var budgetVsExpensesReport: UIView!
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
         expensesReport.alpha = 1
        
        
    }
    
    @IBAction func reportSegmentChange(_ sender: UISegmentedControl) {
       
        switch sender.selectedSegmentIndex {
        case 0:
            expensesReport.alpha = 0
            budgetVsExpensesReport.alpha = 1
        
        default:
            expensesReport.alpha = 1
            budgetVsExpensesReport.alpha = 0
        }
    
    }
}
