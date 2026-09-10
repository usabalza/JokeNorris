//
//  Endpoints.swift
//  JokeNorris
//
//  Created by Uziel Sabalza on 9/9/26.
//

import Foundation

enum Endpoints {
    case randomJoke
    case categories
    case categoryJoke(category: String)
    case search(query: String)
    
    private var baseString: String {
        return "https://api.chucknorris.io/jokes/"
    }
    
    var urlString: String {
        switch self {
        case .randomJoke:
            return baseString + "random"
        case .categories:
            return baseString + "categories"
        case .categoryJoke(let category):
            guard var components = URLComponents(string: baseString + "random") else { return "" }
            components.queryItems = [
                URLQueryItem(name: "category", value: category)
            ]
            return components.url?.absoluteString ?? ""
        case .search(let query):
            guard var components = URLComponents(string: baseString + "search") else { return "" }
            components.queryItems = [
                URLQueryItem(name: "query", value: query)
            ]
            return components.url?.absoluteString ?? ""
        }
    }
}
