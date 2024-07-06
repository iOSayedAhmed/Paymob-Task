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
      
    }
    
    
   
}
