//
//  editGoalViewController.swift
//  Money Coach
//
//  Created by Felicia on 25/07/2020.
//  Copyright © 2020 felicia. All rights reserved.
//

import UIKit
import RealmSwift

class editGoalViewController: UIViewController {
    var goalIndexEdit: Int?

    @IBOutlet weak var edit_goalTitle: UITextField!
    @IBOutlet weak var edit_goalType: UITextField!
    @IBOutlet weak var edit_targetSavings: UITextField!
    @IBOutlet weak var edit_goalDue: UITextField!
    @IBOutlet weak var edit_goalReminder: UITextField!
    var doneSaving: (() -> ())?
    var realm: Realm!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    @IBAction func cancelBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func updateBtn(_ sender: UIButton) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
