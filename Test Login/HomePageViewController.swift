//
//  HomePageViewController.swift
//  Test Login
//
//  Created by Allan Qin on 6/21/20.
//  Copyright © 2020 Allan. All rights reserved.
//

import UIKit
import Firebase

class HomePageViewController: UIViewController {
    
    var db: Firestore!
    var uid = String()

    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var displayFullName: UILabel!
    @IBOutlet weak var queueTitle: UILabel!
    
    /*
    var handle: AuthStateDidChangeListenerHandle?
    
    func setTitleDisplay(_ user: User?) {
      if let name = user?.displayName {
        self.navigationItem.title = "Welcome \(name)"
      } else {
        self.navigationItem.title = "Authentication Example"
      }
    }
    */
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      // [START auth_listener]
      /*handle = Auth.auth().addStateDidChangeListener { (auth, user) in
        guard let user = user else{return}
        // [START_EXCLUDE]
        self.setTitleDisplay(user)
        //self.tableView.reloadData()
        // [END_EXCLUDE]
      }
      // [END auth_listener]
*/
      // Authenticate Game Center Local Player
      // Uncomment to sign in with Game Center
      // self.authenticateGameCenterLocalPlayer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        if Auth.auth().currentUser != nil {
          // User is signed in.
            //displayFullName.text = "Signed In"
            
            let user = Auth.auth().currentUser
            if let user = user {
              // The user's ID, unique to the Firebase project.
              // Do NOT use this value to authenticate with your backend server,
              // if you have one. Use getTokenWithCompletion:completion: instead.
                uid = user.uid
                /*
              let email = user.email
              var multiFactorString = "MultiFactor: "
              for info in user.multiFactor.enrolledFactors {
                multiFactorString += info.displayName ?? "[DispayName]"
                multiFactorString += " "
              }
              // ...
                */
                //displayFullName.text = uid
                fullName.text = "Welcome"
                
                let docRef = db.collection("users").document(uid)

                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        
                        let name = (document.data()!["first"] as! String) + " " + (document.data()!["last"] as! String)
                        self.displayFullName.text = name //document.data()!["last"] as! String
                    } else {
                        print("Document does not exist")
                    }
                }
                
            }
        } else {
          // No user is signed in.
          displayFullName.text = "Not signed In"
        }
        
    }
    
    func getDoc(completion: @escaping (_ res: [String]) -> Void) {
        let docRef = db.collection("queue").document("guestQueue")
        
        var doc = [String]()
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("Document Accessed")
                doc = (document.data()!["guests"]! as? [String])!
                
                completion(doc)
            } else {
                print("Document does not exist")
            }
        }
        //print("doc: \(doc)")
        //completion(doc)
        //return doc
    }
    
    @IBAction func joinQueueButton(_ sender: Any) {
        getDoc(){(res) in
            let docRef = self.db.collection("users").document(self.uid)

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    
                    let name = (document.data()!["first"] as! String) + " " + (document.data()!["last"] as! String)

                    let queueDoc = self.db.collection("queue").document("guestQueue")
                    
                    queueDoc.updateData([
                        "guests" : res + [name]
                    ]) { err in
                        if let err = err {
                            print("Error updating queue: \(err)")
                        } else {
                            print("\(name) joined the queue")
                        }
                    }
                } else {
                    print("Guest not found")
                }
            }
            
        }
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        print("Sign out button tapped")
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
