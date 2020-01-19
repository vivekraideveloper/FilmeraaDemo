//
//  SeriesCollectionViewCell.swift
//  Filemraa Demo
//
//  Created by Vivek Rai on 09/01/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class SeriesCollectionViewCell: UICollectionViewCell {
    
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
    
    
    func setUpView(){
        addSubview(imageView)
        imageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 10, paddingRight: 5, width: 0, height: 0)
    }
}
