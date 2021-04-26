//
//  MainTabBarViewController.swift
//  SpendTrack
//
//  Created by Клим on 24.04.2021.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    private let mod = ModuleBuilder()

    override func viewDidLoad() {
        super.viewDidLoad()
        let item1 = UITabBarItem()
        item1.image = UIImage(systemName: "house.fill")
        item1.title = "Главная"
        let mainVC = mod.createMainModule()
        mainVC.tabBarItem = item1
        
        let item2 = UITabBarItem()
        item2.image = UIImage(systemName: "magnifyingglass")
        item2.title = "Поиск товаров"
        let searchVC = mod.createSearchModule()
        searchVC.tabBarItem = item2
        self.viewControllers = [mainVC, searchVC]
    }

}
