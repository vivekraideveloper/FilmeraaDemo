//
//  FeatureCollectionViewCell.swift
//  Filemraa Demo
//
//  Created by Vivek Rai on 09/01/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

var imageCache: NSCache<AnyObject, AnyObject> = NSCache()
class FeaturetteCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    let spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        return view
    }()
    
    func setUpView(){
        addSubview(imageView)
        imageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 10, paddingRight: 5, width: 0, height: 0)
    }
    
    func downloadImage(withUrlString urlString: String) {
        if #available(iOS 13.0, *) {
            spinner.style = UIActivityIndicatorView.Style.medium
        } else {
            // Fallback on earlier versions
        }
           spinner.hidesWhenStopped = true
           spinner.startAnimating()
           
           let url = URL(string: urlString)!
           
           if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
               self.imageView.image = imageFromCache
               self.spinner.stopAnimating()
               return
           }
           
           URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
               
               if error != nil {
                   debugPrint(String(describing: error?.localizedDescription))
                   return
               }
               
               DispatchQueue.main.async {
                   let imageToCache = UIImage(data: data!)
                   self.imageView.image = imageToCache
                   self.spinner.stopAnimating()
                   imageCache.setObject(imageToCache!, forKey: url.absoluteString as AnyObject)
               }
           }).resume()
       }

}

