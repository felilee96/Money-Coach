//
//  reminderListingViewController.swift
//  Money Coach
//
//  Created by Felicia on 04/07/2020.
//  Copyright © 2020 felicia. All rights reserved.
//

import UIKit
import RealmSwift

class reminderListingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var reminderTableView: UITableView!
    
    //declare for database
        var realm: Realm!
        //store the data get from database as array
        var reminderList: Results <Reminder>{
            get{
                return realm.objects(Reminder.self).sorted(byKeyPath: "createdDate", ascending: false)
            }
        }

    @IBAction func readAllBtn(_ sender: UIButton) {

        let reminder2 = realm.objects(Reminder.self)
        try! realm.write {
            reminder2.setValue("true", forKey: "isRead")
            reminderTableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //trigger the database
        realm = try! Realm()
        //register customised table view cell for the table view
        let nib = UINib (nibName: "reminderListingTableViewCell", bundle: nil)
        reminderTableView.register(nib, forCellReuseIdentifier: "reminderListingTableViewCell")
        reminderTableView.delegate = self
               reminderTableView.dataSource = self
               reminderTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reminderList.count == 0{
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: reminderTableView.bounds.size.width, height: reminderTableView.bounds.size.height))
                                      noDataLabel.text = "You do not have any notifications yet. Remember to turn on the Daily Reminder in the Setting to get reminded to log your transactions. 😄"
                                      noDataLabel.textColor     = UIColor.black
                                      noDataLabel.numberOfLines = 0
                                      noDataLabel.textAlignment = .center
                                      reminderTableView.backgroundView  = noDataLabel
                                      reminderTableView.separatorStyle  = .none
        }
        else{
            reminderTableView.backgroundView  = .none
        }
            return reminderList.count
        
    }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "reminderListingTableViewCell", for: indexPath) as! reminderListingTableViewCell
           let reminder = reminderList[indexPath.row]
           // return each data from database into respective labels on the customised table view cell
           cell.contentsLbl.text = reminder.content
        
        if reminder.isRead == true{
            cell.indicatorImg.image = UIImage(named: "whitedot")!
        }
        else{
             cell.indicatorImg.image = UIImage(named: "reddot")!
        }
            return cell

        }
       
}
