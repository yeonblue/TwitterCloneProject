//
//  NotificaitonService.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/23.
//

import Firebase

struct NotificationService {
    static let shared = NotificationService()
    
    func uploadNotification(type: NotificationType,
                            tweet: Tweet? = nil,
                            user: User? = nil)
    {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values: [String: Any] = ["timestamp": Int(Date().timeIntervalSince1970),
                                     "uid"      : uid,
                                     "type"     : type.rawValue]
        
        if let tweet = tweet {
            values["tweetID"] = tweet.tweetID
            REF_NOTIFICATION.child(tweet.user.uid).childByAutoId().updateChildValues(values)
        }
        else if let user = user {
            REF_NOTIFICATION.child(user.uid).childByAutoId().updateChildValues(values)
        }
    }
    
    func fetchNotifications(completion: @escaping ([Notification]) -> Void) {
        var notifications = [Notification]()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_NOTIFICATION.child(uid).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                let notication = Notification(user: user, dictionary: dictionary)
                notifications.append(notication)
                completion(notifications)
            }
        }
    }
}

