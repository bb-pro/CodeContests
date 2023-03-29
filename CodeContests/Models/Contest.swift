//
//  Contest.swift
//  CodeContests
//
//  Created by Bektemur Mamashayev on 27/03/23.
//

import Foundation

struct Contest {
    let name: String
    let url: String
    let startTime: String
    let endTime: String
    let site: String
    var isFavourite = false
    var isRegistered = false
    
    init(contestData: [String: Any]) {
        name = contestData["name"] as? String ?? ""
        url = contestData["url"] as? String ?? ""
        startTime = contestData["start_time"] as? String ?? ""
        endTime = contestData["end_time"] as? String ?? ""
        site = contestData["site"] as? String ?? ""
    }
    
    static func getContests(from value: Any) -> [Contest] {
        guard let contestData = value as? [[String: Any]] else { return [] }
        return contestData.map { Contest(contestData: $0) }
    }
}
