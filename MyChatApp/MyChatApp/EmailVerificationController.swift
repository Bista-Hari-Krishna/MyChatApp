//
//  EmailVerificationController.swift
//  MyChatApp
//
//  Created by iOS on 25/07/17.
//  Copyright © 2017 NTTData. All rights reserved.
//

import UIKit
import Firebase

class EmailVerificationController: UIViewController, UITextFieldDelegate {
    
    var backgroundImageView: UIImageView = UIImageView()
    var timer: Timer?
    var thankYouLabel: UILabel = UILabel()
    var thankYouSeparatorLine: UIView = UIView()
    var descriptionLabel: UILabel = UILabel()
    var emailTextField:UITextField = UITextField()
    
    var email = ""
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    var activitylabel: UILabel = UILabel()
    var activityLabelHeight: NSLayoutConstraint?
    var resendEmailVerificationButtonTopSpace: NSLayoutConstraint?
    
    var emailChangeButton: UIButton!
    var resendEmailVerificationButton: UIButton!
    var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendEmailVerification(sender: self)
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.performVerificationCheck), userInfo: nil, repeats: true)
        setupUI()
        

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func setupUI() {
        setupBackgroundImageView()
        setupThankYouHeader()
        setupDescriptionLabel()
        setupEmailTextField()
        setupEmailChangeButton()
        setupActivity()
        setupResendEmailVerificationButton()
        setupLogoutButton()
    }
    func setupThankYouHeader() {
        thankYouLabel.translatesAutoresizingMaskIntoConstraints = false
        thankYouLabel.numberOfLines = 0
        thankYouLabel.text = "Thank you for registering"
        thankYouLabel.textAlignment = .center
        thankYouLabel.textColor = .white
        thankYouLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        view.addSubview(thankYouLabel)
        thankYouLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        thankYouLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        thankYouSeparatorLine.backgroundColor = .white
        thankYouSeparatorLine.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(thankYouSeparatorLine)
        thankYouSeparatorLine.topAnchor.constraint(equalTo: thankYouLabel.bottomAnchor, constant: 10).isActive = true
        thankYouSeparatorLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        thankYouSeparatorLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        thankYouSeparatorLine.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
    }
    func setupDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .white
        descriptionLabel.text = "Complete your verification on by clicking the verification link in the email we've sent to"
        
        view.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: thankYouSeparatorLine.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
    }
    func setupEmailTextField() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.borderStyle = .none
        emailTextField.placeholder = "Email"
        emailTextField.textAlignment = .center
        emailTextField.text = email
        emailTextField.clearButtonMode = .whileEditing
        emailTextField.font = UIFont.boldSystemFont(ofSize: 17)
        emailTextField.isUserInteractionEnabled = false
        emailTextField.returnKeyType = .send
        emailTextField.delegate = self
        
        view.addSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    func setupEmailChangeButton() {
        emailChangeButton = UIButton(title: "CHANGE EMAIL", cornerRadius: 6.0)
        emailChangeButton.translatesAutoresizingMaskIntoConstraints = false
        emailChangeButton.addTarget(self, action: #selector(handleEmailChange), for: .touchUpInside)
        
        view.addSubview(emailChangeButton)
        emailChangeButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10).isActive = true
        emailChangeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailChangeButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        emailChangeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    func setupActivity() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        activityIndicator.topAnchor.constraint(equalTo: emailChangeButton.bottomAnchor, constant: 20).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 40).isActive = true

        
        activitylabel.translatesAutoresizingMaskIntoConstraints = false
        activitylabel.text = "Waiting, for verification..."
        activitylabel.textColor = .white
        activitylabel.font = UIFont.systemFont(ofSize: 15)
        activitylabel.clipsToBounds = true
        
        view.addSubview(activitylabel)
        activitylabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 5).isActive = true
        activitylabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityLabelHeight = activitylabel.heightAnchor.constraint(equalToConstant: 18)
        activityLabelHeight?.isActive = true
    }
    func setupResendEmailVerificationButton() {
        resendEmailVerificationButton = UIButton(title: "RESEND EMAIL VERIFICATION", cornerRadius: 10.0)
        resendEmailVerificationButton.translatesAutoresizingMaskIntoConstraints = false
        resendEmailVerificationButton.addTarget(self, action: #selector(sendEmailVerification(sender:)), for: .touchUpInside)
        
        view.addSubview(resendEmailVerificationButton)
        resendEmailVerificationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resendEmailVerificationButtonTopSpace = resendEmailVerificationButton.topAnchor.constraint(equalTo: emailChangeButton.bottomAnchor, constant: 93)
        resendEmailVerificationButtonTopSpace?.isActive = true
        resendEmailVerificationButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        resendEmailVerificationButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    func setupLogoutButton() {
        logoutButton = UIButton(title: "LOGOUT", cornerRadius: 5)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
        view.addSubview(logoutButton)
        logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoutButton.topAnchor.constraint(equalTo: resendEmailVerificationButton.bottomAnchor, constant: 20).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    func handleLogout() {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        }catch let logoutError {
            print(logoutError)
        }
    }
    func disableControls() {
        activityLabelHeight?.constant = 0
        resendEmailVerificationButtonTopSpace?.constant = 20
        activityIndicator.stopAnimating()
        emailTextField.isUserInteractionEnabled = true
        resendEmailVerificationButton.isEnabled = false
        emailTextField.becomeFirstResponder()
    }
    func enableControls() {
        resendEmailVerificationButtonTopSpace?.constant = 93
        activityLabelHeight?.constant = 18
        activityIndicator.startAnimating()
        resendEmailVerificationButton.isEnabled = true
        emailTextField.isUserInteractionEnabled = false
        
    }
    func handleEmailChange() {
        disableControls()
    }
    func sendEmailVerification(sender: AnyObject) {
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            if let error = error {
                print(error)
                return
            }
            if sender is UITextField {
                self.showAlert(title: "Sent!", message: "Email has been sent to \(self.emailTextField.text!)", dismissAutomatic: true)
            }
        })
    }
    func showAlert(title: String, message: String, dismissAutomatic: Bool) {
        let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alertCtrl, animated: true) { 
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                alertCtrl.dismiss(animated: true, completion: nil)
            })
        }
        
    }
    func performVerificationCheck() {
        if isEmailVerified() {
            print("true")
            timer?.invalidate()
            dismissVc()
        }else {
            print("false")
        }
    }
    func isEmailVerified() -> Bool {
        Auth.auth().currentUser?.reload(completion: { (error) in
            
        })
        if (Auth.auth().currentUser?.isEmailVerified)! {
            return true
        }
        return false
    }
    func setupBackgroundImageView() {
        view.addSubview(backgroundImageView)
        backgroundImageView.image = UIImage(named: "3")
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroundImageView]|", options: .init(rawValue: 0), metrics: nil, views: ["backgroundImageView":backgroundImageView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundImageView]|", options: .init(rawValue: 0), metrics: nil, views: ["backgroundImageView":backgroundImageView]))
    }
    func dismissVc() {
        dismiss(animated: false, completion: nil)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- UItextfield delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        enableControls()
        Auth.auth().currentUser?.updateEmail(to: textField.text!) { (error) in
            if let error = error {
                print(error)
                return
            }
            self.sendEmailVerification(sender: textField)
        }
        
        return true
    }
}
extension UIButton {
    convenience init(title: String, cornerRadius: CGFloat) {
        self.init(type: .system)
        backgroundColor = .clear
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
    }
}
