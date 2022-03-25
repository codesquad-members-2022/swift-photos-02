//
//  DoodleManager.swift
//  PhotoApp
//
//  Created by Bumgeun Song on 2022/03/24.
//

import Foundation

class DoodleManager {
    
    private var doodleJSONData: Data?
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMdd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter
    }()
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    
    private var doodleImageData = [Data?]()
    var doodleImageDataCount: Int {
        return doodleImageData.count
    }
    
    private var doodleMetadata = [Doodle]()
    
    subscript(index: Int) -> Data? {
        guard 0 <= index, index < doodleImageData.count else { return nil }
        return doodleImageData[index]
    }
    
    private let didUpdate: ()->Void
    
    
    // MARK: - Designated init
    
    init(from Json: Data, didUpdate: @escaping (()->Void)) {
        self.didUpdate = didUpdate
        self.doodleJSONData = Json
        self.decodeJSON()
        didUpdate()
    }

    init(forResource resource: String, withExtension ext: String, didUpdate: @escaping ()->Void) {
        self.didUpdate = didUpdate
        let url = Bundle.main.url(forResource: resource, withExtension: ext)
        self.getJSON(from: url)
        self.decodeJSON()
        self.requestImageData()
    }
    
    private func getJSON(from url: URL?) {
        guard let doodleURL = url, let doodleJSONData = try? Data(contentsOf: doodleURL) else {
            return
        }
        
        self.doodleJSONData = doodleJSONData
    }
    
    private func decodeJSON() {
        guard let doodleJSONData = doodleJSONData else {
            return
        }
        
        do {
            self.doodleMetadata = try decoder.decode([Doodle].self, from: doodleJSONData)
        } catch {
            print(error)
        }
    }
    
    private func requestImageData() {
        doodleImageData = [Data?].init(repeating: nil, count: doodleMetadata.count)
        for (index, metadata) in doodleMetadata.enumerated() {
            URLSession.init(configuration: .default).dataTask(with: metadata.imageURL) { data, response, error in
                guard error != nil else { return }
                self.doodleImageData[index] = data
                
                if index == self.doodleImageDataCount-1 {
                    self.didUpdate()
                }
            }.resume()
        }
    }
}
