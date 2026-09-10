//
//  CategoryJokeView.swift
//  JokeNorris
//
//  Created by Uziel Sabalza on 9/9/26.
//

import SwiftUI
import SwiftData

import SwiftUI

struct CategoryJokeView: View {
    let category: String
    let jokeValue: String?
    let isLoading: Bool
    let isFavorite: Bool
    
    // Closures de comunicación
    let onRefresh: () -> Void
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        VStack(spacing: 25) {
            if isLoading {
                ProgressView()
                    .scaleEffect(1.2)
            } else if let jokeValue = jokeValue {
                Spacer()
                
                Text(jokeValue)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                
                Button(action: onFavoriteToggle) {
                    Label(
                        isFavorite ? "En Favoritos" : "Guardar",
                        systemImage: isFavorite ? "heart.fill" : "heart"
                    )
                }
                .buttonStyle(.bordered)
                .tint(.red)
                .controlSize(.large)
                
                Spacer()
            }
        }
        .padding()
        .navigationTitle(category.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: onRefresh) {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }
}
