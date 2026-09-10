//
//  MockNetworkService.swift
//  JokeNorris
//
//  Created by Uziel Sabalza on 10/9/26.
//

import Foundation
@testable import JokeNorris

final class MockChuckNorrisService: ServiceProtocol {
    
    var mockJoke: JokeDTO?
    var mockSearchResult: SearchResultDTO?
    var mockCategories: [String] = []
    var shouldThrowError = false
    
    func fetchRandomJoke(category: String?) async throws -> JokeDTO {
        if shouldThrowError {
            throw URLError(.notConnectedToInternet)
        }
        if let mockJoke = mockJoke {
            return mockJoke
        }
        throw URLError(.badServerResponse)
    }
    
    func fetchCategories() async throws -> [String] {
        if shouldThrowError {
            throw URLError(.notConnectedToInternet)
        }
        return mockCategories
    }
    
    func fetchJokeByCategory(category: String) async throws -> JokeDTO {
        if shouldThrowError {
            throw URLError(.notConnectedToInternet)
        }
        if let mockJoke = mockJoke {
            return mockJoke
        }
        throw URLError(.badServerResponse)
    }
    
    func searchJokes(query: String) async throws -> SearchResultDTO {
        if shouldThrowError {
            throw URLError(.notConnectedToInternet)
        }
        if let mockSearchResult = mockSearchResult {
            return mockSearchResult
        }
        return SearchResultDTO(total: 0, result: [])
    }
}
