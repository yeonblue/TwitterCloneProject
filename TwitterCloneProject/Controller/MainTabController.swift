//
//  MainTabController.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/04.
//

import UIKit

class MainTabController: UITabBarController {

    // MARK: - Properties
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        return button
    }()
    
    // Mark: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewcControllers()
        configureUI()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.addSubview(actionButton)
        
//        actionButton.translatesAutoresizingMaskIntoConstraints = false
//        actionButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
//        actionButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
//        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -64).isActive = true
//        actionButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        
        
        actionButton.layer.cornerRadius = 56 / 2
    }
    
    func configureViewcControllers() {
        let feedVC = FeedController()
        let exploreVC = ExploreController()
        let notificationsVC = NotificationController()
        let conversationVC = ConversationController()
        
        let navi1 = makeNavigationController(image: UIImage(named: "home_unselected"), rootViewController: feedVC)
        let navi2 = makeNavigationController(image: UIImage(named: "search_unselected"), rootViewController: exploreVC)
        let navi3 = makeNavigationController(image: UIImage(named: "like_unselected"), rootViewController: notificationsVC)
        let navi4 = makeNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: conversationVC)
        
        viewControllers = [navi1, navi2, navi3, navi4]
    }
    
    func makeNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        
        let naviVC = UINavigationController(rootViewController: rootViewController)
        naviVC.tabBarItem.image = image
        naviVC.navigationBar.tintColor = .white
        return naviVC
    }
}
