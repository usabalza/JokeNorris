//
//  CategoriesListView.swift
//  JokeNorris
//
//  Created by Uziel Sabalza on 9/9/26.
//

import SwiftUI
import SwiftData

struct CategoriesListView: View {
    @StateObject var viewModel: CategoriesListViewModel
    @State private var selectedCategory: IdentifiableCategory?
    
    // Acceso a SwiftData restringido solo a la vista principal
    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [FavoriteJoke]
    
    init() {
        self._viewModel = StateObject(wrappedValue: CategoriesListViewModel())
    }
    
    var body: some View {
        NavigationStack {
            List(viewModel.categories, id: \.self) { category in
                Button(action: {
                    selectedCategory = IdentifiableCategory(id: category)
                }) {
                    HStack {
                        Text(category.capitalized).font(.headline).foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.right").font(.footnote).foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Categorías")
            .overlay {
                if viewModel.isListLoading { ProgressView() }
            }
            .task {
                await viewModel.loadCategories()
            }
            // Presentación reactiva del Sheet
            .sheet(item: $selectedCategory, onDismiss: { viewModel.clearCurrentJoke() }) { identifiableCategory in
                NavigationStack {
                    CategoryJokeView(
                        category: identifiableCategory.id,
                        jokeValue: viewModel.currentJoke?.value,
                        isLoading: viewModel.isJokeLoading,
                        isFavorite: checkIfFavorite(viewModel.currentJoke),
                        onRefresh: {
                            Task { await viewModel.loadJoke(for: identifiableCategory.id) }
                        },
                        onFavoriteToggle: {
                            toggleFavorite(viewModel.currentJoke)
                        }
                    )
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Listo") { selectedCategory = nil }
                        }
                    }
                }
                .task {
                    // Carga inicial del chiste al abrir el sheet
                    await viewModel.loadJoke(for: identifiableCategory.id)
                }
            }
        }
    }
    
    // Lógicas de persistencia locales inyectadas a través de funciones de la vista principal
    private func checkIfFavorite(_ joke: JokeDTO?) -> Bool {
        guard let joke = joke else { return false }
        return favorites.contains { $0.id == joke.id }
    }
    
    private func toggleFavorite(_ joke: JokeDTO?) {
        guard let joke = joke else { return }
        if checkIfFavorite(joke) {
            if let favToDelete = favorites.first(where: { $0.id == joke.id }) {
                modelContext.delete(favToDelete)
            }
        } else {
            let newFavorite = FavoriteJoke(id: joke.id, value: joke.value, iconUrl: joke.icon_url, createdAt: joke.created_at)
            modelContext.insert(newFavorite)
        }
    }
}
