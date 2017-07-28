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
   
    var inputsContainerView = UIView()
    var loginRegisterButton = UIButton(type: .system)
    var nameTextField = UITextField()
    var emailTextField = UITextField()
    var passwordTextField = UITextField()
    var activeTextField: UITextField?
    
    var nameTextFieldBorderLine = UIView()
    var emailTextFieldBorderLine = UIView()
    var loginRegisterSegmentedControl = UISegmentedControl(items: ["Login","Register"])
    var profileImageView = UIImageView()
    var tapGesture: UITapGestureRecognizer?
    var imagePickerController = UIImagePickerController()
    var scrollView = UIScrollView()
    
    var nameTextFieldHeight: NSLayoutConstraint?
    var nameTextFieldBorderLineHeight: NSLayoutConstraint?
    var inputsContainerViewHeight: NSLayoutConstraint?
  

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupObservers()
        imagePickerController.delegate = self
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
    }

    func setupUI() {
        view.putBackgroundImage()
        setupScrollView()
        setupInputsContainerView()
        setupLoginRegisterSegmentedControl()
        setupProfileImageView()
        setupNameTextField()
        setupEmailTextField()
        setupPasswordTextField()
        setupLoginRegisterButton()
    }
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.contentSize = view.bounds.size
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: .init(rawValue: 0), metrics: nil, views: ["scrollView":scrollView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|", options: .init(rawValue: 0), metrics: nil, views: ["scrollView":scrollView]))
        
    }
    func setupProfileImageView() {
        scrollView.addSubview(profileImageView)
        profileImageView.image = UIImage(named: "profile")
        profileImageView.contentMode = .scaleToFill
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = profileImageHeight/2.0
        profileImageView.layer.masksToBounds = true
        profileImageView.isUserInteractionEnabled = true
        
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -viewPadding).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: profileImageHeight).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: profileImageHeight).isActive = true
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        profileImageView.addGestureRecognizer(tapGesture!)
    }
    func setupLoginRegisterSegmentedControl() {
        scrollView.addSubview(loginRegisterSegmentedControl)
        loginRegisterSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        loginRegisterSegmentedControl.tintColor = UIColor.white
        loginRegisterSegmentedControl.selectedSegmentIndex = 1
        
        loginRegisterSegmentedControl.addTarget(self, action: #selector(handleLoginRegisterChange(_:)), for: .valueChanged)
        
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -(viewPadding*2)).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -viewPadding).isActive = true
    }
    func setupInputsContainerView() {
        scrollView.addSubview(inputsContainerView)
        inputsContainerView.translatesAutoresizingMaskIntoConstraints = false
        inputsContainerView.backgroundColor = .clear
        inputsContainerView.layer.borderWidth = 1.0
        inputsContainerView.layer.borderColor = UIColor.white.cgColor
        inputsContainerView.layer.cornerRadius = 40
        inputsContainerView.layer.masksToBounds = true
        
        inputsContainerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: 40).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -(viewPadding*2)).isActive = true
        inputsContainerViewHeight = inputsContainerView.heightAnchor.constraint(equalToConstant: containerHeight)
        inputsContainerViewHeight?.isActive = true
    }
    func setupNameTextField() {
        nameTextField = UITextField(borderStyle: .none, textColor: .white, placeholderText: "Name", returnKeyType: .next)
        nameTextField.delegate = self
        
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
        emailTextField = UITextField(borderStyle: .none, textColor: .white, placeholderText: "Email",returnKeyType: .next)
        emailTextField.delegate = self
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
        passwordTextField = UITextField(borderStyle: .none, textColor: .white, placeholderText: "Password", returnKeyType: .done)
        passwordTextField.delegate = self
        inputsContainerView.addSubview(passwordTextField)
        
        passwordTextField.isSecureTextEntry = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextFieldBorderLine.bottomAnchor).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -(containerPadding*2)).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
    }
    func setupLoginRegisterButton() {
        loginRegisterButton = UIButton(title: "REGISTER", cornerRadius: 20)
        scrollView.addSubview(loginRegisterButton)
        loginRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        
        loginRegisterButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        loginRegisterButton.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        loginRegisterButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: viewPadding).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
   
}

