//
//  TasksViewController.swift
//  TodoAppV2
//
//  Created by Edward Barajas on 5/22/20.
//  Copyright © 2020 Edward Barajas. All rights reserved.
//

import FirebaseAuth
import FirebaseDatabase
import UIKit

struct Task {
    var taskCompleted: Bool
    var taskName: String
}

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tasksTableView: UITableView!
    @IBOutlet weak var userIDLabel: UILabel!
    var tasks: [Task] = []
    var userID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        tasksTableView.rowHeight = 80
        
        if let uid = userID {
            userIDLabel.text = uid
        }
        
        loadTasks()

        // Do any additional setup after loading the view.
    }
    
    func loadTasks() {
        let ref = Database.database().reference(withPath: "users").child(userID!).child("tasks")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let taskName = child.key
                let taskRef = ref.child(taskName)
                taskRef.observeSingleEvent(of: .value, with: { (taskSnapshot) in
                    let value = taskSnapshot.value as? NSDictionary
                    let taskCompleted = value!["taskCompleted"] as? Bool
                    self.tasks.append(Task(taskCompleted: taskCompleted!, taskName: taskName))
                    self.tasksTableView.reloadData()
                })
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        cell.taskLabel.text = tasks[indexPath.row].taskName
        if tasks[indexPath.row].taskCompleted {
            cell.statusImage.image = UIImage(named: "symbol.png")
        }
        else {
            cell.statusImage.image = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ref = Database.database().reference(withPath: "users").child(userID!).child("tasks").child(tasks[indexPath.row].taskName)
        if tasks[indexPath.row].taskCompleted {
            tasks[indexPath.row].taskCompleted = false
            ref.updateChildValues(["taskCompleted": false])
        }
        else {
            tasks[indexPath.row].taskCompleted = true
            ref.updateChildValues(["taskCompleted": true])
        }
        tasksTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let ref = Database.database().reference(withPath: "users").child(userID!).child("tasks").child(tasks[indexPath.row].taskName)
            ref.removeValue()
            tasks.remove(at: indexPath.row)
            tasksTableView.reloadData()
        }
    }

}
