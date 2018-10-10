//
//  ToDoTest.swift
//  ConstraintsDemo
//
//  Created by madi on 10/5/18.
//  Copyright © 2018 com.ibm. All rights reserved.
//

import Foundation
import UIKit

class ToDoDemo: MockCoreData  {
    var sampleCount = 0
    
    func testDuplicate() {
        do {
            let id = 1
            let name = "apple"

            let sample: NSDictionary = ["id": id, "name": name]

            _ = try ToDo.createOrUpdate(dict: sample, inManagedObjectContext: getMockedContext())
            try getMockedContext().save()
            
            var existingSamples = try getSamples(id: 1)
            
            _ = try ToDo.createOrUpdate(dict: sample, inManagedObjectContext: getMockedContext())
            try getMockedContext().save()
            
            existingSamples = try getSamples(id: 1)
            print("Samples...\(existingSamples)")
            
            sampleCount = existingSamples.count
        } catch {
            fatalError("Error while saving data: \(error)")
        }
    }
    
    func testSQLDuplicate() {
        do {
            let id = 2
            let name = "orange"
            
            var sample: NSDictionary = ["id": id, "name": name]
            
            _ = try ToDo.createOrUpdate(dict: sample, inManagedObjectContext: getSQLContext())
            try getSQLContext().save()
            
            var existingSamples = try getSQLSamples(id: 2)
            
            sample = ["id": 3, "name": "orange"]
            
            _ = try ToDo.createOrUpdate(dict: sample, inManagedObjectContext: getSQLContext())
            try getSQLContext().save()
            
            existingSamples = try getSQLSamples(id: 3)
            print("Samples...\(existingSamples)")
            
            for sample in existingSamples as [ToDo] {
                print(sample.name)
            }
            
            print("#######2########")
            
            existingSamples = try getSQLSamples(id: 2)
            print("Samples...\(existingSamples)")
            
            for sample in existingSamples as [ToDo] {
                print(sample.name)
            }
            
            sampleCount = existingSamples.count
        } catch {
            fatalError("Error while saving data: \(error)")
        }
    }
    
    func getSamples(id: Int) throws -> [ToDo] {
        let request = ToDo.createFetchRequest()
        request.predicate = NSPredicate(format: "id = %ld", id)
        
        let matches = try getMockedContext().fetch(request)
        return matches
    }
    
    func getSQLSamples(id: Int) throws -> [ToDo] {
        let request = ToDo.createFetchRequest()
        request.predicate = NSPredicate(format: "id = %ld", id)
        
        let matches = try getSQLContext().fetch(request)
        return matches
    }
}

