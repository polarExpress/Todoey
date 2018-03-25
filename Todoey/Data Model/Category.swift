//
//  Category.swift
//  Todoey
//
//  Created by Timotej Kos on 23/03/2018.
//  Copyright © 2018 Timotej Kos. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var cellBackgroundColor: String = UIColor.randomFlat.hexValue()
    
    // Inverse relationship to Items
    let items = List<Item>()
    
}
