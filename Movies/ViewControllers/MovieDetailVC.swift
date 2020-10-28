//
//  MovieDetailVC.swift
//  Movies
//
//  Created by Engin KUK on 27.10.2020.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet private weak var posterImage: UIImageView!
    @IBOutlet private weak var movieName: UILabel!
    @IBOutlet private weak var movieDescription: UITextView!
    @IBOutlet private weak var movieVoteCount: UILabel!
    @IBOutlet private weak var starButton: UIBarButtonItem!
    
    @IBAction private func starTapped(_ sender: Any) {
        defaults.set(!starred, forKey: key)
        starred = !starred
        checkStar()
     }
    
    private let defaults = UserDefaults.standard
    private var key = ""
    private var starred = false
    var movie : Movie?

    override func viewDidLoad() {
        super.viewDidLoad()
        setStar()
        setUI()
    }
    
    private func setStar() {
        
        if let id = movie?.id {
            key = String(id)
        }
        if key == "" {
            starButton.isEnabled = false
        } else {
            starred = defaults.bool(forKey: key)
            checkStar()
        }
    }
    
    private func checkStar() {
        if starred {
            starButton.image = UIImage(systemName: "star.fill")!
        } else {
            starButton.image = UIImage(systemName: "star")
        }
    }
    
    private func setUI() {
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
