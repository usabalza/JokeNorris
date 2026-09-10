//
//  RandomJokeView.swift
//  JokeNorris
//
//  Created by Uziel Sabalza on 9/9/26.
//

import SwiftUI
import SwiftData

struct RandomJokeView: View {
    @StateObject var viewModel: RandomJokeViewModel
    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [FavoriteJoke]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    ProgressView("Buscando a Chuck...")
                } else if let joke = viewModel.currentJoke {
                    Text(joke.value)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    
                    HStack(spacing: 20) {
                        Button(action: toggleFavorite) {
                            Label(isFavorite ? "Favorito" : "Guardar", systemImage: isFavorite ? "heart.fill" : "heart")
                        }
                        .buttonStyle(.bordered)
                        .tint(.red)
                        
                        Button(action: { Task { await viewModel.loadJoke() } }) {
                            Label("Otro chiste", systemImage: "arrow.clockwise")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)").foregroundColor(.red)
                }
            }
            .padding()
            .navigationTitle("Chiste del Día")
            .task {
                if viewModel.currentJoke == nil { await viewModel.loadJoke() }
            }
        }
    }
    
    private var isFavorite: Bool {
        guard let id = viewModel.currentJoke?.id else { return false }
        return favorites.contains { $0.id == id }
    }
    
    private func toggleFavorite() {
        guard let joke = viewModel.currentJoke else { return }
        if isFavorite {
            if let fav = favorites.first(where: { $0.id == joke.id }) { modelContext.delete(fav) }
        } else {
            modelContext.insert(FavoriteJoke(id: joke.id, value: joke.value, iconUrl: joke.icon_url, createdAt: joke.created_at))
        }
    }
}
