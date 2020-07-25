//
//  reminder.swift
//  Money Coach
//
//  Created by Felicia on 04/07/2020.
//  Copyright © 2020 felicia. All rights reserved.
//

import Foundation
import RealmSwift

class Reminder: Object{
    
    @objc dynamic var content: String = ""
    @objc dynamic var isRead: Bool = false
    @objc dynamic var createdDate = Date()

}
