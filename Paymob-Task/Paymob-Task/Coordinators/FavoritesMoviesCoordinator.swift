//
//  FavoritesMoviesCoordinator.swift
//  Paymob-Task
//
//  Created by iOSAYed on 07/07/2024.
//

import Foundation
import UIKit

final class FavoritesMoviesCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    var parentCoordinator: AppCoordinator?
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let moviesListViewModel = FavoritesMoviesViewModel(coordinator: self)
        let moviesListVC = FavoritesMoviesViewController(viewModel: moviesListViewModel, nibName: FavoritesMoviesViewController.className)
        navigationController.setViewControllers([moviesListVC], animated: true)
    }
}
