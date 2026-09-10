//
//  SearchJokesView.swift
//  JokeNorris
//
//  Created by Uziel Sabalza on 10/9/26.
//


import SwiftUI
import SwiftData

struct SearchJokesView: View {
    @StateObject private var viewModel: SearchJokesViewModel
    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [FavoriteJoke]
    
    init() {
        self._viewModel = StateObject(wrappedValue: SearchJokesViewModel())
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Buscando en los archivos de Chuck...")
                } else if let error = viewModel.errorMessage {
                    ContentUnavailableView("Sin Resultados", systemImage: "magnifyingglass", description: Text(error))
                } else if viewModel.results.isEmpty {
                    ContentUnavailableView("Buscar Chistes", systemImage: "sparkles", description: Text("Encuentra verdades absolutas sobre Chuck Norris."))
                } else {
                    List(viewModel.results) { joke in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(joke.value)
                                .font(.body)
                            
                            HStack {
                                Spacer()
                                Button(action: { toggleFavorite(joke) }) {
                                    Image(systemName: isFavorite(joke) ? "heart.fill" : "heart")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Buscar")
            .searchable(text: $viewModel.searchQuery, prompt: "Ej. Apple, Code, Zombie...")
            // Lanza la búsqueda cuando el usuario presiona "Buscar" en el teclado
            .onSubmit(of: .search) {
                Task { await viewModel.performSearch() }
            }
            // Limpia los resultados si el usuario borra la barra de búsqueda completamente
            .onChange(of: viewModel.searchQuery) { _, newValue in
                if newValue.isEmpty {
                    viewModel.results = []
                    viewModel.errorMessage = nil
                }
            }
        }
    }
    
    private func isFavorite(_ joke: JokeDTO) -> Bool {
        favorites.contains { $0.id == joke.id }
    }
    
    private func toggleFavorite(_ joke: JokeDTO) {
        if isFavorite(joke) {
            if let fav = favorites.first(where: { $0.id == joke.id }) { modelContext.delete(fav) }
        } else {
            modelContext.insert(FavoriteJoke(id: joke.id, value: joke.value, iconUrl: joke.icon_url, createdAt: joke.created_at))
        }
    }
}
