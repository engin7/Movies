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
    @IBOutlet weak var starButton: UIBarButtonItem!
    
    @IBAction func starTapped(_ sender: Any) {
        defaults.set(!starred, forKey: key)
        if starred {
            starButton.image = UIImage(systemName: "star")
        } else {
            starButton.image = UIImage(systemName: "star.fill")!.withTintColor(.yellow)
        }
     }
    
    let defaults = UserDefaults.standard
    var movie : Movie?
    var key = ""
    var starred = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setStar()
    }
    
    func setStar() {
        
        if let id = movie?.id {
            key = String(id)
        }
        if key == "" {
            starButton.isEnabled = false
        }
        starred = defaults.bool(forKey: key)
        if starred {
            starButton.image = UIImage(systemName: "star.fill")!.withTintColor(.yellow)
        }
    }
    
    func setUI() {
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
