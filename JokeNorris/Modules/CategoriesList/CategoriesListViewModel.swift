//
//  CategoriesListViewModel.swift
//  JokeNorris
//
//  Created by Uziel Sabalza on 9/9/26.
//

import SwiftUI
import Combine

final class CategoriesListViewModel: ObservableObject {
    @Published var categories: [String] = []
    @Published var selectedCategory: String = ""
    @Published var currentJoke: JokeDTO? = nil
    @Published var isListLoading = false
    @Published var isJokeLoading = false
    
    private let service: ServiceProtocol
    
    init(service: ServiceProtocol = APIServices()) {
        self.service = service
    }
    
    func loadCategories() async {
        guard categories.isEmpty else { return }
        isListLoading = true
        defer { isListLoading = false }
        
        do {
            categories = try await service.fetchCategories()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadJoke(for category: String) async {
        isJokeLoading = true
        defer { isJokeLoading = false }
        
        do {
            currentJoke = try await service.fetchRandomJoke(category: category)
        } catch {
            print("Error cargando chiste de categoría \(category): \(error.localizedDescription)")
        }
    }
    
    // Limpiar el estado del chiste al cerrar el Sheet
    func clearCurrentJoke() {
        currentJoke = nil
    }
}
