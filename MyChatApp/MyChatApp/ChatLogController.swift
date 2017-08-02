//
//  ChatLogController.swift
//  MyChatApp
//
//  Created by iOS on 29/07/17.
//  Copyright © 2017 NTTData. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UIViewController {
    let inputTextField = UITextField(borderStyle: .none, textColor: .white, placeholderText: "Enter a message...", returnKeyType: .send)
    var chatUser: ChatUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.putBackgroundImage()
        configureInputsComponents()
        if let chatUser = chatUser {
            navigationItem.title = chatUser.name
        }
    }
    func configureInputsComponents() {
        let containerView = UIView()
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        containerView.addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setImage(UIImage(named:"send")!, for: .normal)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        sendButton.tintColor = .white
        sendButton.imageEdgeInsets = UIEdgeInsetsMake(5, 20, 5, 20)
        
        sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorLine = UIView()
        containerView.addSubview(separatorLine)
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.backgroundColor = .white
        
        separatorLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        separatorLine.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        separatorLine.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        separatorLine.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        
        
        containerView.addSubview(inputTextField)
        
        inputTextField.clearButtonMode = .whileEditing
        inputTextField.tintColor = .white
                
        inputTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        inputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor).isActive = true
        
        
    }
    func handleSend() {
        guard let messageText = inputTextField.text else {
            return
        }
        let ref = Database.database().reference().child("chats")
        let childRef = ref.childByAutoId()
        guard let fromId = Auth.auth().currentUser?.uid, let toId = chatUser?.id else {
            return
        }
        let timeStamp: NSNumber = NSNumber(value: Date.timeIntervalSinceReferenceDate)
        let values = ["text":messageText,"fromId":fromId,"toId":toId,"timeStamp":timeStamp] as [String : Any]
        childRef.updateChildValues(values)
        inputTextField.text = ""
        
    }
}
