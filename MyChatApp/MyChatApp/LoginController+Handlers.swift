//
//  LoginController+Handlers.swift
//  MyChatApp
//
//  Created by iOS on 24/07/17.
//  Copyright © 2017 NTTData. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {
    func handleLoginRegisterChange(_ sender: UISegmentedControl) {
        passwordTextField.text = ""
        nameTextField.text = ""
        loginRegisterButton.setTitle(loginRegisterSegmentedControl.titleForSegment(at: sender.selectedSegmentIndex), for: .normal)
        let selectedIndex = sender.selectedSegmentIndex
        
        inputsContainerViewHeight?.constant = (selectedIndex == 0 ? (inputsContainerViewHeight?.constant)! - (nameTextFieldHeight?.constant)! - (nameTextFieldBorderLineHeight?.constant)! : containerHeight)
        nameTextFieldHeight?.constant = (selectedIndex == 0 ? 0.0: textFieldHeight)
        nameTextFieldBorderLineHeight?.constant = (selectedIndex == 0 ? 0.0 : borderLineHeight)
    }
    func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        }else {
            handleRegister()
        }
    }

    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            if let uid = user?.uid {
                self.setLoggedInUserWithUID(uid: uid)
            }
            
//            if (Auth.auth().currentUser?.isEmailVerified)! {
//                self.dismiss(animated: true, completion: nil)
//            }else {
//                let emailVerificationController = EmailVerificationController()
//                emailVerificationController.headerMessage = "Your email has not been verified"
//                self.present(emailVerificationController, animated: true, completion: nil)
//            }
            
        }
    }
    func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let uid = user?.uid else {
                return
            }
            
            let storageRef = Storage.storage().reference().child("Profile_images")
            let fileName = NSUUID().uuidString
            let profileRef = storageRef.child("\(fileName).jpg")
            guard let imageData = UIImageJPEGRepresentation(self.profileImageView.image!, 1.0) else {
                print("No profile Image")
                return
            }
            profileRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                guard let metadata = metadata else {
                    print(error!)
                    return
                }
                if let profileImageUrl = metadata.downloadURL()?.absoluteString {
                    let values = ["name":name, "email":email,"profileImageUrl":profileImageUrl]
                    self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
                }
                
            })
            
        })
    }
    func setLoggedInUserWithUID(uid: String) {
        let ref = Database.database().reference(withPath: "users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:String] {
                let user = ChatUser(name: dictionary["name"]!, email: dictionary["email"]!, profileImageUrl: dictionary["profileImageUrl"]!)
                UserDefaultManager.shared.saveLoggedInUser(user: user)
            }
            self.dismiss(animated: true, completion: nil)
        })
    }
    func registerUserIntoDatabaseWithUID(uid: String, values: [String: String]) {
        let ref = Database.database().reference()
        let userReference = ref.child("users").child(uid)

        userReference.setValue(values, withCompletionBlock: { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            self.setLoggedInUserWithUID(uid: uid)
            
            //                    let emailVerificationController = EmailVerificationController()
            //                    emailVerificationController.headerMessage = "Thank you for Registering"
            //                    self.present(emailVerificationController, animated: true, completion: nil)
            //
        })

    }
    func handleTap(_ gesture: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: nil, message: "Choose", preferredStyle: .actionSheet)
        let photoAlbumAction = UIAlertAction(title: "Photo Album", style: .default) { (action) in
            self.profilePicFromLibrary()
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.profilePicFromCamera()
        }
        let dismiss = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alertController.addAction(photoAlbumAction)
        alertController.addAction(cameraAction)
        alertController.addAction(dismiss)
        present(alertController, animated: true, completion: nil)
    }
    func profilePicFromLibrary() {
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePickerController, animated: true, completion: nil)
    }
    func profilePicFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.allowsEditing = true
            imagePickerController.sourceType = .camera
            imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            present(imagePickerController, animated: true, completion: nil)
        }
    }
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    func keyBoardWillShow(notification: Notification) {
        let keyBoardFrame = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        if let activeTextField = activeTextField {
            let relativeTextFieldFrame = activeTextField.convert(activeTextField.bounds, to: view)
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: (keyBoardFrame?.height)!, right: 0)
            scrollView.contentInset = contentInset
            scrollView.scrollIndicatorInsets = contentInset
            
            var aRect = view.frame
            aRect.size.height -= ((keyBoardFrame?.height)! + 10 )
            if !aRect.contains(relativeTextFieldFrame.origin) {
                scrollView.scrollRectToVisible(relativeTextFieldFrame, animated: true)
            }
        }
    }
    func keyBoardWillHide(notification: Notification) {
        let keyBoardFrame = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -(keyBoardFrame?.height)!, right: 0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }

    
    //MARK: - UIImagePickerController delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let profileImage = info[UIImagePickerControllerEditedImage] as! UIImage
        profileImageView.image = profileImage
        dismiss(animated: true, completion: nil)
    }
    //MARK: - UItextfield delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == nameTextField {
            emailTextField.becomeFirstResponder()
        }else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
}
