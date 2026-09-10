//
//  CategoriesViewModelTests.swift
//  JokeNorris
//
//  Created by Uziel Sabalza on 10/9/26.
//


import Testing
import Foundation
@testable import JokeNorris

@Suite("Pruebas Unitarias para CategoriesViewModel")
struct CategoriesViewModelTests {
    
    // --- Pruebas de Categorías ---
    
    @Test("Verificar carga exitosa de categorías")
    @MainActor
    func testLoadCategoriesSuccess() async {
        // Given (Dado)
        let mockService = MockChuckNorrisService()
        mockService.mockCategories = ["dev", "movie", "science"]
        let sut = CategoriesListViewModel(service: mockService) // System Under Test
        
        // When (Cuando)
        await sut.loadCategories()
        
        // Then (Entonces)
        #expect(sut.categories.count == 3)
        #expect(sut.categories.first == "dev")
        #expect(sut.isListLoading == false)
    }
    
    @Test("Verificar que no se recarguen categorías si ya existen datos")
    @MainActor
    func testLoadCategoriesAvoidsDuplicateFetch() async {
        // Given
        let mockService = MockChuckNorrisService()
        mockService.mockCategories = ["fashion"]
        let sut = CategoriesListViewModel(service: mockService)
        sut.categories = ["animal", "food"] // Simulamos que ya tiene datos
        
        // When
        await sut.loadCategories()
        
        // Then
        #expect(sut.categories.count == 2) // No debió cambiar
        #expect(sut.categories.contains("animal"))
        #expect(sut.isListLoading == false)
    }
    
    // --- Pruebas de Chistes ---
    
    @Test("Verificar carga exitosa de un chiste por categoría")
    @MainActor
    func testLoadJokeSuccess() async {
        // Given
        let mockService = MockChuckNorrisService()
        let expectedJoke = JokeDTO.createCategoryJokeMock()
        mockService.mockJoke = expectedJoke
        let sut = CategoriesListViewModel(service: mockService)
        
        // When
        await sut.loadJoke(for: "dev")
        
        // Then
        #expect(sut.currentJoke != nil)
        #expect(sut.currentJoke?.id == "abc")
        #expect(sut.currentJoke?.value == "Chuck Norris code compiles on the first try.")
        #expect(sut.isJokeLoading == false)
    }
    
    @Test("Verificar el manejo de errores al fallar la red")
    @MainActor
    func testLoadJokeFailure() async {
        // Given
        let mockService = MockChuckNorrisService()
        mockService.shouldThrowError = true
        let sut = CategoriesListViewModel(service: mockService)
        
        // When
        await sut.loadJoke(for: "movie")
        
        // Then
        #expect(sut.currentJoke == nil)
        #expect(sut.isJokeLoading == false)
        // Nota: Si agregas una propiedad 'errorMessage' en tu ViewModel, aquí verificarías su valor.
    }
    
    @Test("Verificar limpieza del estado al cerrar el módulo")
    @MainActor
    func testClearCurrentJoke() {
        // Given
        let sut = CategoriesListViewModel(service: MockChuckNorrisService())
        sut.currentJoke = JokeDTO(id: "1", value: "Test", icon_url: "", created_at: "")
        
        // When
        sut.clearCurrentJoke()
        
        // Then
        #expect(sut.currentJoke == nil)
    }
}
