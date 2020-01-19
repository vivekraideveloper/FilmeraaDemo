//
//  SearchCell.swift
//  Filemraa Demo
//
//  Created by Vivek Rai on 14/01/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    
    let movieImageView: UIImageView = {
        let iv  = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let playImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "play")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func setUpView(){
        addSubview(movieImageView)
        movieImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 120, height: 80)
        
        addSubview(playImageView)
        playImageView.anchor(top: self.topAnchor, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 10, paddingRight: 10, width: 30, height: 30)
        
        addSubview(titleLabel)
        titleLabel.anchor(top: self.topAnchor, left: movieImageView.rightAnchor, bottom: self.bottomAnchor, right: playImageView.leftAnchor, paddingTop: 5, paddingLeft: 15, paddingBottom: 5, paddingRight: 5, width: 0, height: 80)
    }

}
