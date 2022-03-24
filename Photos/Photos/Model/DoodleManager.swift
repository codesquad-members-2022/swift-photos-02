//
//  DoodleManager.swift
//  PhotoApp
//
//  Created by Bumgeun Song on 2022/03/24.
//

import Foundation

class DoodleManager {
    
    func fecthDoodle() -> Doodle? {
        let decoder = JSONDecoder()
        let testJSON =
        
"""

{
            "title":"1",
            "image":"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSmETnjE9_LGsbWjeNCwlRJ4Ox1ioqxEVtWd7Z4QCKHtI7PewxvEg",
            "date":"20140116"
        }
"""
        
        let testDoodle = try? decoder.decode(Doodle.self, from: testJSON.data(using: .utf8)!)
        return testDoodle
    }
    
}
