//
//  PhotoInfo.swift
//  SpacePhoto
//
//  Created by Олег Алексеев on 22.05.2023.
//

import Foundation

struct PhotoInfo: Codable {
    var title: String
    var description: String
    var url: URL
    var copyright: String?
    var mediaType: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case description = "explanation"
        case url
        case copyright
        case mediaType = "media_type"
    }
}
