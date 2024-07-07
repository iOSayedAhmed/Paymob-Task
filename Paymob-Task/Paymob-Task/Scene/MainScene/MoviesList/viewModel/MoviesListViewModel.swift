//
//  MoviesListViewModel.swift
//  Paymob-Task
//
//  Created by iOSAYed on 06/07/2024.
//

import RxSwift
import RxCocoa

class MoviesListViewModel {
    public var manager = NetworkService()
    let storageManager = StorageManager.shared
    
    var coordinator: MoviesListCoordinator
    init(coordinator: MoviesListCoordinator) {
        self.coordinator = coordinator
    }
    
    let isLoading = BehaviorSubject<Bool>(value: true)
    let movies = BehaviorRelay<[Movie]>(value: [])
    
    private var page: Int = 1
    
    @discardableResult
    func loadNowplayingMovies(page: Int = 1) async throws -> MoviesListResponse {
        isLoading.onNext(true)
        defer { isLoading.onNext(false) }

        let response: MoviesListResponse = try await manager.request(path: .nowPlaying, parameters: ["page": "\(page)"])
        let fetchedFavorites = storageManager.fetchFavorites()

        let favoriteMovieIDs = Set(fetchedFavorites.compactMap { Int($0.id) })

        let updatedMovies = response.results.map { movie in
            let updatedMovie = movie
            if favoriteMovieIDs.contains(movie.id ?? 0) {
                updatedMovie.isFavorite = true
            }
            return updatedMovie
        }
        movies.accept(updatedMovies)
        return response
    }
    
    func loadMoreMovies() {
        Task {
            do {
                let newPage = self.page + 1
                let response: MoviesListResponse = try await manager.request(path: .nowPlaying, parameters: ["page": "\(newPage)"])
                let fetchedFavorites = storageManager.fetchFavorites()
                   
                let favoriteMovieIDs = Set(fetchedFavorites.compactMap { Int($0.id) })
                   
                let newMovies = response.results.map { movie in
                    let updatedMovie = movie
                    if favoriteMovieIDs.contains(movie.id ?? 0) {
                        updatedMovie.isFavorite = true
                    }
                    return updatedMovie
                }

                var currentMovies = movies.value
                currentMovies.append(contentsOf: newMovies)
                movies.accept(currentMovies)
                self.page = newPage
            } catch {
                self.page = -1
            }
        }
    }
    
    func selectedMovie(at index: Int) -> Movie? {
        guard !movies.value.isEmpty else { return nil }
        
        return movies.value[index]
    }
    
    func toggleFavorite(movie: Movie) {
        let updatedMovie = movie
        updatedMovie.isFavorite.toggle()

        if updatedMovie.isFavorite {
            storageManager.saveFavorite(movie: updatedMovie)
        } else {
            storageManager.deleteFavorite(movie: updatedMovie)
        }

        if let index = movies.value.firstIndex(where: { $0.id == movie.id }) {
            var currentMovies = movies.value
            currentMovies[index] = updatedMovie
            movies.accept(currentMovies)
        }
    }
    
    func goToMovieDetails(movie: Movie) {
        coordinator.goToMovieDetails(movie: movie)
    }
}
