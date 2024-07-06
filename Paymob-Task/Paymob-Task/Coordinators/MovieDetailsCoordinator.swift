//
//  MoviesDetailsCoordinator.swift
//  Paymob-Task
//
//  Created by iOSAYed on 06/07/2024.
//

import Foundation
import UIKit

final class MovieDetailsCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    var movie: Movie

    init(navigationController: UINavigationController, movie: Movie) {
        self.navigationController = navigationController
        self.movie = movie
    }

    func start() {
        let moviesDetailsViewModel = MovieDetailsViewModel(coordinator: self, movie: movie)
        let moviesDetailsVC = MovieDetailsViewController(viewModel: moviesDetailsViewModel, nibName: MovieDetailsViewController.className)
        moviesDetailsVC.viewModel = moviesDetailsViewModel
        navigationController.tabBarController?.tabBar.isHidden = true
        navigationController.navigationBar.isHidden = false
        navigationController.pushViewController(moviesDetailsVC, animated: true)
    }
}
