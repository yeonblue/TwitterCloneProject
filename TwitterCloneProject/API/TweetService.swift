//
//  TweetService.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/09.
//

import Foundation
import Firebase

struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(caption: String, completion:@escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values:[String: Any] = ["uid": uid,
                                    "timestamp": Int(Date().timeIntervalSince1970),
                                    "likes": 0,
                                    "retweets": 0,
                                    "caption": caption]
        REF_TWEETS.childByAutoId().onDisconnectUpdateChildValues(values,
                                                                 withCompletionBlock: completion)
    }
}
