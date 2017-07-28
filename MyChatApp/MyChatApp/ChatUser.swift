//
//  User.swift
//  MyChatApp
//
//  Created by iOS on 27/07/17.
//  Copyright © 2017 NTTData. All rights reserved.
//

import UIKit

class ChatUser: NSObject, NSCoding {
    var name: String
    var email: String
    var profileImageUrl: String
    var id: String
    
    init(name: String, email: String, profileImageUrl: String, id: String) {
        self.name = name
        self.email = email
        self.profileImageUrl = profileImageUrl
        self.id = id
    }
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let profileImageUrl = aDecoder.decodeObject(forKey: "profileImageUrl") as! String
        let id = aDecoder.decodeObject(forKey: "id") as! String
        self.init(name: name, email: email, profileImageUrl: profileImageUrl,id: id)
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(profileImageUrl, forKey: "profileImageUrl")
        aCoder.encode(id, forKey: "id")
    }
}

