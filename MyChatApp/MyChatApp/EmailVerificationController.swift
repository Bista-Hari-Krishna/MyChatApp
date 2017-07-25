//
//  EmailVerificationController.swift
//  MyChatApp
//
//  Created by iOS on 25/07/17.
//  Copyright © 2017 NTTData. All rights reserved.
//

import UIKit

class EmailVerificationController: UIViewController {
    
    var backgroundImageView: UIImageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundImageView()
        perform(#selector(dismissVc), with: nil, afterDelay: 2.0)
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
}
