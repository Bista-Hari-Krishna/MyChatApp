//
//  ViewController.swift
//  MyChatApp
//
//  Created by iOS on 22/07/17.
//  Copyright © 2017 NTTData. All rights reserved.
//

import UIKit
import Firebase

let profileImageViewTopSpace: CGFloat = 5.0
let profileImageViewLeftSpace:CGFloat = 10.0

class MessagesController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var backgroundImageView = UIImageView()
    var chatTableView = UITableView()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        checkIfLoggedIn()
        setupBackgroundImageView()
        setupTableView()
        edgesForExtendedLayout = []
    }
    func setupBackgroundImageView() {
        view.addSubview(backgroundImageView)
        backgroundImageView.image = UIImage(named: "3")
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroundImageView]|", options: .init(rawValue: 0), metrics: nil, views: ["backgroundImageView":backgroundImageView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundImageView]|", options: .init(rawValue: 0), metrics: nil, views: ["backgroundImageView":backgroundImageView]))
    }
    func setupTableView() {
        view.addSubview(chatTableView)
        chatTableView.backgroundColor = .clear
        chatTableView.translatesAutoresizingMaskIntoConstraints = false
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.separatorStyle = .none
        chatTableView.register(ChatListCell.self, forCellReuseIdentifier: "cellId")
       
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[chatTableView]|", options: .init(rawValue: 0), metrics: nil, views: ["chatTableView":chatTableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[chatTableView]|", options: .init(rawValue: 0), metrics: nil, views: ["chatTableView":chatTableView]))
    }
    
    func checkIfLoggedIn() {
        if let uid = Auth.auth().currentUser?.uid  {
            let ref = Database.database().reference(withPath: "users")
            let userRef = ref.child(uid)
            userRef.observe(.value, with: { (snapshot) in
                let values = snapshot.value as? [String:String]
                let name = values?["name"]
                let urlString = values?["url"] ?? ""
                if let downloadUrl = URL(string: urlString) {
                    self.navigationItem.title = name
                    let task = URLSession.shared.dataTask(with: downloadUrl, completionHandler: { (data, response, error) in
                        if let error = error {
                            print(error)
                            return
                        }
                        self.setUpNavigationBar(title: name!, image: UIImage(data: data!)!)
                    })
                    task.resume()
                }
                
                
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ChatListCell
        cell.profileImageView?.image = UIImage(named: "profile")
        cell.profileNameLabel?.text = "Dalli"
        
        let cellHeight = self.tableView(chatTableView, heightForRowAt: indexPath)
        let calculateCornerRadius = (cellHeight - (profileImageViewTopSpace * 2)) / 2.0
        cell.profileImageView?.layer.cornerRadius = calculateCornerRadius
        cell.profileImageView?.layer.masksToBounds = true
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }

}
class ChatListCell : UITableViewCell {
    var profileImageView: UIImageView?
    var profileNameLabel: UILabel?
    var separatorLine: UIView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupProfileImageView()
        setupProfileNameLabel()
        setupSeparatorLine()
    }
    func setupProfileImageView() {
        profileImageView = UIImageView()
        profileImageView?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(profileImageView!)
        
        profileImageView?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: profileImageViewLeftSpace).isActive = true
        profileImageView?.heightAnchor.constraint(equalTo: heightAnchor, constant: -(profileImageViewTopSpace * 2)).isActive = true
        profileImageView?.widthAnchor.constraint(equalTo: heightAnchor, constant: -(profileImageViewTopSpace * 2)).isActive = true
        profileImageView?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    func setupProfileNameLabel() {
        profileNameLabel = UILabel()
        addSubview(profileNameLabel!)
        profileNameLabel?.translatesAutoresizingMaskIntoConstraints = false
        profileNameLabel?.textColor = .white
        
        profileNameLabel?.leadingAnchor.constraint(equalTo: (profileImageView?.trailingAnchor)!, constant: 10).isActive = true
        profileNameLabel?.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
    }
    func setupSeparatorLine() {
        separatorLine = UIView()
        addSubview(separatorLine!)
        separatorLine?.translatesAutoresizingMaskIntoConstraints = false
        separatorLine?.backgroundColor = .white
        
        separatorLine?.leadingAnchor.constraint(equalTo: (profileNameLabel?.leadingAnchor)!).isActive = true
        separatorLine?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -profileImageViewLeftSpace).isActive = true
        separatorLine?.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        separatorLine?.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -0.5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
