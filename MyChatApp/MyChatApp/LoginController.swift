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


/**
    LoginController UI Hierarchy:
        -- Default View
                    |__ BackgroundImageView
                    |__ ScrollView
                                |__ProfileImageView
                                |__loginRegisterSegmentedControl
                                |__InputsContainerView
                                |                |__NametextField
                                |                |__EmailtextField
                                |                |__Passwordtextfield
                                |__LoginRegisterButton
 */

class LoginController: UIViewController {
   
    //MARK: - Properties
    var inputsContainerView = UIView()                                                      //container view for the name, email and password textfields
    var loginRegisterButton = UIButton(type: .system)                                       //handles login and register based on the login register segmented control selected index
    var nameTextField = UITextField()
    var emailTextField = UITextField()
    var passwordTextField = UITextField()
    var activeTextField: UITextField?                                                       // keeps reference of the currently editing textfield
    
    var nameTextFieldBorderLine = UIView()                                                  // line below name textfield
    var emailTextFieldBorderLine = UIView()                                                 //line below email textfield
    var loginRegisterSegmentedControl = UISegmentedControl(items: ["Login","Register"])
    var profileImageView = UIImageView()
    var tapGesture: UITapGestureRecognizer?                                                 // tap gesture to pick image for profile image view from photo library or camera
    var imagePickerController = UIImagePickerController()
    var scrollView = UIScrollView()                                                         //for handling keyboard covering the textfield
    
    var nameTextFieldHeight: NSLayoutConstraint?                                            //assigned zero to hide when login is selected in segmentedControl
    var nameTextFieldBorderLineHeight: NSLayoutConstraint?                                  //assigned zero to hide when login is selected in segmentedControl
    var inputsContainerViewHeight: NSLayoutConstraint?                                      //when login is selected in segmemtedControl height of nametextfield and nameTextFieldBorderLineHeight is subtracted to update the UI
  
    //MARK: - Inbuilt Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addObservers()
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
    //MARK: - Configure UI components
    private func configureUI() {     
        view.putBackgroundImage()
        configureScrollView()
        configureInputsContainerView()
        configureLoginRegisterSegmentedControl()
        configureProfileImageView()
        configureNameTextField()
        configureEmailTextField()
        configurePasswordTextField()
        configureLoginRegisterButton()
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.contentSize = view.bounds.size
        
        //Scroll view is extended horizontally and vertical on the view
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: .init(rawValue: 0), metrics: nil, views: ["scrollView":scrollView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|", options: .init(rawValue: 0), metrics: nil, views: ["scrollView":scrollView]))
    
    }
    
    private func configureProfileImageView() {
        scrollView.addSubview(profileImageView)
        profileImageView.image = UIImage(named: "profile2")
        profileImageView.contentMode = .scaleToFill
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = profileImageHeight/2.0
        profileImageView.layer.masksToBounds = true
        profileImageView.isUserInteractionEnabled = true
        
        //Profile image view is placed above the loginregister segmented control
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -40).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: profileImageHeight).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: profileImageHeight).isActive = true
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        profileImageView.addGestureRecognizer(tapGesture!)
    }
    
    private func configureLoginRegisterSegmentedControl() {
        scrollView.addSubview(loginRegisterSegmentedControl)
        loginRegisterSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        loginRegisterSegmentedControl.tintColor = UIColor.white
        loginRegisterSegmentedControl.selectedSegmentIndex = 1
        
        
        //login register segmented control above the inputs container view
        loginRegisterSegmentedControl.addTarget(self, action: #selector(handleLoginRegisterChange(_:)), for: .valueChanged)
        
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -(viewPadding*2)).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -viewPadding).isActive = true
    }
    private func configureInputsContainerView() {
        scrollView.addSubview(inputsContainerView)
        inputsContainerView.translatesAutoresizingMaskIntoConstraints = false
        inputsContainerView.backgroundColor = .clear
        inputsContainerView.layer.borderWidth = 1.0
        inputsContainerView.layer.borderColor = UIColor.white.cgColor
        inputsContainerView.layer.cornerRadius = 40
        inputsContainerView.layer.masksToBounds = true
        
        //Inputs container view placed 40 points below the view vertical center
        inputsContainerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: 40).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -(viewPadding*2)).isActive = true
        inputsContainerViewHeight = inputsContainerView.heightAnchor.constraint(equalToConstant: containerHeight)
        inputsContainerViewHeight?.isActive = true
    }
    private func configureNameTextField() {
        nameTextField = UITextField(borderStyle: .none, textColor: .white, placeholderText: "Name", returnKeyType: .next)
        nameTextField.delegate = self
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameTextFieldBorderLine)
        nameTextField.clipsToBounds = true
      
        //name textfield placed inside inputs container view
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: viewPadding).isActive = true
        nameTextField.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -(containerPadding*2)).isActive = true
        nameTextFieldHeight = nameTextField.heightAnchor.constraint(equalToConstant: textFieldHeight)
        nameTextFieldHeight?.isActive = true
        
        nameTextFieldBorderLine.backgroundColor = .white
        nameTextFieldBorderLine.translatesAutoresizingMaskIntoConstraints = false
        
        //line below nameTextField
        nameTextFieldBorderLine.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameTextFieldBorderLine.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        nameTextFieldBorderLine.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -(containerPadding*2)).isActive = true
        nameTextFieldBorderLineHeight = nameTextFieldBorderLine.heightAnchor.constraint(equalToConstant: borderLineHeight)
        nameTextFieldBorderLineHeight?.isActive = true
    }
    private func configureEmailTextField() {
        emailTextField = UITextField(borderStyle: .none, textColor: .white, placeholderText: "Email",returnKeyType: .next)
        emailTextField.delegate = self
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailTextFieldBorderLine)
        
        //email text field below nameTextFieldBorderLine
        emailTextField.topAnchor.constraint(equalTo: nameTextFieldBorderLine.bottomAnchor).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -(containerPadding*2)).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        emailTextFieldBorderLine.backgroundColor = .white
        emailTextFieldBorderLine.translatesAutoresizingMaskIntoConstraints = false
        
        //line below emailTextField
        emailTextFieldBorderLine.heightAnchor.constraint(equalToConstant: borderLineHeight).isActive = true
        emailTextFieldBorderLine.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailTextFieldBorderLine.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        emailTextFieldBorderLine.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -(containerPadding*2)).isActive = true
    }
    private func configurePasswordTextField() {
        passwordTextField = UITextField(borderStyle: .none, textColor: .white, placeholderText: "Password", returnKeyType: .done)
        passwordTextField.delegate = self
        inputsContainerView.addSubview(passwordTextField)
        
        passwordTextField.isSecureTextEntry = true
        
        //passwordTextField below emailTextFieldBorderLine
        passwordTextField.topAnchor.constraint(equalTo: emailTextFieldBorderLine.bottomAnchor).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -(containerPadding*2)).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
    }
    private func configureLoginRegisterButton() {
        loginRegisterButton = UIButton(title: "REGISTER", cornerRadius: 20)
        scrollView.addSubview(loginRegisterButton)
        loginRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        
        loginRegisterButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        loginRegisterButton.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        //loginRegisterButton below inputsContainerView
        loginRegisterButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: viewPadding).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
   
}

