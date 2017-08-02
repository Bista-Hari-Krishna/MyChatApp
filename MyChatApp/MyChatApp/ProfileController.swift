//
//  ProfileController.swift
//  MyChatApp
//
//  Created by iOS on 28/07/17.
//  Copyright © 2017 NTTData. All rights reserved.
//

import UIKit

class ProfileController: UITableViewController {
    var loggedInUser: ChatUser?
    let cellId = "cellId"
    var profileDetails = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loggedInUser = UserDefaultsManager.shared.loggedInUser
        profileDetails = [loggedInUser?.name ?? "", loggedInUser?.email ?? "", "logout"]
//        if let user = loggedInUser {
//            profileDetails = [user.name,user.email,"logout"]
//        }
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.isScrollEnabled = false
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileDetails.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
        cell.textLabel?.text = profileDetails[indexPath.row]
        cell.textLabel?.textAlignment = .center
        if indexPath.row != 2 {
            cell.selectionStyle = .none
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        let profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        profileImageView.layer.cornerRadius = 40
        profileImageView.layer.masksToBounds = true
        if let loggedInUser = loggedInUser {
            profileImageView.loadImageUsingCacheWithUrlString(urlString: loggedInUser.profileImageUrl)
        }else {
            profileImageView.image = UIImage(named: "profile2")
        }
        
        backgroundView.addSubview(profileImageView)
        profileImageView.center = backgroundView.center
        return backgroundView
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            dismiss(animated: true, completion: {
                let notificationName = Notification.Name("logout")
                NotificationCenter.default.post(name: notificationName, object: nil)
            })
        }
    }
}
