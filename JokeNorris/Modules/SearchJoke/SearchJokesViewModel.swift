//
//  SearchJokesViewModel.swift
//  JokeNorris
//
//  Created by Uziel Sabalza on 10/9/26.
//

import Foundation
import Combine

class SearchJokesViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published var results: [JokeDTO] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service: ServiceProtocol
    
    init(service: ServiceProtocol = APIServices()) {
        self.service = service
    }
    
    func performSearch() async {
        // La API requiere un mínimo de 3 caracteres para buscar
        guard searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).count >= 3 else {
            self.results = []
            self.errorMessage = "Escribe al menos 3 caracteres."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let searchResult = try await service.searchJokes(query: searchQuery)
            self.results = searchResult.result
            if searchResult.result.isEmpty {
                self.errorMessage = "No se encontraron chistes para '\(searchQuery)'."
            }
        } catch {
            self.errorMessage = error.localizedDescription
            self.results = []
        }
        
        isLoading = false
    }
}
