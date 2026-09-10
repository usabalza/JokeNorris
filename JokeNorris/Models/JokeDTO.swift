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
    var updated_at: String? = nil
    var categories: [String]? = nil
}

extension JokeDTO {
    static func createRandomJokeMock() -> JokeDTO {
        return JokeDTO(
            id: "chk-999",
            value: "Chuck Norris can delete the Recycling Bin.",
            icon_url: "https://chucknorris.io",
            created_at: "2026-01-01"
        )
    }
    
    static func createCategoryJokeMock() -> JokeDTO {
        return JokeDTO(
            id: "abc",
            value: "Chuck Norris code compiles on the first try.",
            icon_url: "",
            created_at: "2026-01-01",
            updated_at: "2026-02-02",
            categories: ["dev"]
        )
    }
}
