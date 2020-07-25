//
//  goal.swift
//  Money Coach
//
//  Created by Felicia on 11/06/2020.
//  Copyright © 2020 felicia. All rights reserved.
//

import Foundation
import RealmSwift

class Goal: Object{
    
    @objc dynamic var goalid = 0
    @objc dynamic var title: String = ""
    @objc dynamic var goaltype: String = ""
    @objc dynamic var targetSavings: Double = 0.0
    @objc dynamic var goalDueDate = Date()
    @objc dynamic var remindDate = Date()
    @objc dynamic var status: String = " "
    @objc dynamic var createdDate = Date()

  
     
       override static func primaryKey() -> String? {
              return "goalid"
    }
    
}
