//
//  Item.swift
//  ToDoList
//
//  Created by Henry Jiang on 10/9/19.
//  Copyright © 2019 Henry Jiang. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
