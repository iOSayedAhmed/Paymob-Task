//
//  FavoritesMoviesViewModel.swift
//  Paymob-Task
//
//  Created by iOSAYed on 07/07/2024.
//

import Combine
import Foundation

class FavoritesMoviesViewModel {
    private var cancellables: Set<AnyCancellable> = []
    var manager = NetworkService()
    let storageManager = StorageManager.shared
        
    @Published var favoriteMovies: [Movie] = []
    
    var coordinator: FavoritesMoviesCoordinator
    init(coordinator: FavoritesMoviesCoordinator) {
        self.coordinator = coordinator
        fetchFavoriteMovies()
        setupSubscriptions()
    }
        
    private func fetchFavoriteMovies() {
        let favoriteItems = storageManager.fetchFavorites()
        favoriteMovies = favoriteItems.map { item in
            Movie(backdropPath: item.backgroundImage ?? "", genreIDS: [], id: Int(item.id), overview: item.overView ?? "", posterPath: item.image ?? "", releaseDate: item.releaseDate ?? "", title: item.title ?? "", voteAverage: item.voteAverage, voteCount: Int(item.voteCount), isFavorite: true)
        }
    }
        
    private func setupSubscriptions() {
        storageManager.favoritesDidChange
            .sink { [weak self] _ in
                self?.fetchFavoriteMovies()
            }
            .store(in: &cancellables)
    }
}
