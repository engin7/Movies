//
//  MovieListCVC.swift
//  Movies
//
//  Created by Engin KUK on 26.10.2020.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var star: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.image = nil
        movieLabel.text = nil

    }
    
    
}
