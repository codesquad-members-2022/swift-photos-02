//
//  Doodle.swift
//  PhotoApp
//
//  Created by Bumgeun Song on 2022/03/24.
//

import Foundation

struct Doodle: Codable {
    private(set) var title: String
    private(set) var imageURL: URL
    private(set) var date: Date
    private(set) var imageData: Data?
    
    init(title: String, imageURL: URL, date: Date) {
        self.title = title
        self.imageURL = imageURL
        self.date = date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DoodleJsonKeys.self)
        
        guard let decodedTitle = try? container.decode(String.self, forKey: .title) else {
            throw DoodleDecodeError.titleTypeMismatched
        }
        guard let decodedURL = try? container.decode(URL.self, forKey: .image) else {
            throw DoodleDecodeError.imageTypeMismatched
        }
        guard let decodedDateString = try? container.decode(Date.self, forKey: .date) else {
            throw DoodleDecodeError.dateTypeMismatched
        }
        
        self.title = decodedTitle
        self.imageURL = decodedURL
        self.date = decodedDateString
    }
    
    mutating func setFetchedImageData(_ data: Data) {
        self.imageData = data
    }
    
    enum DoodleJsonKeys: String, CodingKey {
        case title = "title"
        case image = "image"
        case date = "date"
    }
    
    enum DoodleDecodeError: String, Error {
        case titleTypeMismatched = "title 타입이 명확하지 않습니다."
        case imageTypeMismatched = "image url 타입이 명확하지 않습니다."
        case dateTypeMismatched = "date 타입이 명확하지 않습니다."
    }
}

extension Doodle: Equatable {
    static func == (lh: Doodle, rh: Doodle) -> Bool {
        (lh.title == rh.title) &&
        (lh.imageURL == rh.imageURL) &&
        (lh.date == rh.date)
    }
}
