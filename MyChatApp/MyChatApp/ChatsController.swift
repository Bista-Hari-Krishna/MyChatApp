//
//  ViewController.swift
//  MyChatApp
//
//  Created by iOS on 22/07/17.
//  Copyright © 2017 NTTData. All rights reserved.
//

import UIKit
import Firebase



class ChatsController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var chatsTableView = UITableView()
    var newChatButton =  UIButton(type: .custom)
    var profileIconImageView = UIImageView()
    var profileController =  ProfileController()
    var chats = [Chats]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        configureUI()
        edgesForExtendedLayout = []
        fetchUserChats()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = UserDefaultsManager.shared.loggedInUser {
            showNavigationBarInfo(for: user)
        }
        let notificationName = Notification.Name("logout")
        NotificationCenter.default.addObserver(self, selector: #selector(handleLogout), name: notificationName, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    func fetchUserChats() {
        let ref = Database.database().reference().child("chats")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let chat = Chats()
                chat.setValuesForKeys(dictionary)
                self.chats.append(chat)
                DispatchQueue.main.async {
                    self.chatsTableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    func configureUI() {
        view.putBackgroundImage()
        configureProfileIcon()
        configureTableView()
        configureNewChatButton()
        profileController.modalPresentationStyle = .popover
        profileController.preferredContentSize = CGSize(width: 200, height: 230)
    }
    func viewProfileInfo() {
        let popOver = profileController.popoverPresentationController
        popOver?.permittedArrowDirections = .up
        popOver?.delegate = self
        popOver?.sourceView = profileIconImageView
        popOver?.sourceRect = profileIconImageView.bounds
        present(profileController, animated: true, completion: nil)
    }
    func configureProfileIcon() {
        profileIconImageView.layer.cornerRadius = 17.5
        profileIconImageView.layer.masksToBounds = true
        profileIconImageView.contentMode = .scaleAspectFill
        profileIconImageView.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        profileIconImageView.isUserInteractionEnabled = true
        profileIconImageView.image = UIImage(named: "profile2")
        profileIconImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewProfileInfo)))
        
        let profileIconBarButtonItem = UIBarButtonItem(customView: profileIconImageView)
        navigationItem.rightBarButtonItem = profileIconBarButtonItem
    }
    func showNavigationBarInfo(for chatUser: ChatUser) {
        navigationItem.title = chatUser.name
        profileIconImageView.loadImageUsingCacheWithUrlString(urlString: chatUser.profileImageUrl)
    }
    func configureNewChatButton() {
        view.addSubview(newChatButton)
        newChatButton.translatesAutoresizingMaskIntoConstraints = false
        newChatButton.setImage(UIImage(named:"newMsg"), for: .normal)
        view.bringSubview(toFront: newChatButton)
        newChatButton.addTarget(self, action: #selector(handleNewChat), for: .touchUpInside)
        
        newChatButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        newChatButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        newChatButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        newChatButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    func handleNewChat() {
        let newChatController = NewChatController()
        newChatController.chatsController = self
        let navigationController = NavigationController(rootViewController: newChatController)
        present(navigationController, animated: true, completion: nil)
    }
    func configureTableView() {
        view.addSubview(chatsTableView)
        chatsTableView.backgroundColor = .clear
        chatsTableView.translatesAutoresizingMaskIntoConstraints = false
        chatsTableView.delegate = self
        chatsTableView.dataSource = self
        chatsTableView.separatorStyle = .none
        chatsTableView.register(ChatUserCell.self, forCellReuseIdentifier: "cellId")
       
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[chatsTableView]|", options: .init(rawValue: 0), metrics: nil, views: ["chatsTableView":chatsTableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[chatsTableView]|", options: .init(rawValue: 0), metrics: nil, views: ["chatsTableView":chatsTableView]))
    }
    func showChatLogControllerForUser(chatUser: ChatUser) {
        let chatLogController = ChatLogController()
        chatLogController.chatUser = chatUser
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    func checkIfUserIsLoggedIn() {
        guard let uid = Auth.auth().currentUser?.uid else {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            return
        }
        let ref = Database.database().reference(withPath: "users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:String] {
                let user = ChatUser(name: dictionary["name"]!, email: dictionary["email"]!, profileImageUrl: dictionary["profileImageUrl"]!, id: snapshot.key)
                UserDefaultsManager.shared.saveLoggedInUser(user: user)
                self.showNavigationBarInfo(for: user)
            }
        })
    }
    func handleLogout() {
        do {
            try Auth.auth().signOut()
            UserDefaultsManager.shared.deleteLoggedInUser()
        }catch let logoutError {
            print(logoutError)
        }
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }

    //MARK:- UIPopOverControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }

}
extension ChatsController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ChatUserCell
       // cell.profileImageView?.image = UIImage(named: "profile")
        let chat = chats[indexPath.row]
        cell.detailTextLabel?.text = chat.text
        
        let ref = Database.database().reference().child("users").child(chat.toId!)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                cell.textLabel?.text = dictionary["name"] as? String
                cell.profileImageView?.loadImageUsingCacheWithUrlString(urlString: (dictionary["profileImageUrl"] as? String)!)
            }
        })
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}
