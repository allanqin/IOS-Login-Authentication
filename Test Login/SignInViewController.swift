//
//  SignInViewController.swift
//  Test Login
//
//  Created by Allan Qin on 6/20/20.
//  Copyright © 2020 Allan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseUI


class SignInViewController: UIViewController, FUIAuthDelegate {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    var db: Firestore!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        /*
        let email = "test@test.co"
        let password = "123456"
         
        Auth.auth().signIn(withEmail: email, password: password) { (auth, error) in
            guard let auth = auth else {
            print("FAILEDDDDDDD")
            print(error!)
            return
            }
            print("SUCCCCSEEEEEEEDDDDD")
            print(auth.user.uid)
            
        }
        */
    }
    
    func listenForAuthChanges() {
        Auth.auth().addStateDidChangeListener{(auth, user) in
            guard let user = user else{return}
            print(user.email!)
            
        }
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        print("Sign in button tapped")
        
        let email = userNameTextField.text!
        let password = userPasswordTextField.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { (auth, error) in
            guard let auth = auth else {
            print("[==========FAILED============]")
            print(error!)
            return
            }
            print("[^^^^^^^^^^^SUCCESS^^^^^^^^^^]")
            print(auth.user.uid)
            self.performSegue(withIdentifier: "homePage", sender: self)
        }
        /*
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard self != nil else { return }
            self?.performSegue(withIdentifier: "homePage", sender: self)
        }
        */
        /*
        let authUI = FUIAuth.defaultAuthUI()
        
        guard authUI != nil else{
            return
        }
        
        authUI?.delegate = self
        authUI?.providers = [FUIEmailAuth()]
        
        let authViewController = authUI!.authViewController()
        
        present(authViewController, animated: true, completion: nil)
        
        //performSegue(withIdentifier: "homePage", sender: self)
        */
    }
    
    @IBAction func registerNewAccountButtonTapped(_ sender: Any) {
        print("Registration button tapped")
    }
    

}
/*
extension ViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        guard error == nil else{
            return
        }
        
        //authDataResult?.user.uid
        
        performSegue(withIdentifier: "homePage", sender: self)
    }
}
*/
