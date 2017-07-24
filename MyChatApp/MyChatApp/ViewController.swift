//
//  ViewController.swift
//  MyChatApp
//
//  Created by iOS on 22/07/17.
//  Copyright © 2017 NTTData. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        if let uid = Auth.auth().currentUser?.uid  {
            let ref = Database.database().reference(withPath: "users")
            let userRef = ref.child(uid)
            userRef.observe(.value, with: { (snapshot) in
                let values = snapshot.value as? [String:String]
                let name = values?["name"] ?? ""
                self.navigationItem.title = name
            })
        }else {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
    }
    func handleLogout() {
        do {
            try Auth.auth().signOut()
        }catch let logoutError {
            print(logoutError)
        }
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
        
    }

}

