//
//  APIServices.swift
//  JokeNorris
//
//  Created by Uziel Sabalza on 9/9/26.
//

import Foundation

protocol ServiceProtocol {
    @MainActor func fetchRandomJoke(category: String?) async throws -> JokeDTO
    @MainActor func fetchCategories() async throws -> [String]
    @MainActor func fetchJokeByCategory(category: String) async throws -> JokeDTO
    @MainActor func searchJokes(query: String) async throws -> SearchResultDTO
}

class APIServices: ServiceProtocol {
    var networkManager = NetworkManager()
    
    func fetchRandomJoke(category: String?) async throws -> JokeDTO {
        return try await networkManager.request(endpoint: Endpoints.randomJoke.urlString)
    }
    
    func fetchCategories() async throws -> [String] {
        return try await networkManager.request(endpoint: Endpoints.categories.urlString)
    }
    
    func fetchJokeByCategory(category: String) async throws -> JokeDTO {
        return try await networkManager.request(endpoint: Endpoints.categoryJoke(category: category).urlString)
    }
    
    func searchJokes(query: String) async throws -> SearchResultDTO {
        return try await networkManager.request(endpoint: Endpoints.search(query: query).urlString)
    }
    
}
