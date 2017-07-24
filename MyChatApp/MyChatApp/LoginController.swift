//
//  LoginController.swift
//  MyChatApp
//
//  Created by iOS on 22/07/17.
//  Copyright © 2017 NTTData. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    var backgroundImageView: UIImageView = UIImageView()
    var inputsContainerView: UIView = UIView()
    var loginRegisterButton: UIButton = UIButton(type: .system)
    var nameTextField: UITextField = UITextField()
    var emailTextField: UITextField = UITextField()
    var passwordTextField: UITextField = UITextField()
    var nameTextFieldBorderLine: UIView = UIView()
    var emailTextFieldBorderLine: UIView = UIView()
    var loginRegisterSegmentedControl: UISegmentedControl = UISegmentedControl(items: ["Login","Register"])
    var profileImageView: UIImageView = UIImageView()
    var tapGesture: UITapGestureRecognizer?
    var imagePickerController: UIImagePickerController = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        imagePickerController.delegate = self
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func setupUI() {
        setupBackgroundImageView()
        setupInputsContainerView()
        setupLoginRegisterSegmentedControl()
        setupProfileImageView()
        setupNameTextField()
        setupEmailTextField()
        setupPasswordTextField()
        setupLoginRegisterButton()
    }
    func setupBackgroundImageView() {
        view.addSubview(backgroundImageView)
        backgroundImageView.image = UIImage(named: "3")
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroundImageView]|", options: .init(rawValue: 0), metrics: nil, views: ["backgroundImageView":backgroundImageView]))
         view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundImageView]|", options: .init(rawValue: 0), metrics: nil, views: ["backgroundImageView":backgroundImageView]))
    }
    func setupProfileImageView() {
        view.addSubview(profileImageView)
        profileImageView.image = UIImage(named: "profile")
        profileImageView.contentMode = .scaleToFill
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 150.0/2.0
        profileImageView.layer.masksToBounds = true
        profileImageView.isUserInteractionEnabled = true
        
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        profileImageView.addGestureRecognizer(tapGesture!)
    }
    func setupLoginRegisterSegmentedControl() {
        view.addSubview(loginRegisterSegmentedControl)
        loginRegisterSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        loginRegisterSegmentedControl.tintColor = UIColor.white
        loginRegisterSegmentedControl.selectedSegmentIndex = 0
       
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
    }
    func setupInputsContainerView() {
        view.addSubview(inputsContainerView)
        inputsContainerView.translatesAutoresizingMaskIntoConstraints = false
        inputsContainerView.backgroundColor = .clear
        inputsContainerView.layer.borderWidth = 1.0
        inputsContainerView.layer.borderColor = UIColor.white.cgColor
        inputsContainerView.layer.cornerRadius = 40
        inputsContainerView.layer.masksToBounds = true
        
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 175).isActive = true
    }
    func setupNameTextField() {
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameTextFieldBorderLine)

        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.textColor = .white
        nameTextField.setAttributedPlaceholder(with: "Name")
        nameTextField.borderStyle = .none
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: 12).isActive = true
        nameTextField.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -34).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        nameTextFieldBorderLine.backgroundColor = .white
        nameTextFieldBorderLine.translatesAutoresizingMaskIntoConstraints = false
        nameTextFieldBorderLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        nameTextFieldBorderLine.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameTextFieldBorderLine.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        nameTextFieldBorderLine.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -34).isActive = true
    }
    func setupEmailTextField() {
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailTextFieldBorderLine)
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.textColor = .white
        emailTextField.setAttributedPlaceholder(with: "Email")
        emailTextField.borderStyle = .none
        emailTextField.topAnchor.constraint(equalTo: nameTextFieldBorderLine.bottomAnchor).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -34).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        emailTextFieldBorderLine.backgroundColor = .white
        emailTextFieldBorderLine.translatesAutoresizingMaskIntoConstraints = false
        emailTextFieldBorderLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        emailTextFieldBorderLine.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailTextFieldBorderLine.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        emailTextFieldBorderLine.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -34).isActive = true
    }
    func setupPasswordTextField() {
        inputsContainerView.addSubview(passwordTextField)
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.textColor = .white
        passwordTextField.setAttributedPlaceholder(with: "Password")
        passwordTextField.borderStyle = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextFieldBorderLine.bottomAnchor).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -34).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
    func setupLoginRegisterButton() {
        view.addSubview(loginRegisterButton)
        loginRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        loginRegisterButton.backgroundColor = .clear
        loginRegisterButton.layer.cornerRadius = 20
        loginRegisterButton.layer.borderWidth = 1.0
        loginRegisterButton.layer.borderColor = UIColor.white.cgColor
        loginRegisterButton.setTitle("LOGIN", for: .normal)
        loginRegisterButton.setTitleColor(.white, for: .normal)
        loginRegisterButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red:r/255 ,green:g/255, blue:b/255, alpha:1)
    }
}
extension UITextField {
    
    func setAttributedPlaceholder(with placeholderText:String) {
        let placeholder = NSAttributedString(string: placeholderText, attributes: [ NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.6) ])
        attributedPlaceholder = placeholder
    }
}
