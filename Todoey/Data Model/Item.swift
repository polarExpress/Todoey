//
//  Item.swift
//  Todoey
//
//  Created by Timotej Kos on 21/03/2018.
//  Copyright © 2018 Timotej Kos. All rights reserved.
//

import Foundation

// Model needs to be Encodable and Decodable to support NSCoder = Encodable, Decodable
class Item: Codable {
    // All properties in Encodable should be default types (not custom)
    var title: String = ""
    var done: Bool = false
}
