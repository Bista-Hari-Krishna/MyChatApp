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
         checkIfLoggedIn()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    func checkIfLoggedIn() {
        if let uid = Auth.auth().currentUser?.uid  {
            let ref = Database.database().reference(withPath: "users")
            let userRef = ref.child(uid)
            userRef.observe(.value, with: { (snapshot) in
                let values = snapshot.value as? [String:String]
                let name = values?["name"]
                let urlString = values?["url"]
                let downloadUrl = URL(string: urlString!)
                self.navigationItem.title = name
                let task = URLSession.shared.dataTask(with: downloadUrl!, completionHandler: { (data, response, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    self.setUpNavigationBar(title: name!, image: UIImage(data: data!)!)
                })
                task.resume()
                
            })
        }else {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
 
    }
    func setUpNavigationBar(title:String,image: UIImage) {
        navigationItem.title = title
//        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
//        let profileImageView = UIImageView()
//        profileImageView.image = image
//        titleView.addSubview(profileImageView)
//        let titleLabel = UILabel()
//        navigationItem.titleView = titleView
//        
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

