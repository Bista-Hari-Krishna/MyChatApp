//
//  UserCell.swift
//  MyChatApp
//
//  Created by iOS on 27/07/17.
//  Copyright © 2017 NTTData. All rights reserved.
//

import UIKit
/**
  It subclasses the UITableViewCell.
  This cell has a circular profileImageView and default textlabel and detailTextlabel.
  */
class ChatUserCell : UITableViewCell {
    var profileImageView: UIImageView?
    var timeStampLabel: UILabel?
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 70, y: (textLabel?.frame.origin.y)! - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)  //override textLabel frame
        detailTextLabel?.frame = CGRect(x: 70, y: (detailTextLabel?.frame.origin.y)! + 2, width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!) //override detailTextLabel frame
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        configureProfileImageView()
        configureTimeStampLabel()
        configureSeparatorLine()
        textLabel?.textColor = .white
        detailTextLabel?.textColor = .white
        selectedBackgroundView = UIView(frame: bounds)
        selectedBackgroundView?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
    private func configureProfileImageView() {
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
    private func configureTimeStampLabel() {
        timeStampLabel = UILabel()
        addSubview(timeStampLabel!)
        timeStampLabel?.textColor = .white
        timeStampLabel?.font = UIFont.systemFont(ofSize: 12)
        timeStampLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        timeStampLabel?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        timeStampLabel?.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
    }
    private func configureSeparatorLine() {
        let separatorLine = UIView()
        addSubview(separatorLine)
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.backgroundColor = .white
        
        separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70).isActive = true
        separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        separatorLine.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -0.5).isActive = true
    }
    override func prepareForReuse() {
        profileImageView?.image = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
