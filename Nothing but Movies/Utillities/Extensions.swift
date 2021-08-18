//
//  Extensions.swift
//  Nothing but Movies
//
//  Created by Kirti Verma on 08/08/21.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    // downloads and caches image in NSCache
    func loadImage(withUrl moviePosterPath: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(moviePosterPath)") else {
            return
        }
        
        self.image = nil

        // check cached image
        if let cachedImage = imageCache.object(forKey: moviePosterPath as NSString)  {
            self.image = cachedImage
            return
        }

        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.medium)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center

        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                if let err = error {
                    print(err)
                    return
                }
                
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: moviePosterPath as NSString)
                    self.image = image
                    activityIndicator.removeFromSuperview()
                }
            }
        }).resume()
    }
}
