//
//  UserDefaultManager.swift
//  MyChatApp
//
//  Created by iOS on 28/07/17.
//  Copyright © 2017 NTTData. All rights reserved.
//

import UIKit

class UserDefaultManager: NSObject {
    let kLoggedInUser = "loggedInUser"
    let userDefaults = UserDefaults.standard
    static let shared = UserDefaultManager()
    var loggedInUser: ChatUser? {
        return getLoggedInUser() ?? nil
    }
    func saveLoggedInUser(user: ChatUser) {
        let encodedUser = NSKeyedArchiver.archivedData(withRootObject: user)
        userDefaults.set(encodedUser, forKey: kLoggedInUser)
    }
    func deleteLoggedInUser() {
        userDefaults.removeObject(forKey: kLoggedInUser)
    }
    private func getLoggedInUser() -> ChatUser? {
        if let encodedUser = userDefaults.object(forKey: kLoggedInUser) as? Data {
            if let decodedUser = NSKeyedUnarchiver.unarchiveObject(with: encodedUser) as? ChatUser {
                return decodedUser
            }
        }
        return nil
    }
}
