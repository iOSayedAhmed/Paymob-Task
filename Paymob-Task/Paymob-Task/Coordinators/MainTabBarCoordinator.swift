//
//  MainTabBarCoordinator.swift
//  Paymob-Task
//
//  Created by iOSAYed on 06/07/2024.
//

import Foundation
import UIKit

final class MainTabBarCoordinator: Coordinator {
    private(set)var childCoordinators: [Coordinator] = []
    
     let navigationController:UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        let tabBarController = MainTabBarController()
        
        
        let moviesListCoordinator = MoviesListCoordinator(navigationController: UINavigationController())
       
        moviesListCoordinator.start()

        let moviesListNavigationController = moviesListCoordinator.navigationController
        
        moviesListNavigationController.title = "Now Playing"
        moviesListNavigationController.tabBarItem.selectedImage = UIImage(systemName: "newspaper.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        moviesListNavigationController.tabBarItem.image = UIImage(systemName: "newspaper.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        childCoordinators.append(moviesListCoordinator)
        tabBarController.viewControllers = [moviesListNavigationController]
        navigationController.setViewControllers([tabBarController], animated: false)
    }
    
    
   
}
