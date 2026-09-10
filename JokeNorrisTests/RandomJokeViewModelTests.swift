//
//  RandomJokeViewModelTests.swift
//  JokeNorris
//
//  Created by Uziel Sabalza on 10/9/26.
//


import Testing
import Foundation
@testable import JokeNorris

@Suite("Pruebas Unitarias para RandomJokeViewModel")
struct RandomJokeViewModelTests {
    
    @Test("Verificar la descarga exitosa del chiste del día")
    @MainActor
    func testLoadJokeSuccess() async {
        // Given (Dado)
        let mockService = MockChuckNorrisService()
        let expectedJoke = JokeDTO.createRandomJokeMock()
        mockService.mockJoke = expectedJoke
        
        let sut = RandomJokeViewModel(service: mockService) // System Under Test
        
        // El estado inicial debe ser limpio
        #expect(sut.currentJoke == nil)
        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == nil)
        
        // When (Cuando)
        await sut.loadJoke()
        
        // Then (Entonces)
        #expect(sut.currentJoke != nil)
        #expect(sut.currentJoke?.id == "chk-999")
        #expect(sut.currentJoke?.value == "Chuck Norris can delete the Recycling Bin.")
        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == nil)
    }
    
    @Test("Verificar el manejo correcto de errores cuando falla la conexión de red")
    @MainActor
    func testLoadJokeFailure() async {
        // Given (Dado)
        let mockService = MockChuckNorrisService()
        mockService.shouldThrowError = true // Forzamos un error de red
        
        let sut = RandomJokeViewModel(service: mockService)
        
        // When (Cuando)
        await sut.loadJoke()
        
        // Then (Entonces)
        #expect(sut.currentJoke == nil)
        #expect(sut.isLoading == false)
        #expect(sut.errorMessage != nil)
        
        // Validamos que el mensaje de error guardado corresponda a la descripción localizada del fallo
        let expectedURLError = URLError(.notConnectedToInternet)
        #expect(sut.errorMessage == expectedURLError.localizedDescription)
    }
    
    @Test("Verificar el ciclo del estado de carga (isLoading) durante la petición")
    @MainActor
    func testLoadingStateCycle() async {
        // Given (Dado)
        let mockService = MockChuckNorrisService()
        mockService.mockJoke = JokeDTO.createRandomJokeMock()
        let sut = RandomJokeViewModel(service: mockService)
        
        // Validamos que inicia en falso
        #expect(sut.isLoading == false)
        
        // Cuando ejecutamos de forma asíncrona, capturamos el flujo
        let task = Task {
            await sut.loadJoke()
        }
        
        // Then (Entonces)
        // Nota: Al usar defer { isLoading = false } en la implementación, 
        // una vez que la tarea termina por completo vuelve a false. 
        await task.value
        #expect(sut.isLoading == false)
    }
}
