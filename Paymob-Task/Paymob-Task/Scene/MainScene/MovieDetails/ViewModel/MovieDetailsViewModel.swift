//
//  MovieDetailsViewModel.swift
//  Paymob-Task
//
//  Created by iOSAYed on 06/07/2024.
//

import Foundation

class MovieDetailsViewModel {
    private let config = ConfigurationManager.shared
    
    weak var coordinator: MovieDetailsCoordinator?
    private let movie: Movie
    
    init(coordinator: MovieDetailsCoordinator? = nil, movie: Movie) {
        self.coordinator = coordinator
        self.movie = movie
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
}
