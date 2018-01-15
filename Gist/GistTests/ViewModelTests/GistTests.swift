//
//  GistTests.swift
//  GistTests
//
//  Created by Vinicius on 13/01/18.
//  Copyright © 2017 Vinicius Minozzi. All rights reserved.
//

import XCTest
@testable import Gist

class GistTests: XCTestCase {
    
    var viewController = GistsViewController()
    var viewModel: GistsViewModel?
    
    override func setUp() {
        super.setUp()
        viewModel = GistsViewModel(view: viewController)
        
        guard let jsonData = readJSON(name: "MockedGists"), let mock = Result(data: jsonData)  else {
            return
        }
        viewModel?.gists = mock.gists
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testShouldValidateGistDTO() {
        let gistDTO = viewModel?.gistDTO(at: 0)
        XCTAssertNotNil(gistDTO)
    }
    
    func testShouldValidateGistDetailDTO() {
        let detailDTO = viewModel?.getDetailDTO(identifier: "", row: 0)
        XCTAssertNotNil(detailDTO)
    }
    
    func testShouldValidateGistAddFavorite() {
        viewModel?.didFavorite(with: "7928dfbfdbf6bd2c5deb01e008730e19", shouldFavorite: true)
        XCTAssertTrue(viewModel?.favorites.count ?? 0 > 0)
    }
    
    func testShouldValidateLoadFavorites() {
        viewModel?.getFavorites()
        XCTAssertTrue(viewModel?.favorites.count ?? 0 > 0)
    }
    
    func testShouldValidateCheckFavorite() {
        XCTAssertTrue(viewModel?.isFavorite(id: "7928dfbfdbf6bd2c5deb01e008730e19") == true)
    }
}
