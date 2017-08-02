//
//  NewMessageController.swift
//  MyChatApp
//
//  Created by iOS on 27/07/17.
//  Copyright © 2017 NTTData. All rights reserved.
//

import UIKit
import Firebase

class NewChatController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var chatUsersTableView = UITableView()
    var chatUsers = [ChatUser]()
    var chatsController: ChatsController?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        view.putBackgroundImage()
        configureTableView()
        edgesForExtendedLayout = []
        fetchUsers()
    }
    func fetchUsers() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: String] {
                let user = ChatUser(name: dictionary["name"]!, email: dictionary["email"]!, profileImageUrl: dictionary["profileImageUrl"]!, id: snapshot.key)
                    
                self.chatUsers.append(user)
                DispatchQueue.main.async {
                    self.chatUsersTableView.reloadData()
                }
            }
        })
    }
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }

    func configureTableView() {
        view.addSubview(chatUsersTableView)
        chatUsersTableView.backgroundColor = .clear
        chatUsersTableView.translatesAutoresizingMaskIntoConstraints = false
        chatUsersTableView.delegate = self
        chatUsersTableView.dataSource = self
        chatUsersTableView.separatorStyle = .none
        chatUsersTableView.register(ChatUserCell.self, forCellReuseIdentifier: "cellId")
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[chatTableView]|", options: .init(rawValue: 0), metrics: nil, views: ["chatTableView":chatUsersTableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[chatTableView]|", options: .init(rawValue: 0), metrics: nil, views: ["chatTableView":chatUsersTableView]))
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chatUser = chatUsers[indexPath.row]
        dismiss(animated: true) { 
            self.chatsController?.showChatLogControllerForUser(chatUser: chatUser)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
}
