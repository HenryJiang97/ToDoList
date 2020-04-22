//
//  Category.swift
//  ToDoList
//
//  Created by Henry Jiang on 10/9/19.
//  Copyright © 2019 Henry Jiang. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
