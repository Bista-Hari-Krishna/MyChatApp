//
//  ViewController.swift
//  MyChatApp
//
//  Created by iOS on 22/07/17.
//  Copyright © 2017 NTTData. All rights reserved.
//

import UIKit
import Firebase



class MessagesController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var backgroundImageView = UIImageView()
    var messagesTableView = UITableView()
    var newMessageButton =  UIButton(type: .custom)
    var profileIconImageView = UIImageView()
    var profileController =  ProfileController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        setupUI()
        edgesForExtendedLayout = []
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(handleLogout))
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = UserDefaultManager.shared.loggedInUser {
            showNavigationBarInfo(for: user)
        }
        let notificationName = Notification.Name("logout")
        NotificationCenter.default.addObserver(self, selector: #selector(handleLogout), name: notificationName, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    func setupUI() {
        setupProfileIcon()
        setupBackgroundImageView()
        setupTableView()
        setupNewMessageButton()
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
    func setupProfileIcon() {
        profileIconImageView.layer.cornerRadius = 17.5
        profileIconImageView.layer.masksToBounds = true
        profileIconImageView.contentMode = .scaleAspectFill
        profileIconImageView.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        profileIconImageView.isUserInteractionEnabled = true
        profileIconImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewProfileInfo)))
        
        let profileIconBarButtonItem = UIBarButtonItem(customView: profileIconImageView)
        navigationItem.rightBarButtonItem = profileIconBarButtonItem
    }
    func showNavigationBarInfo(for chatUser: ChatUser) {
        navigationItem.title = chatUser.name
        profileIconImageView.loadImageUsingCacheWithUrlString(urlString: chatUser.profileImageUrl)
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
        guard let uid = Auth.auth().currentUser?.uid else {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            return
        }
        let ref = Database.database().reference(withPath: "users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:String] {
               let user = ChatUser(name: dictionary["name"]!, email: dictionary["email"]!, profileImageUrl: dictionary["profileImageUrl"]!)
                UserDefaultManager.shared.saveLoggedInUser(user: user)
                self.showNavigationBarInfo(for: user)
            }
        })
    }
    func handleLogout() {
        do {
            try Auth.auth().signOut()
            UserDefaultManager.shared.deleteLoggedInUser()
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
extension MessagesController: UITableViewDataSource, UITableViewDelegate {
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
