//
//  Category.swift
//  Todoey
//
//  Created by Timotej Kos on 23/03/2018.
//  Copyright © 2018 Timotej Kos. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    
    // Inverse relationship to Items
    let items = List<Item>()
    
}
