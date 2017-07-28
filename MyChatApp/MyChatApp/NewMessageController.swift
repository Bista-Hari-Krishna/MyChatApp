//
//  NewMessageController.swift
//  MyChatApp
//
//  Created by iOS on 27/07/17.
//  Copyright © 2017 NTTData. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var backgroundImageView = UIImageView()
    var newMessageTableView = UITableView()
    var chatUsers = [ChatUser]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        setupBackgroundImageView()
        setupTableView()
        edgesForExtendedLayout = []
        fetchUsers()
    }
    func fetchUsers() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: String] {
                let user = ChatUser(name: dictionary["name"]!, email: dictionary["email"]!, profileImageUrl: dictionary["profileImageUrl"]!)
                    
                self.chatUsers.append(user)
                DispatchQueue.main.async {
                    self.newMessageTableView.reloadData()
                }
            }
        })
    }
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    func setupBackgroundImageView() {
        view.addSubview(backgroundImageView)
        backgroundImageView.image = UIImage(named: "3")
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroundImageView]|", options: .init(rawValue: 0), metrics: nil, views: ["backgroundImageView":backgroundImageView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundImageView]|", options: .init(rawValue: 0), metrics: nil, views: ["backgroundImageView":backgroundImageView]))
    }

    func setupTableView() {
        view.addSubview(newMessageTableView)
        newMessageTableView.backgroundColor = .clear
        newMessageTableView.translatesAutoresizingMaskIntoConstraints = false
        newMessageTableView.delegate = self
        newMessageTableView.dataSource = self
        newMessageTableView.separatorStyle = .none
        newMessageTableView.register(ChatUserCell.self, forCellReuseIdentifier: "cellId")
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[chatTableView]|", options: .init(rawValue: 0), metrics: nil, views: ["chatTableView":newMessageTableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[chatTableView]|", options: .init(rawValue: 0), metrics: nil, views: ["chatTableView":newMessageTableView]))
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatUsers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ChatUserCell
        let chatUser = chatUsers[indexPath.row]
        cell.textLabel?.text = chatUser.name
        cell.detailTextLabel?.text = chatUser.email
        cell.profileImageView?.loadImageUsingCacheWithUrlString(urlString: chatUser.profileImageUrl)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
}
