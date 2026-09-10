//
//  SearchResultDTO.swift
//  JokeNorris
//
//  Created by Uziel Sabalza on 10/9/26.
//

struct SearchResultDTO: Codable, Equatable {
    let total: Int
    let result: [JokeDTO]
}
