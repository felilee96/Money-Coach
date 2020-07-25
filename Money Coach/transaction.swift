//
//  transaction.swift
//  Money Coach
//
//  Created by Felicia on 11/06/2020.
//  Copyright © 2020 felicia. All rights reserved.
//

import Foundation
import RealmSwift

class Transaction: Object{
    @objc dynamic var id = 0
    @objc dynamic var amount: Double = 0.0
    @objc dynamic var type: String = ""
    @objc dynamic var category: String = ""
    @objc dynamic var date = Date()
    
    override static func primaryKey() -> String? {
           return "id"
       }

}
