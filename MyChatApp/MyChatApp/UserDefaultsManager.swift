//
//  UserDefaultsManager.swift
//  MyChatApp
//
//  Created by iOS on 28/07/17.
//  Copyright © 2017 NTTData. All rights reserved.
//

import UIKit

class UserDefaultsManager: NSObject {
    let kLoggedInUser = "loggedInUser"
    let userDefaults = UserDefaults.standard
    static let shared = UserDefaultsManager()
    /**
     This property stores a loggedInUser(as a instance of class ChatUser) or nil value from UserDefaults.
     */
    var loggedInUser: ChatUser? {
        return getLoggedInUser() ?? nil
    }
   
    /**
        This method saves the user into UserDefaults as loggedInUser.
    
        This method accepts instance of a class ChatUser.
        To use it, simply call saveLoggedInUser(user: ChatUser).
     */
    func saveLoggedInUser(user: ChatUser) {
        let encodedUser = NSKeyedArchiver.archivedData(withRootObject: user)
        userDefaults.set(encodedUser, forKey: kLoggedInUser)
    }
    /**
     This method deletes chatUser instance stored as loggedInUser from UserDefaults.
     */
    func deleteLoggedInUser() {
        userDefaults.removeObject(forKey: kLoggedInUser)
    }
    /**
     This is a private method that is called by loggedInUser property
     */
    private func getLoggedInUser() -> ChatUser? {
        if let encodedUser = userDefaults.object(forKey: kLoggedInUser) as? Data {
            if let decodedUser = NSKeyedUnarchiver.unarchiveObject(with: encodedUser) as? ChatUser {
                return decodedUser
            }
        }
        return nil
    }
}
