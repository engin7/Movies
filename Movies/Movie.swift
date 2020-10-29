//
//  Movie.swift
//  movieDB
//
//  Created by Engin KUK on 26.10.2020.
//  Copyright © 2020 Engin KUK. All rights reserved.
//

import Foundation

// Network Response
struct Root:  Codable {
    var results = [Movie]()
    var page = Int()
}


struct Movie: Codable {
    
    var title                = ""
    var overview             = ""
    var posterImagePath      = ""
    var voteCount            = 0.0
    var id                   = 0
    var backdropImagePath: String?
 
    enum CodingKeys: String, CodingKey {
        case posterImagePath = "poster_path"
        case backdropImagePath = "backdrop_path"
        case voteCount = "vote_count"
        case overview, id, title
     }
    
}
