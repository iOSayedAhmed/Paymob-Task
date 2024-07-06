//
//  MoviesListCoordinator.swift
//  Paymob-Task
//
//  Created by iOSAYed on 06/07/2024.
//

import Foundation
import UIKit

final class MoviesListCoordinator:Coordinator {

    
    private(set) var childCoordinators: [Coordinator] = []
    var parentCoordinator:AppCoordinator?
     let navigationController:UINavigationController
    
    init(navigationController:UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        let NowPlayingViewModel = MoviesListViewModel(coordinator: self)
        let NowPlayingVC = MoviesListViewController(viewModel: NowPlayingViewModel, nibName: "\(MoviesListViewController.self)")
        NowPlayingVC.viewModel = NowPlayingViewModel
        navigationController.setViewControllers([NowPlayingVC], animated: true)
    }
}
