//
//  MoviesTests.swift
//  MoviesTests
//
//  Created by Engin KUK on 26.10.2020.
//

import XCTest
@testable import Movies

class MoviesNetworkTests: XCTestCase {

    private var sut: NetworkManager! //System Under Test
 
    override func setUp() {
        super.setUp()
        sut = NetworkManager.shared
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testNetworkListExample() throws {
        
        sut.getMovies(get: .list, movie: nil, completion: { success in
            if success { XCTAssertNotNil(self.sut.movieList) }
        })
    }

    func testNetworkByIdExample() throws {
        // not giving the movie paramater should fail and return nil
        sut.getMovies(get: .byId, movie: nil, completion: { success in
            if success { } else { XCTAssertNil(self.sut.movieById) }
        })
    }
    
    func testNetworkLoadingListsExample() throws {
        
        let promise = expectation(description: "Status code: 200")
        let itemsBefore = sut.movieList.count // if list has already items
        
        sut.getMovies(get: .list, movie: nil, completion: { success in
            if success {
                promise.fulfill() // fulfill expectation after all functions called
            }})

         wait(for: [promise], timeout: 3)
        // 20 pages per request returning from API should be added.
        XCTAssertEqual(self.sut.movieList.count - itemsBefore, 20)
    }
    
   
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

