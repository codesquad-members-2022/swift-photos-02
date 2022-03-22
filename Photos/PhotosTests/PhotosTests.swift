//
//  PhotosTests.swift
//  PhotosTests
//
//  Created by 백상휘 on 2022/03/21.
//

import XCTest
@testable import Photos

class PhotosTests: XCTestCase {
    
    var manager: PhotoThumbnailManager? = nil
    
    func testExample() throws {
        XCTAssertEqual(1+1, 2)
    }
    
    func testInitializeManager() throws {
        manager = PhotoThumbnailManager.init()
        
        if manager == nil {
            XCTFail("[Test Failed] PhotoThumbnailManager class not initialized. Check Authorization in Settings Menu.")
        }
    }
    
    func testFetchThumbnails() throws {
        guard let manager = manager else {
            XCTFail("[Test Failed] PhotoThumbnailManager class not initialized. Check Authorization in Settings Menu.")
            return
        }
        
        let promise = expectation(description: "Image Fetch Success")
        
        manager.getThumbnailImages { resultImage, _ in
            if let _ = resultImage {
                promise.fulfill()
            } else {
                XCTFail("[Test Failed] Fetch Photo.")
            }
        }
        
        wait(for: [promise], timeout: 5)
    }
}
