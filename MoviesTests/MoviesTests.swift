//
//  MoviesTests.swift
//  MoviesTests
//
//  Created by Engin KUK on 26.10.2020.
//

import XCTest
@testable import Movies

class MoviesTests: XCTestCase {

    private var sut : NetworkManager! //System Under Test

    
    override func setUpWithError() throws {
        sut = NetworkManager.shared
        
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testNetworkListExample() throws {
        
        sut.getMovies(get: .list, movie: nil, completion: { success in
            if success { XCTAssertNotNil(self.sut?.movieList) }
        })
    }

    func testNetworkByIdExample() throws {
        // not giving the movie paramater should fail and return nil
        sut.getMovies(get: .byId, movie: nil, completion: { success in
            if success { } else { XCTAssertNil(self.sut?.movieById) }
        })
    }
    
    func testNetworkLoadingListsExample() throws {
        
        let promise = expectation(description: "Status code: 200")
 
        func getMovies() {
            while self.sut.pageIndex < 4 {
                sut.getMovies(get: .list, movie: nil, completion: { success in
                if success {
                    self.sut.pageIndex += 2
                    getMovies() // recursive
                }})
            }
            promise.fulfill() // fulfill expectation after all functions called
        }
        
        getMovies()
        wait(for: [promise], timeout: 10)
        // 20 pages per request returning from API. 20*5 = 100 movie items should be added.
        XCTAssertNotEqual(self.sut.movieList.count, 60)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
