//
//  MovieListViewController.swift
//  Movies
//
//  Created by Engin KUK on 26.10.2020.
//

import UIKit

class MovieListViewController: UIViewController, UICollectionViewDelegate, UISearchBarDelegate {
    
    @IBOutlet private weak var movieListCV: UICollectionView!
    @IBOutlet private weak var viewToggle: UIBarButtonItem!
    @IBAction private func viewTogglePressed(_ sender: Any) {
        listView = !listView
        if listView {
            viewToggle.image = UIImage(systemName: "rectangle.grid.2x2.fill")
        } else {
            viewToggle.image = UIImage(systemName: "text.justify")
        }
        dataSource.listView  = listView
        movieListCV.reloadData()
    }
    
    private let network = NetworkManager.shared
    private var dataSource = MovieListDataSource.shared
    private var searchController: UISearchController!
    private var filteredMovies = [Movie]()
    private var listView = true
    
    override func viewDidLoad() {

        super.viewDidLoad()
        title = "Movie List"
        setupSearchController()
        movieListCV.dataSource = dataSource
        network.getMovies(get: .list, movie: nil, completion: { [self]success in
            if success {
                dataSource.movieList = network.movieList
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
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search Movies"
        definesPresentationContext = true
        searchController.searchBar.delegate = self

    }
    
    
    // MARK: Navigation
      
      override  func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if (segue.identifier == SegueTo.showDetails.rawValue) {
              let vc = segue.destination as! MovieDetailViewController
              vc.movie = sender as? Movie
          }
      }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           
        if dataSource.isFiltering && filteredMovies.count == 0 {
            return
        }
        let selectedMovie: Movie
        if dataSource.isFiltering {
        selectedMovie = filteredMovies[indexPath.row]
        } else {
        selectedMovie = network.movieList[indexPath.row]
        }
        self.performSegue(withIdentifier: SegueTo.showDetails.rawValue, sender: selectedMovie)
        
    }
   
    // MARK: Helper Methods
    
    private func showNetworkError() {
        let alert = UIAlertController(title: "Sorry...", message: "Error occured connecting the Movie DataBase. Please try again.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - Extensions

extension MovieListViewController {

    private enum SegueTo: String {
        case showDetails = "MovieDetailViewController"
    }
}

extension MovieListViewController: UISearchResultsUpdating {
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredMovies = network.movieList.filter { (movie: Movie) -> Bool in
        return movie.title.lowercased().contains(searchText.lowercased())
      }
        dataSource.movieList = filteredMovies
        dataSource.isFiltering = true
        movieListCV.reloadData()
     }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if  searchBar.text!.count < 2 {
            filteredMovies = []
            dataSource.movieList = network.movieList
            dataSource.isFiltering = false
            movieListCV.reloadData()
            
        } else {
            guard let text = searchBar.text else { return }
            filterContentForSearchText(text)
        }
    }
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height:CGFloat
        var width:CGFloat
        // three rows for ipad
        if collectionView.frame.size.width >= 768 {
            viewToggle.isEnabled = false
            viewToggle.image = nil
            viewToggle.title = ""
            listView = false
            height = CGFloat(350)
            width  = collectionView.frame.width/3-15
        } else if listView || (dataSource.isFiltering && filteredMovies.count == 0) {
            height = CGFloat(150)
            width  = collectionView.frame.width-10
        } else {
            height = CGFloat(250)
            width  = collectionView.frame.width/2-10
        }
     
        return CGSize(width: width, height: height)
    }
 
}

 
