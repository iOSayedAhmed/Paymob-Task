//
//  SplashScreenViewModel.swift
//  Paymob-Task
//
//  Created by iOSAYed on 06/07/2024.
//

import Foundation
import Combine


protocol SplachViewModelType {
    var animationCompleted: CurrentValueSubject<Bool, Never> { get }
    func animationDidFinish()
    func goToMainTabBar()
    func didDisAppear()
}

final class SplashViewModel :SplachViewModelType {
   
    
   
    weak var coordinator:SplashCoordinator?
    
     init(coordinator: SplashCoordinator? = nil) {
        self.coordinator = coordinator
    }
    
    let animationCompleted: CurrentValueSubject<Bool, Never> = CurrentValueSubject<Bool, Never>(false)

    func animationDidFinish() {
        animationCompleted.send(true)
    }
    
    func goToMainTabBar(){
        coordinator?.startMainTabBarCoordinator()
    }
    
    func didDisAppear(){
        coordinator?.didDisAppear()
    }
}
