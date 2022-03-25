//
//  PhotosTests.swift
//  PhotosTests
//
//  Created by 백상휘 on 2022/03/21.
//

import XCTest
@testable import PhotoApp

class PhotosTests: XCTestCase {
    
    func testExample() throws {
        XCTAssertEqual(1+1, 2)
    }
    
    func testFetchThumbnails() throws {
        let promise = expectation(description: "Image Fetch Success")
        
        let manager = PhotoThumbnailManager {
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 1)
        
        XCTAssertTrue(manager.thumbnailsCount > 0)
    }
}
