//
//  NetworkManager.swift
//  Movies
//
//  Created by Engin KUK on 26.10.2020.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager() // singleton

    private var apiKey: String?
    private let listURL = "https://api.themoviedb.org/3/movie/popular"
    private let byIdURL = "https://api.themoviedb.org/3/movie"
    private var dataTask: URLSessionDataTask? = nil
    typealias SearchComplete = (Bool) -> Void

  
    var movieList:[Movie] = []
    var movieById:Movie?
    var movieListPage: Int?
    var pageIndex = 1
    
    enum GetType {
       case list
       case byId
     }
    
    func getMovies(get: GetType, movie: Movie?, completion: @escaping SearchComplete) {
        
        let url: URL
        if let path = Bundle.main.path(forResource: "keys", ofType: "plist") {
            let Keys =  NSDictionary(contentsOfFile: path) //be sure to add your api key to keys.plist
            apiKey = Keys?.value(forKey: "API_Key") as? String
        }
        
        switch get {
        case .list:
            url = URL(string: listURL + "?api_key=" + apiKey! + "&language=en-US&page=&page=" + String(pageIndex))!
        case .byId:
            let api = "?api_key=" + apiKey! + "&language=en-US"
            url = URL(string: byIdURL + "/" + String(movie!.id) + api)!
        }
        
        dataTask?.cancel()
        
        let session = URLSession.shared
        
        dataTask = session.dataTask(with: url, completionHandler: {data, response, error in
            // if cancelled ignore error code and return
            if let error = error as NSError?, error.code == -999 {
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
                
                switch get {
                case .byId:
                    self.movieById = self.parseDetail(data: data)
                case .list:
                    self.movieList.append(contentsOf: self.parse(data: data).results)
                    self.movieListPage = self.parse(data: data).page
                }
                DispatchQueue.main.async {
                    completion(true)
                }
            } else {
                DispatchQueue.main.async {
                    print(error?.localizedDescription ?? "Failed to connect API")
                    completion(false)
                }
            }
        })
        dataTask?.resume()
    }
    
    
 // MARK:- Private Methods
 
    private func parse(data: Data) -> Root {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(Root.self, from:data)
            return result
        } catch {
            print("JSON Error: \(error)")
            let empty = Root()
            return  empty  }
    }
    
    private func parseDetail(data: Data) -> Movie? {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(Movie.self, from:data)
            return result
        } catch {
            print("JSON Error: \(error)")
            return nil }
    }
    
}


     
 
