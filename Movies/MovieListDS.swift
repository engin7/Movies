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
          
            if network.movieListPage == 500 {       // last page
                footerView.spinner.stopAnimating()
            }
            return footerView
        }
        fatalError()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        network.movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let movie = network.movieList[indexPath.row]
        let imageURL = URL(string: "http://image.tmdb.org/t/p/w300" + (movie.backdropImagePath ))!
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MovieListCollectionViewCell
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
  
 
