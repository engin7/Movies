//
//  Movies.swift
//  MoviesTests
//
//  Created by Engin KUK on 29.10.2020.
//

import XCTest
@testable import Movies

class MovieListVC: XCTestCase {
 
    private var sut: MovieListViewController!
    private var ds: MovieListDataSource!
    
    override func setUp() {
        super.setUp()
        sut = MovieListViewController()
        ds = MovieListDataSource.shared
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testDataSourceFetchedData() throws {
        
        XCTAssertEqual(ds.movieList.count, NetworkManager.shared.movieList.count)
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
