//
//  d.swift
//  Paymob-TaskTests
//
//  Created by iOSAYed on 07/07/2024.
//

import Foundation
import Combine
import XCTest
@testable import Paymob_Task

class MockSplashCoordinator: SplashCoordinator {
    var didStartMainTabBarCoordinator = false
    var didDisappearCalled = false
    
    override func startMainTabBarCoordinator() {
        didStartMainTabBarCoordinator = true
    }
    
    override func didDisAppear() {
        didDisappearCalled = true
    }
}
