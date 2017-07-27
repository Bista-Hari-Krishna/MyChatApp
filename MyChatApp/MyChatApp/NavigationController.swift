//
//  NavigationController.swift
//  MyChatApp
//
//  Created by iOS on 27/07/17.
//  Copyright © 2017 NTTData. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = UIColor(patternImage: UIImage(named: "3")!)
        navigationBar.tintColor = .white
        navigationBar.barStyle = .blackTranslucent
        
    }

}
