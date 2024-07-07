//
//  ds.swift
//  Paymob-TaskTests
//
//  Created by iOSAYed on 07/07/2024.
//

import Combine
import XCTest
@testable import Paymob_Task

class SplashViewModelTests: XCTestCase {
    var viewModel: SplashViewModel!
    var mockCoordinator: MockSplashCoordinator!
    
    override func setUp() {
        super.setUp()
        mockCoordinator = MockSplashCoordinator(navigationController: UINavigationController())
        viewModel = SplashViewModel(coordinator: mockCoordinator)
    }
    
    func testAnimationDidFinish() {
        let expectation = XCTestExpectation(description: "Animation should complete")
        var subscription: AnyCancellable?
        
        subscription = viewModel.animationCompleted.sink { completed in
            if completed {
                expectation.fulfill()
            }
        }
        
        viewModel.animationDidFinish()
        
        wait(for: [expectation], timeout: 1.0)
        subscription?.cancel()
    }
    
    func testGoToMainTabBar() {
        viewModel.goToMainTabBar()
        
        XCTAssertTrue(mockCoordinator.didStartMainTabBarCoordinator)
    }
    
    func testDidDisAppear() {
        viewModel.didDisAppear()
        
        XCTAssertTrue(mockCoordinator.didDisappearCalled)
    }
}
