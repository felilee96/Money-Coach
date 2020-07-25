//
//  ViewController.swift
//  Money Coach
//
//  Created by Felicia on 04/04/2020.
//  Copyright © 2020 felicia. All rights reserved.
//

import UIKit
import UserNotifications
import RealmSwift

class ViewController: UIViewController {
    
    //MARK: Properties
        
    override func viewDidLoad() {
        super.viewDidLoad()
        

    // Ask user permission to send notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]) { success, error in
        if success {
            UserDefaults.standard.set(true, forKey: "settingValue")
            print("All set!")
        } else if let error = error {
            UserDefaults.standard.set(false, forKey: "settingValue")

            print(error.localizedDescription)
        }
    }
    // create and set the notification contents for 12PM reminder
    let content1 = UNMutableNotificationContent()
    //content title & body
      content1.title = "Daily Reminder to log your transactions!"
       content1.body = "Hey! Remember to log your transactions for today to achieve your budget plan.❤️"
            
    // create and set the notification contents for 8PM reminder
    let content2 = UNMutableNotificationContent()
            content2.title = "Daily Reminder to log your transactions!"
            content2.body = "Good evening! Do you log your transactions for today? Don't forget to record your expenses, income, savings and budget for today! 💰"
   
    // create notification trigger
    //notification will be triggered when the date time is matched.
    // declare date components for reminder 1 & 2
    var dateComponents1 = DateComponents()
    var dateComponents2 = DateComponents()
    // set reminder at 12 PM daily
   dateComponents1.hour = 12
   dateComponents1.minute = 00
    // set reminder at 8 PM daily
    dateComponents2.hour = 20
    dateComponents2.minute = 00

    // 12 PM daily reminder will be send when device's time reached 12 PM
   let trigger12PM = UNCalendarNotificationTrigger(dateMatching: dateComponents1, repeats: true)
    // 8 PM daily reminder will be send when device's time reached 12 PM
   let trigger8PM = UNCalendarNotificationTrigger(dateMatching: dateComponents2, repeats: true)
   


    //create the notification request
    let uuidString1 = UUID().uuidString
    let uuidString2 = UUID().uuidString
   //create request and set contents and identifier for each notification (reminder)
    let request1 = UNNotificationRequest (identifier: uuidString1, content: content1, trigger: trigger12PM)
            
    let request2 = UNNotificationRequest (identifier: uuidString2, content: content2, trigger: trigger8PM)
            
           //if notification successfully tiggered, save into database
        UNUserNotificationCenter.current().add(request1) { error in
                if error != nil {
                       print("Error has occur.")
                   }
                else {
                          //write all data into database
                    let realm = try! Realm ()
                    let reminder = Reminder()
                    reminder.content = content1.body
                    reminder.createdDate = Date()
                        try! realm.write {
                            realm.add (reminder)
                        }
                   }
               }
            
            UNUserNotificationCenter.current().add(request2) { error in
                if error != nil {
                        print("Error has occur.")
                   }
                else {
                       //write all data into database
                        let realm = try! Realm ()
                        let reminder = Reminder()
                       reminder.content = content2.body
                    reminder.createdDate = Date()
                    try! realm.write {
                        realm.add (reminder)
                    }

                   }
               }
        
        }
    }


