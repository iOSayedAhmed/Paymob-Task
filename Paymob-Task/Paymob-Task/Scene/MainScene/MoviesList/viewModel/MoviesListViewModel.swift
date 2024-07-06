//
//  MoviesListViewModel.swift
//  Paymob-Task
//
//  Created by iOSAYed on 06/07/2024.
//

import Combine
import Foundation

class MoviesListViewModel {
    public var manager = NetworkService()
     let storageManager = StorageManager.shared
    
    var coordinator: MoviesListCoordinator
    init(coordinator: MoviesListCoordinator) {
        self.coordinator = coordinator
    }
    
    @Published var isLoading = true
    @Published var movies: [Movie] = []
    
    private var page: Int = 1
    
    @discardableResult
        func loadNowplayingMovies(page: Int = 1) async throws -> MoviesListResponse {
            isLoading = true
            defer { isLoading = false }

            let response: MoviesListResponse = try await manager.request(path: .nowPlaying, parameters: ["page": "\(page)"])
            let fetchedFavorites = storageManager.fetchFavorites()

            let favoriteMovieIDs = Set(fetchedFavorites.compactMap { Int($0.id) })

            movies = response.results.map { movie in
                let updatedMovie = movie
                if favoriteMovieIDs.contains(movie.id ?? 0) {
                    updatedMovie.isFavorite = true
                }
                return updatedMovie
            }
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
                       var updatedMovie = movie
                       if favoriteMovieIDs.contains(movie.id ?? 0) {
                           updatedMovie.isFavorite = true
                       }
                       return updatedMovie
                   }

                   movies.append(contentsOf: newMovies)
                   self.page = newPage
               } catch {
                   self.page = -1
               }
           }
       }
    
    func selectedMovie(at index: Int) -> Movie? {
        guard !movies.isEmpty else { return nil }
        
        return movies[index]
    }
    
    func toggleFavorite(movie: Movie) {
        let updatedMovie = movie
            updatedMovie.isFavorite.toggle()

            if updatedMovie.isFavorite {
                storageManager.saveFavorite(movie: updatedMovie)
            } else {
                storageManager.deleteFavorite(movie: updatedMovie)
            }

            if let index = movies.firstIndex(where: { $0.id == movie.id }) {
                movies[index] = updatedMovie
            }
        }
    
    func goToMovieDetails(movie:Movie){
        coordinator.goToMovieDetails(movie: movie)
    }
}
