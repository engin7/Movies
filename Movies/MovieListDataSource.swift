//
//  MovieListDataSource.swift
//  Movies
//
//  Created by Engin KUK on 26.10.2020.
//

import UIKit

class MovieListDataSource: NSObject, UICollectionViewDataSource {
    
    private let network = NetworkManager.shared

    var movieList: [Movie]
    var isFiltering: Bool
    var listView: Bool
    
    // Dependency injection (DI)
    init(movies: [Movie], listView: Bool, filtering: Bool?) {
        self.movieList = movies
        self.listView = listView
        self.isFiltering = filtering ?? false
    }
     
     func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath) as! FooterCollectionReusableView
            
            footerView.spinner.startAnimating()
            if network.movieListPage == 500 || isFiltering {   // last page or filter
                footerView.spinner.stopAnimating()
            }
            
            return footerView
        }
        fatalError()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if  isFiltering && movieList.count == 0 {
               return 1 // no result
         }
        return movieList.count
     }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MovieListCollectionViewCell
        
        let movie:Movie
        if  isFiltering && movieList.count == 0 {
            movie = Movie(title: "No movies match your query")
            cell.movieLabel.text = movie.title
            cell.movieImageView.image = #imageLiteral(resourceName: "noResult")
            return cell
       } else {
        movie = movieList[indexPath.row]
        }
        var imageURL:URL    // pick image according to cell size ratio for better scaling
        if  listView {
            imageURL = URL(string: "http://image.tmdb.org/t/p/w300" + (movie.backdropImagePath ?? "" ))!
        } else {
            imageURL = URL(string: "http://image.tmdb.org/t/p/w342" + movie.posterImagePath)!
        }
        
        let defaults = UserDefaults.standard
        let starred = defaults.bool(forKey: String(movie.id))
        
         
        cell.star.isHidden = !starred
        cell.movieLabel.text = movie.title
        cell.movieImageView.loadImageUsingCache(url: imageURL)
        
        if indexPath.row == movieList.count - 1 && !isFiltering { // reached last item in list
            loadMorePages(view: collectionView)
        }
        return cell
    }
    
    func loadMorePages(view: UICollectionView){
        network.pageIndex += 1
        self.network.getMovies(get: .list, movie: nil, completion: {success in
            if success {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                    movieList = network.movieList
                    view.reloadData()
                }
            }
        })
    }
    
    
}
  
 
