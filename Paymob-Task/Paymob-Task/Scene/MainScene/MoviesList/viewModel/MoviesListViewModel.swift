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
    private let storageManager = StorageManager.shared
    
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
        
        let fetchedMovies = storageManager.fetchMovies()
        
        if fetchedMovies.isEmpty {
            let response: MoviesListResponse = try await manager.request(path: .nowPlaying, parameters: ["page": "\(page)"])
            movies.append(contentsOf: response.results)
            storageManager.saveMovies(movies: movies)
            return response
        } else {
            movies = fetchedMovies.map {
                Movie(backdropPath: $0.backgroundImage ?? "", genreIDS: [], overview: $0.overView ?? "", posterPath: $0.image ?? "", releaseDate: $0.releaseDate ?? "", title: $0.title ?? "", voteCount: Int($0.voteCount))
            }
            return MoviesListResponse(results: movies)
        }
    }
    
    func loadMoreMovies() {
        Task {
            do {
                let newPage = self.page + 1
                let response: MoviesListResponse = try await manager.request(path: .nowPlaying, parameters: ["page": "\(newPage)"])
                movies.append(contentsOf: response.results)
                storageManager.saveMovies(movies: movies)
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
    
    func goToMovieDetails(movie:Movie){
        print(movie.title)
        coordinator.goToMovieDetails(movie: movie)
    }
}
