//
//  ViewController.swift
//  MyChatApp
//
//  Created by iOS on 22/07/17.
//  Copyright © 2017 NTTData. All rights reserved.
//

import UIKit
import Firebase


var loggedInUser: String?
class MessagesController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var backgroundImageView = UIImageView()
    var messagesTableView = UITableView()
    var newMessageButton =  UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New message", style: .plain, target: self, action: #selector(handleNewMessage))
        checkIfUserIsLoggedIn()
        setupBackgroundImageView()
        setupTableView()
        setupNewMessageButton()
        edgesForExtendedLayout = []
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let loggedInUser = loggedInUser {
            navigationItem.title = loggedInUser
        }
    }
    func setupNewMessageButton() {
        view.addSubview(newMessageButton)
        newMessageButton.translatesAutoresizingMaskIntoConstraints = false
        newMessageButton.setImage(UIImage(named:"newMsg"), for: .normal)
        view.bringSubview(toFront: newMessageButton)
        newMessageButton.addTarget(self, action: #selector(handleNewMessage), for: .touchUpInside)
        
        newMessageButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        newMessageButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        newMessageButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        newMessageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    func setupBackgroundImageView() {
        view.addSubview(backgroundImageView)
        backgroundImageView.image = UIImage(named: "3")
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroundImageView]|", options: .init(rawValue: 0), metrics: nil, views: ["backgroundImageView":backgroundImageView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundImageView]|", options: .init(rawValue: 0), metrics: nil, views: ["backgroundImageView":backgroundImageView]))
    }
    func handleNewMessage() {
        let navigationController = NavigationController(rootViewController: NewMessageController())
        present(navigationController, animated: true, completion: nil)
    }
    func setupTableView() {
        view.addSubview(messagesTableView)
        messagesTableView.backgroundColor = .clear
        messagesTableView.translatesAutoresizingMaskIntoConstraints = false
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        messagesTableView.separatorStyle = .none
        messagesTableView.register(ChatUserCell.self, forCellReuseIdentifier: "cellId")
       
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[messagesTableView]|", options: .init(rawValue: 0), metrics: nil, views: ["messagesTableView":messagesTableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[messagesTableView]|", options: .init(rawValue: 0), metrics: nil, views: ["messagesTableView":messagesTableView]))
    }
    
    func checkIfUserIsLoggedIn() {
        if let uid = Auth.auth().currentUser?.uid  {
            let ref = Database.database().reference(withPath: "users").child(uid)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let values = snapshot.value as? [String:AnyObject]
                let name = values?["name"] as? String ?? ""
                self.navigationItem.title = name
            })
            
//            userRef.observe(.value, with: { (snapshot) in
//                let values = snapshot.value as? [String:String]
//                let name = values?["name"]
//                self.navigationItem.title = name
//                let urlString = values?["url"] ?? ""
//                if let downloadUrl = URL(string: urlString) {
//                    self.navigationItem.title = name
//                    let task = URLSession.shared.dataTask(with: downloadUrl, completionHandler: { (data, response, error) in
//                        if let error = error {
//                            print(error)
//                            return
//                        }
//                        self.setUpNavigationBar(title: name!, image: UIImage(data: data!)!)
//                    })
//                    task.resume()
//                }
//                
                
//            })
        }else {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            loggedInUser = nil
        }
 
    }
    func setUpNavigationBar(title:String,image: UIImage) {
        DispatchQueue.main.async {
            self.navigationItem.title = title
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ChatUserCell
        cell.profileImageView?.image = UIImage(named: "profile")
        cell.textLabel?.text = "Dalli"
        cell.detailTextLabel?.text = "krish7hari@gmail.com"
       
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }

}
