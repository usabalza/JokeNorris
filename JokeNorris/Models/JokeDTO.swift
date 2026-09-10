//
//  JokeDTO.swift
//  JokeNorris
//
//  Created by Uziel Sabalza on 9/9/26.
//

import Foundation

struct JokeDTO: Codable, Equatable {
    let id: String
    let value: String
    let icon_url: String
    let created_at: String
    let updated_at: String?
    let categories: [String]?
}
