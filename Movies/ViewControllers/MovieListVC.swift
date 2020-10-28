//
//  MovieListViewController.swift
//  Movies
//
//  Created by Engin KUK on 26.10.2020.
//

import UIKit

class MovieListViewController: UIViewController, UICollectionViewDelegate, UISearchBarDelegate {
    
    private let network = NetworkManager.shared
    
    @IBOutlet weak var movieListCV: UICollectionView!
    private let collectionViewDataSource = MovieListDataSource() //ViewModel
    var searchController: UISearchController!
    
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
        title = "Movie List"
        setupSearchController()
        movieListCV.dataSource = collectionViewDataSource
        network.getMovies(get: .list, movie: nil, completion: { [self]success in
            if success {
                movieListCV.reloadData()
            } else {
                showNetworkError()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let index = movieListCV.indexPathsForSelectedItems
        if index?.isEmpty != true {
            movieListCV.reloadItems(at: index!) //update starred condition
        }
    }
    
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search Movies"
        definesPresentationContext = true
        searchController.searchBar.delegate = self

    }
    
    
    // MARK: Navigation
      
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if (segue.identifier == SegueTo.showDetails.rawValue) {
              let vc = segue.destination as! MovieDetailViewController
              vc.movie = sender as? Movie
          }
      }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           
        let selectedMovie: Movie
        if network.isFiltering {
        selectedMovie = network.filteredMovies[indexPath.row]
        } else {
        selectedMovie = network.movieList[indexPath.row]
        }
        self.performSegue(withIdentifier: SegueTo.showDetails.rawValue, sender: selectedMovie)
        
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
    
    func filterContentForSearchText(_ searchText: String) {
        network.filteredMovies = network.movieList.filter { (movie: Movie) -> Bool in
        return movie.title.lowercased().contains(searchText.lowercased())
      }
        movieListCV.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if  searchBar.text!.count < 2 {
            network.isFiltering = false
            network.filteredMovies = []
            movieListCV.reloadData()
        } else {
            network.isFiltering = searchController.isActive
            guard let text = searchBar.text else { return }
            filterContentForSearchText(text)
        }
    }
   
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = CGFloat(150)
        var width:CGFloat
        // two rows for ipad
        if collectionView.frame.size.width < 768 {
            width  = collectionView.frame.width-10
        } else {
            width  = collectionView.frame.width/2-10
        }
        return CGSize(width: width, height: height)
    }
}
