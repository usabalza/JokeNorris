//
//  JokeNorrisApp.swift
//  JokeNorris
//
//  Created by Uziel Sabalza on 9/9/26.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    var body: some View {
        TabView {
            RandomJokeView(viewModel: RandomJokeViewModel())
                .tabItem { Label("Al Azar", systemImage: "quote.bubble.fill") }
            
            CategoriesListView()
                .tabItem { Label("Categorías", systemImage: "list.bullet") }
            
            FavoritesListView()
                .tabItem { Label("Favoritos", systemImage: "heart.fill") }
        }
    }
}

@main
struct ChuckNorrisApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: FavoriteJoke.self)
    }
}

