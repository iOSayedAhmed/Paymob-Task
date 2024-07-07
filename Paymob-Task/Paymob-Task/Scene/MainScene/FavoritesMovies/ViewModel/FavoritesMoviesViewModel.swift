//
//  FavoritesMoviesViewModel.swift
//  Paymob-Task
//
//  Created by iOSAYed on 07/07/2024.
//

import Foundation
import RxSwift
import RxCocoa


class FavoritesMoviesViewModel {
    private let disposeBag = DisposeBag()
    var manager = NetworkService()
    let storageManager = StorageManager.shared
        
    let favoriteMovies = BehaviorRelay<[Movie]>(value: [])
    
    var coordinator: FavoritesMoviesCoordinator
    init(coordinator: FavoritesMoviesCoordinator) {
        self.coordinator = coordinator
        fetchFavoriteMovies()
        setupSubscriptions()
    }
        
    private func fetchFavoriteMovies() {
        let favoriteItems = storageManager.fetchFavorites()
        let movies = favoriteItems.map { item in
            Movie(backdropPath: item.backgroundImage ?? "", genreIDS: [], id: Int(item.id), overview: item.overView ?? "", posterPath: item.image ?? "", releaseDate: item.releaseDate ?? "", title: item.title ?? "", voteAverage: item.voteAverage, voteCount: Int(item.voteCount), isFavorite: true)
        }
        favoriteMovies.accept(movies)
    }
        
    private func setupSubscriptions() {
        storageManager.favoritesDidChange
            .subscribe(onNext: { [weak self] _ in
                self?.fetchFavoriteMovies()
            })
            .disposed(by: disposeBag)
    }
}
