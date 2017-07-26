//
//  ViewController.swift
//  MyChatApp
//
//  Created by iOS on 22/07/17.
//  Copyright © 2017 NTTData. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var backgroundImageView = UIImageView()
    var tableView = UITableView()
    
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
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(customCell.self, forCellReuseIdentifier: "cellId")
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: .init(rawValue: 0), metrics: nil, views: ["tableView":tableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: .init(rawValue: 0), metrics: nil, views: ["tableView":tableView]))
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
//        let loginController = LoginController()
//        present(loginController, animated: true, completion: nil)
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! customCell
        cell.textLabel?.text = "Winter is coming"
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.imageView?.image = UIImage(named: "profile")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }

}
class customCell : UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.imageView?.layer.cornerRadius = 22.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
