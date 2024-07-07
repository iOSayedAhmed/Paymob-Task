//
//  MovieDetailsViewModel.swift
//  Paymob-Task
//
//  Created by iOSAYed on 06/07/2024.
//

import Combine
import Foundation

class MovieDetailsViewModel {
    private let config = ConfigurationManager.shared
    private let storageManager = StorageManager.shared

    weak var coordinator: MovieDetailsCoordinator?
    private var movie: Movie
    @Published var isFavorite: Bool
    private var cancellables: Set<AnyCancellable> = []
    
    init(coordinator: MovieDetailsCoordinator? = nil, movie: Movie) {
        self.coordinator = coordinator
        self.movie = movie
        self.isFavorite = movie.isFavorite
    }
    
    var title: String {
        return movie.title
    }
    
    var overview: String {
        return movie.overview
    }
    
    var genreIds: String {
        return "Genre Ids: " + movie.genreIDS.map { "\($0)" }.joined(separator: ",")
    }
    
    var releaseDate: String {
        return "Release Date: " + movie.releaseDate
    }
    
    var imageURL: String {
        if let imageURL = try? config.xconfigValue(key: .imageURL) {
            return "\(imageURL)" + (movie.backdropPath ?? "")
        }
        return ""
    }
    
    var rating: String {
        let formattedVoteAverage = String(format: "%.2f", movie.voteAverage ?? 0.0)
        return "Rating \(formattedVoteAverage) ⭐️"
    }
    
    func toggleFavorite() {
        isFavorite.toggle()
        movie.isFavorite = isFavorite
        if isFavorite {
            storageManager.saveFavorite(movie: movie)
        } else {
            storageManager.deleteFavorite(movie: movie)
        }
        NotificationCenter.default.post(name: .favoriteStatusChanged, object: movie)
    }
}
