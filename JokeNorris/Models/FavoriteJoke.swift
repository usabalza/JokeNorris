//
//  FavoriteJoke.swift
//  JokeNorris
//
//  Created by Uziel Sabalza on 9/9/26.
//

import Foundation
import SwiftData

@Model
final class FavoriteJoke {
    @Attribute(.unique) var id: String
    var value: String
    var iconUrl: String
    var createdAt: String
    
    init(id: String, value: String, iconUrl: String, createdAt: String) {
        self.id = id
        self.value = value
        self.iconUrl = iconUrl
        self.createdAt = createdAt
    }
}
