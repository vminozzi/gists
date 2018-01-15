//
//  GistModelTest.swift
//  GistTests
//
//  Created by Vinicius Minozzi on 15/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import XCTest
@testable import Gist

class GistModelTest: XCTestCase {
    
    var mockedGists: Result?
    
    override func setUp() {
        super.setUp()
        guard let jsonData = readJSON(name: "MockedGists") else {
            return
        }
        mockedGists = Result(data: jsonData)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testShouldValidateDeserealize() {
        XCTAssertEqual(mockedGists?.gists.count, 30)
        
        XCTAssertNotNil(mockedGists?.gists.first?.id)
        XCTAssertNotNil(mockedGists?.gists.first?.owner)
        XCTAssertNotNil(mockedGists?.gists.first?.files)
        
        XCTAssertEqual(mockedGists?.gists.first?.id ?? "", "7928dfbfdbf6bd2c5deb01e008730e19")
    }
    
    func testShouldValidateOwner() {
        XCTAssertNotNil(mockedGists?.gists.first?.owner)
        
        XCTAssertEqual(mockedGists?.gists.first?.owner?.id ?? 0, 9558)
        XCTAssertEqual(mockedGists?.gists.first?.owner?.photo ?? "", "https://avatars3.githubusercontent.com/u/9558?v=4")
        XCTAssertEqual(mockedGists?.gists.first?.owner?.login ?? "", "ko1")
    }
    
    func testShouldValidateFile() {
        XCTAssertNotNil(mockedGists?.gists.first?.files)
        
        XCTAssertEqual(mockedGists?.gists.first?.files?.fileList?.filename ?? "", "brlog.trunk_clang_39.20180115-131448")
        XCTAssertEqual(mockedGists?.gists.first?.files?.fileList?.type ?? "", "text/plain")
    }
}


extension XCTestCase {
    
    func readJSON(name: String) -> Data? {
        let path = Bundle.main.path(forResource: name, ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        return data
    }
}
