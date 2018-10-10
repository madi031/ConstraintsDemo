//
//  ToDo.swift
//  ConstraintsDemo
//
//  Created by madi on 10/5/18.
//  Copyright © 2018 com.ibm. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ToDo: NSManagedObject {
    class func createOrUpdate(dict: NSDictionary, inManagedObjectContext context: NSManagedObjectContext) throws -> ToDo {
        var todo: ToDo
        
        todo = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: context) as! ToDo

        todo.name = dict["name"] as! String
        todo.id = dict["id"] as! Int
        
        return todo
    }
    
    @nonobjc class func createFetchRequest() -> NSFetchRequest<ToDo> {
        return NSFetchRequest<ToDo>(entityName: "ToDo")
    }
}

extension ToDo {
    @NSManaged var name: String
    @NSManaged var id: Int
}
