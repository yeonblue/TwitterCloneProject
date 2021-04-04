//
//  MainTabController.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/04.
//

import UIKit
import Firebase

enum ActionButtonConfigureation {
    case tweet
    case message
}

class MainTabController: UITabBarController {

    // MARK: - Properties
    
    private var buttonConfig: ActionButtonConfigureation = .tweet
    
    var user: User?{
        didSet{
            
            // UserProfileImage가 업데이트 되면 FeedController로 User정보 전달
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let feed = nav.viewControllers.first as? FeedController else { return }
            feed.user = user
        }
    }
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .twitterBlue
        checkUserisLoginAndConfigureUI()
    }
    
    // MARK: - Selectors
    @objc func actionButtonTapped() {
        let controller: UIViewController
        
        switch buttonConfig {
        case .tweet:
            guard let user = user else { return }
            controller = UploadTweetController(user: user,
                                               config: .tweet)
        case .message:
            controller = SearchController(config: .messages)
        }

        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    // MARK: - API
    func checkUserisLoginAndConfigureUI() {
        if Auth.auth().currentUser == nil { // not LogIn
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginViewController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
        else {
            configureViewcControllers()
            configureUI()
            fetchUser()
        }
    }

    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { (user) in
            self.user = user
        }
    }
    // MARK: - Helpers
    
    func configureUI() {
        self.delegate = self
        view.addSubview(actionButton)
        
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            right: view.safeAreaLayoutGuide.rightAnchor,
                            paddingBottom: 64, paddingRight: 16,
                            width: 56, height: 56)
        
        actionButton.layer.cornerRadius = 56 / 2
    }
    
    func configureViewcControllers() {
        let feedVC = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let exploreVC = SearchController(config: .userSearch)
        let notificationsVC = NotificationController()
        let conversationVC = ConversationController()
        
        let navi1 = makeNavigationController(image: UIImage(named: "home_unselected"),
                                             rootViewController: feedVC)
        let navi2 = makeNavigationController(image: UIImage(named: "search_unselected"),
                                             rootViewController: exploreVC)
        let navi3 = makeNavigationController(image: UIImage(named: "like_unselected"),
                                             rootViewController: notificationsVC)
        let navi4 = makeNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"),
                                             rootViewController: conversationVC)
        
        viewControllers = [navi1, navi2, navi3, navi4]
    }
    
    func makeNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        
        let naviVC = UINavigationController(rootViewController: rootViewController)
        naviVC.tabBarItem.image = image
        naviVC.navigationBar.tintColor = .white
        return naviVC
    }
}

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let index = viewControllers?.firstIndex(of: viewController)
        
        let image = index == 3 ? #imageLiteral(resourceName: "mail") : #imageLiteral(resourceName: "new_tweet")
        self.actionButton.setImage(image, for: .normal)
        
        buttonConfig = index == 3 ? .message : .tweet
    }
}
