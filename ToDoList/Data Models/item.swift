//
//  item.swift
//  ToDoList
//
//  Created by Henry Jiang on 3/17/19.
//  Copyright © 2019 Henry Jiang. All rights reserved.
//

import Foundation

class item : Encodable, Decodable {
    var title : String = ""
    var ifDone : Bool = false
}
