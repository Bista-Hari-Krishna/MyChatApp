//
//  LoginController.swift
//  MyChatApp
//
//  Created by iOS on 22/07/17.
//  Copyright © 2017 NTTData. All rights reserved.
//

import UIKit

let textFieldHeight: CGFloat = 50
let borderLineHeight: CGFloat = 0.5
let profileImageHeight: CGFloat = 150
let viewPadding: CGFloat = 12
let containerPadding: CGFloat = 17
let containerHeight:CGFloat = 175

class LoginController: UIViewController {
    var backgroundImageView = UIImageView()
    var inputsContainerView = UIView()
    var loginRegisterButton = UIButton(type: .system)
    var nameTextField = UITextField()
    var emailTextField = UITextField()
    var passwordTextField = UITextField()
    var nameTextFieldBorderLine = UIView()
    var emailTextFieldBorderLine = UIView()
    var loginRegisterSegmentedControl = UISegmentedControl(items: ["Login","Register"])
    var profileImageView = UIImageView()
    var tapGesture: UITapGestureRecognizer?
    var imagePickerController = UIImagePickerController()
    
    
    var nameTextFieldHeight: NSLayoutConstraint?
    var nameTextFieldBorderLineHeight: NSLayoutConstraint?
    var inputsContainerViewHeight: NSLayoutConstraint?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        imagePickerController.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
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
        profileImageView.layer.cornerRadius = profileImageHeight/2.0
        profileImageView.layer.masksToBounds = true
        profileImageView.isUserInteractionEnabled = true
        
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -viewPadding).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: profileImageHeight).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: profileImageHeight).isActive = true
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        profileImageView.addGestureRecognizer(tapGesture!)
    }
    func setupLoginRegisterSegmentedControl() {
        view.addSubview(loginRegisterSegmentedControl)
        loginRegisterSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        loginRegisterSegmentedControl.tintColor = UIColor.white
        loginRegisterSegmentedControl.selectedSegmentIndex = 1
        
        loginRegisterSegmentedControl.addTarget(self, action: #selector(handleLoginRegisterChange(_:)), for: .valueChanged)
        
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -(viewPadding*2)).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -viewPadding).isActive = true
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
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -(viewPadding*2)).isActive = true
        inputsContainerViewHeight = inputsContainerView.heightAnchor.constraint(equalToConstant: containerHeight)
        inputsContainerViewHeight?.isActive = true
    }
    func setupNameTextField() {
        nameTextField = UITextField(borderStyle: .none, textColor: .white, placeholderText: "Name")
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameTextFieldBorderLine)
        nameTextField.clipsToBounds = true
      
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: viewPadding).isActive = true
        nameTextField.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -(containerPadding*2)).isActive = true
        nameTextFieldHeight = nameTextField.heightAnchor.constraint(equalToConstant: textFieldHeight)
        nameTextFieldHeight?.isActive = true
        
        nameTextFieldBorderLine.backgroundColor = .white
        nameTextFieldBorderLine.translatesAutoresizingMaskIntoConstraints = false
        nameTextFieldBorderLine.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameTextFieldBorderLine.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        nameTextFieldBorderLine.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -(containerPadding*2)).isActive = true
        nameTextFieldBorderLineHeight = nameTextFieldBorderLine.heightAnchor.constraint(equalToConstant: borderLineHeight)
        nameTextFieldBorderLineHeight?.isActive = true
    }
    func setupEmailTextField() {
        emailTextField = UITextField(borderStyle: .none, textColor: .white, placeholderText: "Email")
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailTextFieldBorderLine)
        
        emailTextField.topAnchor.constraint(equalTo: nameTextFieldBorderLine.bottomAnchor).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -(containerPadding*2)).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        emailTextFieldBorderLine.backgroundColor = .white
        emailTextFieldBorderLine.translatesAutoresizingMaskIntoConstraints = false
        emailTextFieldBorderLine.heightAnchor.constraint(equalToConstant: borderLineHeight).isActive = true
        emailTextFieldBorderLine.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailTextFieldBorderLine.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        emailTextFieldBorderLine.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -(containerPadding*2)).isActive = true
    }
    func setupPasswordTextField() {
        passwordTextField = UITextField(borderStyle: .none, textColor: .white, placeholderText: "Password")
        inputsContainerView.addSubview(passwordTextField)
        
        passwordTextField.isSecureTextEntry = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextFieldBorderLine.bottomAnchor).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -(containerPadding*2)).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
    }
    func setupLoginRegisterButton() {
        loginRegisterButton = UIButton(title: "REGISTER", cornerRadius: 20)
        view.addSubview(loginRegisterButton)
        loginRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        
        loginRegisterButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        loginRegisterButton.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: viewPadding).isActive = true
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
    convenience init(borderStyle: UITextBorderStyle, textColor: UIColor, placeholderText: String) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        let placeholder = NSAttributedString(string: placeholderText, attributes: [ NSForegroundColorAttributeName: textColor.withAlphaComponent(0.6) ])
        self.attributedPlaceholder = placeholder
        self.borderStyle = borderStyle
        self.textColor = textColor

    }
    
}
