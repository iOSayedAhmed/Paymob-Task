//
//  MoviesListCoordinator.swift
//  Paymob-Task
//
//  Created by iOSAYed on 06/07/2024.
//

import Foundation
import UIKit

final class MoviesListCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    var parentCoordinator: AppCoordinator?
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let moviesListViewModel = MoviesListViewModel(coordinator: self)
        let moviesListVC = MoviesListViewController(viewModel: moviesListViewModel, nibName: MoviesListViewController.className)
        navigationController.setViewControllers([moviesListVC], animated: true)
    }

    func goToMovieDetails(movie: Movie) {
        let movieDetailsCoordinator = MovieDetailsCoordinator(navigationController: navigationController, movie: movie)
        movieDetailsCoordinator.start()
    }
}
