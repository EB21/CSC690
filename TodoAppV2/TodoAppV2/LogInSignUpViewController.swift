//
//  LogInSignUpViewController.swift
//  TodoAppV2
//
//  Created by Edward Barajas on 5/22/20.
//  Copyright © 2020 Edward Barajas. All rights reserved.
//

import FirebaseAuth //Library for authenticating users
import FirebaseDatabase //Library to help store things on the Database
import UIKit

class LogInSignUpViewController: UIViewController {

    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    var uid: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func userSignUp(_ sender: Any) {
        if userEmail.text != nil && userPassword.text != nil {
            Auth.auth().createUser(withEmail: userEmail.text!, password: userPassword.text!) { (result, error) in
                if error != nil {
                    print("AN ERROR HAS OCCURRED")
                }
                else {
                    self.uid = (result?.user.uid)!
                    let ref = Database.database().reference(withPath: "users").child(self.uid)
                    ref.setValue(["email": self.userEmail.text!, "password": self.userPassword.text!])
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
            }
        }
    }
    
    @IBAction func userLogIn(_ sender: Any) {
        if userEmail.text != nil && userPassword.text != nil {
            Auth.auth().signIn(withEmail: userEmail.text!, password: userPassword.text!) { (result, error) in
                if error != nil {
                    print("AN ERROR HAS OCCURRED")
                }
                else {
                    self.uid = (result?.user.uid)!
                    self.performSegue(withIdentifier: "loginSegue", sender: self)

                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigation = segue.destination as! UINavigationController
        let tasksVC = navigation.topViewController as! TasksViewController
        tasksVC.userID = uid
    }

}
