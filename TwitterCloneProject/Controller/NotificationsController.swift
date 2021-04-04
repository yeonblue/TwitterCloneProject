//
//  NotificationsController.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/04.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationController: UITableViewController {
    
    // MARK: - Properties
    
    private var notifications = [Notification]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        fetchNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    // MARK: - Selector
    @objc func handleRefresh() {
        fetchNotifications()
    }
    
    // MARK: - API
    
    func fetchNotifications() {
        refreshControl?.beginRefreshing()
        
        NotificationService.shared.fetchNotifications { notifications in
            self.refreshControl?.endRefreshing()
            self.notifications = notifications
            self.checkIfUserIsFollowed(notifications)
        }
    }
    
    func checkIfUserIsFollowed(_ notifications: [Notification]) {
        
        guard !notifications.isEmpty else { return }
        
        notifications.forEach { notification in
            
            guard case .follow = notification.type else { return }
            let user = notification.user
            
            UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollow in
                if let index = self.notifications.firstIndex(where: { $0.user.uid == notification.user.uid }){
                    self.notifications[index].user.isFollowed = isFollow
                }
            }
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        let refreshController = UIRefreshControl()
        tableView.refreshControl = refreshController
        refreshControl?.addTarget(self,
                                  action: #selector(handleRefresh),
                                  for: .valueChanged)
    }
}

// MARK: - UITableViewDelegate/Datasource
extension NotificationController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                 for: indexPath) as! NotificationCell
        cell.notification = notifications[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notificaiton = notifications[indexPath.row]
        guard let tweetId = notificaiton.tweetID else { return }
        
        TweetService.shared.fetchTweet(withTweetId: tweetId) { tweet in
            let controller = TweetController(tweet: tweet)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }

}

// MARK: - NotificationCellDelegate
extension NotificationController: NotificationCellDelegate {
    func didTapFollow(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else { return }
        
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { _, _ in
                cell.notification?.user.isFollowed = false
            }
        }
        else {
            UserService.shared.followUser(uid: user.uid) { _, _  in
                cell.notification?.user.isFollowed = true
            }
        }
    }
    
    func didTapProfileImage(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else { return }
        
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
