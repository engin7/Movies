//
//  UIImageViewExtension.swift
//  Movies
//
//  Created by Engin KUK on 26.10.2020.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func loadImageUsingCache(url : URL) {
        
        let urlString: String = url.absoluteString
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }
        
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .medium)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                DispatchQueue.main.async {
                    self.image =  #imageLiteral(resourceName: "noImage")
                    self.contentMode = .scaleAspectFit
                    activityIndicator.removeFromSuperview()
                }
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    activityIndicator.removeFromSuperview()
                    self.image = image
                    self.setNeedsDisplay()
                }
            }
            
        }).resume()
    }
}

