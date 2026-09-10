//
//  RandomJokeViewModel.swift
//  JokeNorris
//
//  Created by Uziel Sabalza on 9/9/26.
//

import Foundation
import Combine

class RandomJokeViewModel: ObservableObject {
    @Published var currentJoke: JokeDTO? = nil
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
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
