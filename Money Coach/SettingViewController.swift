//
//  SettingViewController.swift
//  Money Coach
//
//  Created by Felicia on 25/07/2020.
//  Copyright © 2020 felicia. All rights reserved.
//

import UIKit
import UserNotifications
import RealmSwift

class SettingViewController: UIViewController {

   var settingVal = UserDefaults.standard.bool(forKey: "settingValue")

    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var dailyReminderlbl: UILabel!
    @IBOutlet weak var descriptionLBL: UILabel!
  
    override func viewDidLoad() {
          super.viewDidLoad()
        if settingVal == true{
            reminderSwitch.isOn = true
        }
        else{
          reminderSwitch.isOn = false
        }
      }
   
    
    @IBAction func reminderToggle(_ sender: UISwitch) {
        
          if (sender.isOn == true){
            settingVal = true

            UserDefaults.standard.set(self.settingVal, forKey: "settingValue")

          }
          else{
            settingVal = false
        UserDefaults.standard.set(self.settingVal, forKey: "settingValue")
            
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()

          }
    }
    
}
