//
//  MainTabBarCoordinator.swift
//  Paymob-Task
//
//  Created by iOSAYed on 06/07/2024.
//

import Foundation
import UIKit

final class MainTabBarCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let tabBarController = MainTabBarController()
        
        let moviesListCoordinator = MoviesListCoordinator(navigationController: UINavigationController())
        let favoriteMoviesCoordinator = FavoritesMoviesCoordinator(navigationController: UINavigationController())
       
        moviesListCoordinator.start()
        favoriteMoviesCoordinator.start()
        
        let moviesListNavigationController = moviesListCoordinator.navigationController
        let favoriteMoviesNavigationController = favoriteMoviesCoordinator.navigationController
        
        moviesListNavigationController.title = "Now Playing"
        moviesListNavigationController.tabBarItem.selectedImage = UIImage(systemName: "newspaper.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        moviesListNavigationController.tabBarItem.image = UIImage(systemName: "newspaper")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        
        favoriteMoviesNavigationController.title = "Favorites"
        favoriteMoviesNavigationController.tabBarItem.selectedImage = UIImage(systemName: "bookmark.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        favoriteMoviesNavigationController.tabBarItem.image = UIImage(systemName: "bookmark")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        
        childCoordinators.append(moviesListCoordinator)
        childCoordinators.append(favoriteMoviesCoordinator)
        tabBarController.viewControllers = [moviesListNavigationController, favoriteMoviesNavigationController]
        navigationController.setViewControllers([tabBarController], animated: false)
    }
}
