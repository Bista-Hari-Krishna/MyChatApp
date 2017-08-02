//
//  Extensions.swift
//  MyChatApp
//
//  Created by iOS on 27/07/17.
//  Copyright © 2017 NTTData. All rights reserved.
//

import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    /**
     It sets UIImageView image property from the image saved in NSCache, if not found downloads from the url.
     
     This method accepts url as a String.
     To use it, simply call loadImageUsingCacheWithUrlString(urlString: String) on UIImageView instance.
     
     - Parameter urlString: as String
    
     */
    func loadImageUsingCacheWithUrlString(urlString: String) {
        image = nil
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if let error = error {
                    print(error)
                    return
                }
                DispatchQueue.main.async {
                    if let downloadedImage = UIImage(data: data!) {
                        imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                        self.image = downloadedImage
                    }
                }
            }).resume()
        }
       
       
    }
}

extension UIColor {
    /**
     It is a convenience init method which takes values rgb and converts it into UIColor.
     
     To use it simply call  UIColor(r: CGFloat, g: CGFloat, b: CGFloat) without dividing the rgb values by 255.
     
     - Parameter r: Red
     - Parameter g: Green
     - Parameter b: Blue
     */
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red:r/255 ,green:g/255, blue:b/255, alpha:1)
    }

}
extension UITextField {
    /**
     It is a convenience init method which returns UItextField instance with specified borderstyle, textColor, attributed placeholder of textColor and returnKeyType for the keyboard.
     
     To use it simply call UITextField(borderStyle: UITextBorderStyle, textColor: UIColor, placeholderText: String, returnKeyType: UIReturnKeyType)
     
     - Parameter borderStyle: UITextBorderStyle
     - Parameter textColor: UIColor
     - Parameter placeholderText: String
     - Parameter returnKeyType: UIReturnKeyType
     */
    convenience init(borderStyle: UITextBorderStyle, textColor: UIColor, placeholderText: String, returnKeyType: UIReturnKeyType) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        let placeholder = NSAttributedString(string: placeholderText, attributes: [ NSForegroundColorAttributeName: textColor.withAlphaComponent(0.6) ])
        self.attributedPlaceholder = placeholder
        self.borderStyle = borderStyle
        self.textColor = textColor
        self.returnKeyType = returnKeyType
        
    }
    
}
extension UIView {
    /**
     It adds UIImageView on the view and sets the default image.
    */
    func putBackgroundImage() {
        let backgroundImageView = UIImageView()
        addSubview(backgroundImageView)
        backgroundImageView.image = UIImage(named: "3")
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroundImageView]|", options: .init(rawValue: 0), metrics: nil, views: ["backgroundImageView":backgroundImageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundImageView]|", options: .init(rawValue: 0), metrics: nil, views: ["backgroundImageView":backgroundImageView]))
    }
}
