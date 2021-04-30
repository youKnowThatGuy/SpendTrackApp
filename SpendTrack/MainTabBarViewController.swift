//
//  MainTabBarViewController.swift
//  SpendTrack
//
//  Created by Клим on 24.04.2021.
//

import UIKit
import RAMAnimatedTabBarController

class MainTabBarViewController: RAMAnimatedTabBarController {
    
    private let mod = ModuleBuilder()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .systemYellow
        let item1 = RAMAnimatedTabBarItem()
        item1.image = UIImage(systemName: "house.fill")
        item1.title = "Главная"
        let mainVC = mod.createMainModule()
        mainVC.tabBarItem = item1
        (mainVC.tabBarItem as? RAMAnimatedTabBarItem)?.animation = RAMRotationAnimation()
        
        let item2 = RAMAnimatedTabBarItem()
        item2.image = UIImage(systemName: "magnifyingglass")
        item2.title = "Поиск товаров"
        let searchVC = mod.createSearchModule()
        searchVC.tabBarItem = item2
        (searchVC.tabBarItem as? RAMAnimatedTabBarItem)?.animation = RAMRotationAnimation()
        self.viewControllers = [mainVC, searchVC]
    }

}
