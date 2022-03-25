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
    
    func testDateDoodle() throws {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMdd"
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let result = dateFormatter.string(from: date)
        XCTAssertEqual(result, "20220325")
    }
    
    func testDoodleCount() throws {
        
        let promise = expectation(description: "Doodle Manager Expectation")
        
        let doodleManager = DoodleManager(forResource: "doodle", withExtension: "json") {
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 1)
        XCTAssertGreaterThan(doodleManager.doodlesCount, 0)
    }
    
    func testDoodleSubscript() throws {
        
        let promise = expectation(description: "Doodle Manager Expectation")
        let testRawData = [
            ["1","https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSmETnjE9_LGsbWjeNCwlRJ4Ox1ioqxEVtWd7Z4QCKHtI7PewxvEg","20140116"],
            ["2","https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4XFa0i2H58farLmNpuChYmuADmvu3_dgE6aetcAmxhPAacH-32w","20220505"]
        ]
        
        let jsonString = "[" + testRawData.map { rawData in
            "{\"title\":\"\(rawData[0])\",\"image\":\"\(rawData[1])\",\"date\":\"\(rawData[2])\"}"
        }.joined(separator: ",") + "]"
        
        guard let data = jsonString.data(using: .utf8) else {
            XCTFail()
            return
        }
        
        let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYYMMdd"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            return dateFormatter
        }()
        
        let testDoodle1 = Doodle(
            title: testRawData[0][0],
            imageURL: URL(string: testRawData[0][1])!,
            date: dateFormatter.date(from: testRawData[0][2])!
        )
        let testDoodle2 = Doodle(
            title: testRawData[1][0],
            imageURL: URL(string: testRawData[1][1])!,
            date: dateFormatter.date(from: testRawData[1][2])!
        )
        
        let doodleManager = DoodleManager(from: data) {
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 1)
        XCTAssertEqual(testDoodle1, doodleManager[0])
        XCTAssertEqual(testDoodle2, doodleManager[1])
    }
}
