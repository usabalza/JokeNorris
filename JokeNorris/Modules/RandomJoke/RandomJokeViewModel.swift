//
//  RandomJokeViewModel.swift
//  JokeNorris
//
//  Created by Uziel Sabalza on 9/9/26.
//

import Foundation
import Observation

@Observable
final class RandomJokeViewModel {
    var currentJoke: JokeDTO?
    var isLoading = false
    var errorMessage: String?
    
    private let service: ServiceProtocol
    
    init(service: ServiceProtocol = APIServices()) {
        self.service = service
    }
    
    func loadJoke() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            currentJoke = try await service.fetchRandomJoke(category: nil)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
