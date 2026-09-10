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
    
    func searchJoke(query: String) async throws -> [JokeDTO] {
        if shouldThrowError {
            throw URLError(.notConnectedToInternet)
        }
        if let mockJoke = mockJoke {
            return [mockJoke]
        }
        throw URLError(.badServerResponse)
    }
}
