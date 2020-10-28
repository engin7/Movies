//
//  MovieListDataSource.swift
//  Movies
//
//  Created by Engin KUK on 26.10.2020.
//

import UIKit

class MovieListDataSource: NSObject, UICollectionViewDataSource {
    
    private let network = NetworkManager.shared
    
     func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath) as! FooterCollectionReusableView
            
            footerView.spinner.startAnimating()
            if network.movieListPage == 500 || network.isFiltering {   // last page or filter
                footerView.spinner.stopAnimating()
            }
            
            return footerView
        }
        fatalError()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if network.isFiltering {
            if network.filteredMovies.count == 0 {
                return 1 // no result
            }
        return network.filteredMovies.count
        } else {
        return network.movieList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MovieListCollectionViewCell
        
        let movie:Movie
        if network.isFiltering {
            if network.filteredMovies.count == 0 {
                movie = Movie(title: "No movies match your query")
                cell.movieLabel.text = movie.title
                cell.movieImageView.image = #imageLiteral(resourceName: "noResult")
                return cell
            } else {
                movie = network.filteredMovies[indexPath.row]
            }
        } else {
        movie = network.movieList[indexPath.row]
        }
        let imageURL = URL(string: "http://image.tmdb.org/t/p/w300" + (movie.backdropImagePath ))!
        let defaults = UserDefaults.standard
        let starred = defaults.bool(forKey: String(movie.id))
        
        if starred {
            cell.star.isHidden = false
        } else {
            cell.star.isHidden = true
        }
        cell.movieLabel.text = movie.title
        cell.movieImageView.loadImageUsingCache(url: imageURL)
        
        if indexPath.row == network.movieList.count - 1 { // reached last item in list
            network.pageIndex += 1
            self.network.getMovies(get: .list, movie: nil, completion: {success in
                if success {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        collectionView.reloadData()
                    }
                }
            })
        }
        
        return cell
    }
    
 
}
  
 
