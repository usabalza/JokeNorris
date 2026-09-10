//
//  SearchJokesViewModelTests.swift
//  JokeNorris
//
//  Created by Uziel Sabalza on 10/9/26.
//

import Testing
import Foundation
@testable import JokeNorris

@Suite("Pruebas Unitarias para SearchJokesViewModel")
struct SearchJokesViewModelTests {
    
    @Test("Validar que la búsqueda no se ejecute si la query tiene menos de 3 caracteres")
    @MainActor
    func testSearchQueryValidationTooShort() async {
        // Given
        let mockService = MockChuckNorrisService()
        let sut = SearchJokesViewModel(service: mockService)
        sut.searchQuery = "hi" // Menos de 3 caracteres
        
        // When
        await sut.performSearch()
        
        // Then
        #expect(sut.results.isEmpty)
        #expect(sut.errorMessage == "Escribe al menos 3 caracteres.")
        #expect(sut.isLoading == false)
    }
    
    @Test("Validar el éxito en la búsqueda devolviendo resultados válidos")
    @MainActor
    func testSearchJokesSuccess() async {
        // Given
        let mockService = MockChuckNorrisService()
        let joke1 = JokeDTO(id: "1", value: "Chuck Norris code works", icon_url: "", created_at: "")
        let joke2 = JokeDTO(id: "2", value: "Chuck Norris doesn't test, code just obeys", icon_url: "", created_at: "")
        
        mockService.mockSearchResult = SearchResultDTO(total: 2, result: [joke1, joke2])
        
        let sut = SearchJokesViewModel(service: mockService)
        sut.searchQuery = "code"
        
        // When
        await sut.performSearch()
        
        // Then
        #expect(sut.results.count == 2)
        #expect(sut.results.first?.id == "1")
        #expect(sut.errorMessage == nil)
        #expect(sut.isLoading == false)
    }
    
    @Test("Validar la respuesta limpia del sistema si no hay coincidencias (0 resultados)")
    @MainActor
    func testSearchJokesNoResultsFound() async {
        // Given
        let mockService = MockChuckNorrisService()
        mockService.mockSearchResult = SearchResultDTO(total: 0, result: [])
        
        let sut = SearchJokesViewModel(service: mockService)
        sut.searchQuery = "inexistente"
        
        // When
        await sut.performSearch()
        
        // Then
        #expect(sut.results.isEmpty)
        #expect(sut.errorMessage == "No se encontraron chistes para 'inexistente'.")
    }
    
    @Test("Validar captura de errores genéricos si falla la infraestructura de red")
    @MainActor
    func testSearchJokesNetworkFailure() async {
        // Given
        let mockService = MockChuckNorrisService()
        mockService.shouldThrowError = true
        
        let sut = SearchJokesViewModel(service: mockService)
        sut.searchQuery = "internet"
        
        // When
        await sut.performSearch()
        
        // Then
        #expect(sut.results.isEmpty)
        #expect(sut.errorMessage != nil)
        #expect(sut.errorMessage == URLError(.notConnectedToInternet).localizedDescription)
    }
}
