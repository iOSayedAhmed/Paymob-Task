//
//  MainTabBarController.swift
//  Paymob-Task
//
//  Created by iOSAYed on 06/07/2024.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setuptabBarAppearance()
        view.backgroundColor = .white
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        changeTabBarHeight()
        // Move the tabBar up by 10 points
        tabBar.frame = CGRect(x: tabBar.frame.origin.x + 10, y: tabBar.frame.origin.y - 10, width: tabBar.frame.width - 20, height: tabBar.frame.height - 10)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        simpleAnimmationWhenSelectItem(item)
    }
    
    
    //MARK: - Methods
    
    private func setuptabBarAppearance(){
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.tabBarBackground
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
            tabBar.layer.masksToBounds = true
            tabBar.layer.cornerRadius = tabBar.frame.height / 1.7
            tabBar.barTintColor = .black
            tabBar.backgroundColor = .black
            tabBar.tintColor = .systemRed
            tabBar.unselectedItemTintColor = .white
            tabBar.isTranslucent = false
            tabBar.layer.borderWidth = 0.8
            tabBar.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
            tabBar.layer.shadowColor = UIColor.white.withAlphaComponent(0.7).cgColor
            tabBar.layer.shadowOffset = CGSize(width: 2, height: 2)
            tabBar.layer.shadowOpacity = 0.3
        }
        
    }
    
    
    private func changeTabBarHeight(){
        let screenHeight = UIScreen.main.bounds.height
        var tabBarHeight = screenHeight * 0.1
        if UIDevice().userInterfaceIdiom == .phone {
            var tabFrame           = tabBar.frame
            tabFrame.size.height   = tabBarHeight
            tabFrame.origin.y      = view.frame.size.height - tabBarHeight
            tabBar.frame           = tabFrame
        }else if UIDevice().userInterfaceIdiom == .pad {
            tabBarHeight = screenHeight * 0.07
            var tabFrame           = tabBar.frame
            tabFrame.size.height   = tabBarHeight
            tabFrame.origin.y      = view.frame.size.height - tabBarHeight
            tabBar.frame           = tabFrame
        }
    }
    
    private  func simpleAnimmationWhenSelectItem(_ item:UITabBarItem){
        guard let barItemView = item.value(forKey: "view") as? UIView else {return}
        
        let timeInterval:TimeInterval = 0.4
        let propertyAnimator = UIViewPropertyAnimator(duration: timeInterval, dampingRatio: 0.5) {
            barItemView.transform = CGAffineTransform.identity.scaledBy(x: 1.4, y: 1.4)
        }
        
        propertyAnimator.addAnimations({ barItemView.transform = .identity}, delayFactor: CGFloat(timeInterval))
        propertyAnimator.startAnimation()
    }
}

