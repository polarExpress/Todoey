//
//  Item.swift
//  Todoey
//
//  Created by Timotej Kos on 23/03/2018.
//  Copyright © 2018 Timotej Kos. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    // Property is name of forward relationship in Category
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
