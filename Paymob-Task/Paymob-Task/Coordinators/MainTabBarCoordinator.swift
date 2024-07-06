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
        
        let nowPlayingCoordinator = MoviesListCoordinator(navigationController: UINavigationController())
       
        nowPlayingCoordinator.start()

        let nowPlayingNavigationController = nowPlayingCoordinator.navigationController
        
        nowPlayingNavigationController.title = "Now Playing"
        nowPlayingNavigationController.tabBarItem.selectedImage = UIImage(systemName: "newspaper.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        nowPlayingNavigationController.tabBarItem.image = UIImage(systemName: "newspaper.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)

        tabBarController.viewControllers = [nowPlayingNavigationController]
        navigationController.setViewControllers([tabBarController], animated: false)
    }
    
    
   
}
