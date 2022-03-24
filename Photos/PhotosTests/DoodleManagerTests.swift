//
//  DoodleManagerTests.swift
//  PhotoAppTests
//
//  Created by Bumgeun Song on 2022/03/24.
//

import XCTest

class DoodleManagerTests: XCTestCase {

    func testExample() throws {
    }
    
    func testFetchDoodle() throws {
        let doodleManager = DoodleManager()
        guard let doodle = doodleManager.fecthDoodle() else {
            XCTFail()
            return
        }
        XCTAssertEqual(doodle.title, "1")
        print(doodle.image)
        print(doodle.date)
    }
}
