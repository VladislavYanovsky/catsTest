//
//  Animal.swift
//  TestTask
//
//  Created by Vladislav on 1.09.23.
//

import Foundation

typealias Animals = [Animal]

struct Animal: Codable {
    let id: String
    let name: String
    let wikipediaURL: String?
    let referenceImageId: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case wikipediaURL = "wikipedia_url"
        case referenceImageId = "reference_image_id"
    }
}
