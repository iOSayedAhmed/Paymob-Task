//
//  MoviesListViewModel.swift
//  Paymob-Task
//
//  Created by iOSAYed on 06/07/2024.
//

import Foundation
import Combine

class MoviesListViewModel {
    public var manager = NetworkService()
    private let storageManager = StorageManager.shared
    
    weak var coordinator:MoviesListCoordinator?
        init(coordinator: MoviesListCoordinator? = nil) {
            self.coordinator = coordinator
            print("Shown")
        }
    
    @Published var isLoading = true
    @Published var movies: [Movie] = []
    
    private var page: Int = 1
    
    @discardableResult
    func loadNowplayingMovies(page: Int = 1) async throws -> NowPlayingResponse {
        isLoading = true
        defer { isLoading = false }
        
        let fetchedMovies = storageManager.fetchMovies()
        
        if fetchedMovies.isEmpty {
            let response: NowPlayingResponse = try await manager.request(path: .nowPlaying, parameters: ["page": "\(page)"])
            movies.append(contentsOf: response.results)
            storageManager.saveMovies(movies: movies)
            return response
        } else {
            movies = fetchedMovies.map {
                Movie(backdropPath: $0.backgroundImage ?? "", genreIDS: [], overview: $0.overView ?? "", posterPath: $0.image ?? "", releaseDate: $0.releaseDate ?? "", title: $0.title ?? "", voteCount: Int($0.voteCount))
            }
            return NowPlayingResponse(results: movies)
        }
    }
    
    func loadMoreMovies() {
        Task {
            do {
                let newPage = self.page + 1
                let response: NowPlayingResponse = try await manager.request(path: .nowPlaying, parameters: ["page": "\(newPage)"])
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
}
