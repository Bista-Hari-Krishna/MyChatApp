//
//  UserCell.swift
//  MyChatApp
//
//  Created by iOS on 27/07/17.
//  Copyright © 2017 NTTData. All rights reserved.
//

import UIKit

class ChatUserCell : UITableViewCell {
    var profileImageView: UIImageView?
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 70, y: (textLabel?.frame.origin.y)! - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        detailTextLabel?.frame = CGRect(x: 70, y: (detailTextLabel?.frame.origin.y)! + 2, width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupProfileImageView()
        setupSeparatorLine()
        textLabel?.textColor = .white
        detailTextLabel?.textColor = .white
    }
    func setupProfileImageView() {
        profileImageView = UIImageView()
        profileImageView?.translatesAutoresizingMaskIntoConstraints = false
        profileImageView?.contentMode = .scaleAspectFill
        addSubview(profileImageView!)
        
        profileImageView?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        profileImageView?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView?.layer.cornerRadius = 25
        profileImageView?.layer.masksToBounds = true
    }
//    func setupProfileNameLabel() {
//        profileNameLabel = UILabel()
//        addSubview(profileNameLabel!)
//        profileNameLabel?.translatesAutoresizingMaskIntoConstraints = false
//        profileNameLabel?.textColor = .white
//        
//        profileNameLabel?.leadingAnchor.constraint(equalTo: (profileImageView?.trailingAnchor)!, constant: 10).isActive = true
//        profileNameLabel?.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
//    }
    func setupSeparatorLine() {
        let separatorLine = UIView()
        addSubview(separatorLine)
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.backgroundColor = .white
        
        separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70).isActive = true
        separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        separatorLine.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -0.5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
