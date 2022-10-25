//
//  MainTabBarViewController.swift
//  Netflix_Clone
//
//  Created by Greg Ross on 25/10/2022.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.backgroundColor = .systemYellow
        
        configureTabBar()
        setViewControllers([configureHomeTab(), configureUpcomingTab(), configureSearchTab(), configureDownloadsTab()], animated: true)
    }
    
    // MARK: Home Tab
    private func configureHomeTab() -> UINavigationController{
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        
        vc1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        return vc1
    }
    
    // MARK: Upcoming Tab
    private func configureUpcomingTab() -> UINavigationController{
        let vc1 = UINavigationController(rootViewController: UpcomingViewController())
        
        vc1.tabBarItem = UITabBarItem(title: "Coming Soon", image: UIImage(systemName: "play.circle"), tag: 0)
        return vc1
    }
    
    // MARK: Search Tab
    private func configureSearchTab() -> UINavigationController{
        let vc1 = UINavigationController(rootViewController: SearchViewController())
        
        vc1.tabBarItem = UITabBarItem(title: "Top Search", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        return vc1
    }
    
    // MARK: Downloads Tab
    private func configureDownloadsTab() -> UINavigationController{
        let vc1 = UINavigationController(rootViewController: DownloadsViewController())
        
        vc1.tabBarItem = UITabBarItem(title: "Downloads", image: UIImage(systemName: "arrow.down.to.line"), tag: 0)
        return vc1
    }

    // MARK: Tab Bar
    private func configureTabBar(){
        tabBar.tintColor = .label
    }

}
