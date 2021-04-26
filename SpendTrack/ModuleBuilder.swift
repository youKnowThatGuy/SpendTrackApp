//
//  ModuleBuilder.swift
//  SpendTrack
//
//  Created by Клим on 22.02.2021.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createMainModule() -> UIViewController
    func createSearchModule() -> UIViewController
}


class ModuleBuilder: AssemblyBuilderProtocol{
    func createMainModule() -> UIViewController {
        let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainVC") as MainViewController
        
        let navVC = UINavigationController(rootViewController: mainVC)
        let presenter = MainPresenter(view: mainVC)
        mainVC.presenter = presenter
        return navVC
    }
    
    func createSearchModule() -> UIViewController {
        let searchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SearchVC") as SearchTableViewController
        
        let navVC = UINavigationController(rootViewController: searchVC)
        let presenter = SearchPresenter(view: searchVC)
        searchVC.presenter = presenter
        return navVC
    }
}
