//
//  Tweet.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/10.
//

import Foundation

struct Tweet {
    let caption: String
    let tweetID: String
    var likes: Int
    let retweetCount: Int
    var timestamp: Date!
    var user: User
    var didLike = false
    
    
    init(user:User, tweetID: String, dictionary: [String: Any]) {
        self.tweetID = tweetID
        self.user = user
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.retweetCount = dictionary["retweetCout"] as? Int ?? 0
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
    }
}
