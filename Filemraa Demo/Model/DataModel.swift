//
//  DataModel.swift
//  Filemraa Demo
//
//  Created by Vivek Rai on 09/01/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DataModel {
    
    var title: String!
    var imageUrl: String!
    var movieImageUrl: String!
    var trailerId: String!
    
    init(imageUrl: String, title: String, movieImageUrl: String, trailerId: String) {
        self.title = title
        self.imageUrl = imageUrl
        self.movieImageUrl = movieImageUrl
        self.trailerId = trailerId
    }
    
    init(snapshot: DataSnapshot) {

        
        let snapshotValue = snapshot.value as? NSDictionary
        
        if let url = snapshotValue?["imageUrl"] as? String {
            imageUrl = url
            
        }else{
            imageUrl = ""
        }
        
        if let title_ = snapshotValue?["title"] as? String {
            title = title_
                   
        }else{
            title = ""
        }
        
        if let movieImageUrl_ = snapshotValue?["movieImageUrl"] as? String {
            movieImageUrl = movieImageUrl_
                   
        }else{
            movieImageUrl = ""
        }
        
        if let trailerId_ = snapshotValue?["trailerId"] as? String {
            trailerId = trailerId_
                   
        }else{
            trailerId = ""
        }
        
    }
    
    
}
