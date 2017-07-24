//
//  LoginController+Handlers.swift
//  MyChatApp
//
//  Created by iOS on 24/07/17.
//  Copyright © 2017 NTTData. All rights reserved.
//

import Foundation
import UIKit

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
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
    
    //MARK: - UIImagePickerController delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let profileImage = info[UIImagePickerControllerEditedImage] as! UIImage
        profileImageView.image = profileImage
        dismiss(animated: true, completion: nil)
    }
}
