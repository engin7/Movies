//
//  MovieListViewController.swift
//  Movies
//
//  Created by Engin KUK on 26.10.2020.
//

import UIKit

class MovieListViewController: UIViewController, UICollectionViewDelegate {
    
    private let network = NetworkManager.shared
    
    @IBOutlet weak var movieListCV: UICollectionView!
    private let collectionViewDataSource = MovieListDataSource() //ViewModel
    var searchController: UISearchController!
    var filteredMovies: [Movie] = []
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
        title = "Movie List"
        setupSearchController()
        movieListCV.dataSource = collectionViewDataSource
        
        network.getMovies(get: .list, movie: nil, completion: {success in
            if success {
                self.movieListCV.reloadData()
              }
        })
    }
    
    
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    
    // MARK: Navigation
      
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if (segue.identifier == SegueTo.showDetails.rawValue) {
              let vc = segue.destination as! MovieDetailViewController
              vc.movie = sender as? Movie
          }
      }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           
        let selectedMovie = network.movieList[indexPath.row]
        self.performSegue(withIdentifier: SegueTo.showDetails.rawValue, sender: selectedMovie)
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
   
    // MARK: Helper Methods
    
    func showNetworkError() {
        let alert = UIAlertController(title: "Sorry...", message: "Error occured connecting the Movie DataBase. Please try again.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - Extensions

extension MovieListViewController {

    enum SegueTo: String {
        case showDetails = "MovieDetailViewController"
    }
}

extension MovieListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text!.count < 3 {
            searchController.showsSearchResultsController = false
        } else {
            searchController.showsSearchResultsController = true
            guard let text = searchController.searchBar.text else { return }
                print(text)
        }
    }
}
