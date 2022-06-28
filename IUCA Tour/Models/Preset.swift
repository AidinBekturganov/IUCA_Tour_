//
//  Preset.swift
//  IUCA Tour
//
//  Created by User on 3/3/22.
//

import Foundation

struct Order: Codable {
    var place: Int?
    var order: Int?
}

struct Preset: Codable {
    var name: String?
    var places: [Order]
}
