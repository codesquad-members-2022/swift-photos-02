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
    
    private var doodles = [Doodle]()
    var doodlesCount: Int {
        return doodles.count
    }
    
    subscript(index: Int) -> Doodle? {
        guard 0 <= index, index < doodles.count else { return nil }
        return doodles[index]
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
        didUpdate()
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
            self.doodles = try decoder.decode([Doodle].self, from: doodleJSONData)
        } catch {
            print(error)
        }
    }
}
