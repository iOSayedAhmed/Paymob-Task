//
//  SplashScreenViewModel.swift
//  Paymob-Task
//
//  Created by iOSAYed on 06/07/2024.
//

import Combine
import Foundation

protocol SplachViewModelType {
    var animationCompleted: CurrentValueSubject<Bool, Never> { get }
    func animationDidFinish()
    func goToMainTabBar()
    func didDisAppear()
}

final class SplashViewModel: SplachViewModelType {
    weak var coordinator: SplashCoordinator?
    
    init(coordinator: SplashCoordinator? = nil) {
        self.coordinator = coordinator
    }
    
    let animationCompleted: CurrentValueSubject<Bool, Never> = .init(false)

    func animationDidFinish() {
        animationCompleted.send(true)
    }
    
    func goToMainTabBar() {
        coordinator?.startMainTabBarCoordinator()
    }
    
    func didDisAppear() {
        coordinator?.didDisAppear()
    }
}
