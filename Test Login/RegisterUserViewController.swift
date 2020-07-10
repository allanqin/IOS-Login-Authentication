//
//  RegisterUserViewController.swift
//  Test Login
//
//  Created by Allan Qin on 6/20/20.
//  Copyright © 2020 Allan. All rights reserved.
//

import UIKit
import Firebase

class RegisterUserViewController: UIViewController {
    
    var db: Firestore!

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        print("Canceled button tapped")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        print("Sign Up button tapped")
        
        if (firstNameTextField.text?.isEmpty)! || (lastNameTextField.text?.isEmpty)! || (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!
        {
            print("not all fields are filled in")
            return
        }
        
        if (passwordTextField.text!.count < 6)
        {
            print("password must be at least 6 characters long")
            return
        }
        
        if ((passwordTextField.text?.elementsEqual(repeatPasswordTextField.text!))! != true)
        {
            print("passwords do not match")
            return
        }
        
        /*
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        */
        
        let first = firstNameTextField.text!
        let last = lastNameTextField.text!
        let email = emailTextField.text!
        let password = passwordTextField.text!
        //var uid = "testValue"
        
        /*
        if Auth.auth().currentUser != nil {
          // User is signed in.
            let user = Auth.auth().currentUser
            if let user = user {
              // The user's ID, unique to the Firebase project.
              // Do NOT use this value to authenticate with your backend server,
              // if you have one. Use getTokenWithCompletion:completion: instead.
              uid = user.uid
            }
        } else {
          // No user is signed in.
        }
            */
 
        //add to identity platform
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
          if let error = error {
              print("AuthCreate User Error: \(error)")
          } else {
              print("AuthCreate SUCCESS ^.^")
            
              //Sign in after registration
              Auth.auth().signIn(withEmail: email, password: password) { (auth, error) in
                  guard let auth = auth else {
                  print("[==========FAILED============]")
                  print(error!)
                  return
                  }
                  print("[^^^^^^^^^^^SUCCESS^^^^^^^^^^]")
                  print(auth.user.uid)
                
                self.db.collection("users").document(auth.user.uid).setData([
                    "first": first,
                    "last": last,
                    "email": email
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                        self.performSegue(withIdentifier: "regToHome", sender: self)
                    }
                }
                  //self.performSegue(withIdentifier: "homePage", sender: self)
              }
            
          }
        }
        
        /*
        //add to Firebase database
        db.collection("users").document(uid).setData([
            "first": first,
            "last": last,
            "email": email
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        */
        
        
        /*
        //Sign in after registration
        Auth.auth().signIn(withEmail: email, password: password) { (auth, error) in
            guard let auth = auth else {
            print("[==========FAILED============]")
            print(error!)
            return
            }
            print("[^^^^^^^^^^^SUCCESS^^^^^^^^^^]")
            print(auth.user.uid)
            //self.performSegue(withIdentifier: "homePage", sender: self)
        }
        */
        /*
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "first": first,
            "last": last,
            "email": email
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        */
    }
    

}
