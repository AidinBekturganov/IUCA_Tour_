//
//  Place.swift
//  IUCA Tour
//
//  Created by User on 2/17/22.
//

import UIKit

struct Place: Decodable, Equatable {
    var currentPlaceId: Int?
    var id: Int?
    var order: Int?
    var name: String?
    var desc: String?
    var onMap: String?
    var audio: String?
    var lang: String?
    var images: [String]?
}
