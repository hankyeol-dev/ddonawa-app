//
//  TCMain.swift >> MainTabBarController.swift
//  ddonawa
//
//  Created by 강한결 on 6/15/24. >> 7/01/24.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        configureUI()
        
        let searchVC = UINavigationController(rootViewController: VCSearchingMain())
        let settingVC = UINavigationController(rootViewController: VCSettingMain())
        let likedProductVC = UINavigationController(rootViewController: VCLikedProductList())
        searchVC.tabBarItem = UITabBarItem(title: Texts.Buttons.TABBAR_0.rawValue, image: Icons._search, tag: 0)
        settingVC.tabBarItem = UITabBarItem(title: Texts.Buttons.TABBAR_1.rawValue, image: Icons._user, tag: 1)
        likedProductVC.tabBarItem = UITabBarItem(title: Texts.Buttons.TABBAR_2.rawValue, image: Icons._liked, tag: 2)
        
        setViewControllers([searchVC, settingVC, likedProductVC], animated: true)
    }
    
    private func configureUI() {
        tabBar.tintColor = ._main
        tabBar.unselectedItemTintColor = ._gray_sm
        tabBar.backgroundColor = .systemBackground
    }
}
