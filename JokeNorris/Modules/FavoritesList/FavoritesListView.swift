//
//  FavoritesListView.swift
//  JokeNorris
//
//  Created by Uziel Sabalza on 9/9/26.
//

import SwiftUI
import SwiftData

struct FavoritesListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FavoriteJoke.createdAt, order: .reverse) private var favoriteJokes: [FavoriteJoke]
    
    var body: some View {
        NavigationStack {
            Group {
                if favoriteJokes.isEmpty {
                    ContentUnavailableView("Sin Favoritos", systemImage: "heart.slash", description: Text("Chistes guardados aparecerán aquí."))
                } else {
                    List {
                        ForEach(favoriteJokes) { joke in
                            Text(joke.value).padding(.vertical, 4)
                        }
                        .onDelete(perform: deleteJokes)
                    }
                }
            }
            .navigationTitle("Favoritos")
        }
    }
    
    private func deleteJokes(offsets: IndexSet) {
        for index in offsets { modelContext.delete(favoriteJokes[index]) }
    }
}
