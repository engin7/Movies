//
//  MovieDetailVC.swift
//  Movies
//
//  Created by Engin KUK on 27.10.2020.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieDescription: UITextView!
    @IBOutlet weak var movieVoteCount: UILabel!
    
    var movie : Movie?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = movie?.title
        movieName.text = movie?.title
        movieDescription.text = movie?.overview
     
        if let vote = movie?.voteCount {
            movieVoteCount.text = "vote count: " + String(vote).dropLast(2)
        } else {
            movieVoteCount.text = "vote count unknown "
        }
        if let poster = movie?.posterImagePath {
            let imageURL = URL(string: "http://image.tmdb.org/t/p/w342" + poster)!
            posterImage.loadImageUsingCache(url: imageURL)
        }
        
    }
    
}
