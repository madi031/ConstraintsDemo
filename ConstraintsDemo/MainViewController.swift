//
//  MainViewController.swift
//  ConstraintsDemo
//
//  Created by madi on 10/5/18.
//  Copyright © 2018 com.ibm. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var countLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        countLabel.text = "0"
    }
    

    @IBAction func executeInMemoryPressed(_ sender: UIButton) {
        let todo: ToDoDemo = ToDoDemo()
        todo.testDuplicate()
        countLabel.text = String(todo.sampleCount)
    }
    
    @IBAction func executeSQLPressed(_ sender: UIButton) {
        let todo: ToDoDemo = ToDoDemo()
        todo.testSQLDuplicate()
        countLabel.text = String(todo.sampleCount)
    }
}
