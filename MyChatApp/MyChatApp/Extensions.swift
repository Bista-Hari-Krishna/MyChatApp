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
    func loadImageUsingCacheWithUrlString(urlString: String) {
        self.image = nil
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
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red:r/255 ,green:g/255, blue:b/255, alpha:1)
    }
}
extension UITextField {
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
