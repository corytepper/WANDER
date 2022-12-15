//
//  TabBarVC.swift
//  WANDER
//
//  Created by Cory Tepper on 11/20/22.
//

import UIKit

class TabBarVC: UITabBarController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.unselectedItemTintColor = .white
        tabBar.tintColor = .red
        
        setupViewControllers()
    }

    
    private func setupViewControllers() {
        viewControllers = [
            createViewControllers(for: HomeVC(), title: "WANDER NOW", systemImage: "figure.walk"),
            createViewControllers(for: HistoryVC(), title: "PAST WANDERS", systemImage: "calendar")
            ]
    }

    private func createViewControllers(for viewController: UIViewController, title: String, systemImage: String) -> UIViewController {
        let iconSymbol = UIImage(systemName: systemImage)
        let selectedSymbol = UIImage(systemName: systemImage, withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        let tabBarItem = UITabBarItem(title: title, image: iconSymbol, selectedImage: selectedSymbol)
        viewController.tabBarItem = tabBarItem
        return viewController
    }
    
    
}


