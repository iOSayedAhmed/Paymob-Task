//
//  SplashScreenViewModel.swift
//  Paymob-Task
//
//  Created by iOSAYed on 06/07/2024.
//

import RxSwift
import RxCocoa

protocol SplachViewModelType {
    var animationCompleted: BehaviorSubject<Bool> { get }
    func animationDidFinish()
    func goToMainTabBar()
    func didDisAppear()
}

final class SplashViewModel: SplachViewModelType {
    weak var coordinator: SplashCoordinator?
    
    init(coordinator: SplashCoordinator? = nil) {
        self.coordinator = coordinator
    }
    
    let animationCompleted: BehaviorSubject<Bool> = .init(value: false)

    func animationDidFinish() {
        animationCompleted.onNext(true)
    }
    
    func goToMainTabBar() {
        coordinator?.startMainTabBarCoordinator()
    }
    
    func didDisAppear() {
        coordinator?.didDisAppear()
    }
}
