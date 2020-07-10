//
//  ViewController.swift
//  Test Login
//
//  Created by Allan Qin on 6/19/20.
//  Copyright © 2020 Allan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    let email = "test@test.com"
    let password = "123456"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Auth.auth().signIn(withEmail: email, password: password) { (auth, error) in guard let auth = auth else {
            print("FAILEDDDDDDD")
            print(error!)
            return
            }
            print("SUCCCCSEEEEEEEDDDDD")
            print(auth.user.uid)
            
        }
    }


}

