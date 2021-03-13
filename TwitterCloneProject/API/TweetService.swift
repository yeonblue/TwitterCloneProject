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
        REF_TWEETS.childByAutoId().updateChildValues(values,
                                                     withCompletionBlock: completion)
    }
    
    func fetchTweets(completion: @escaping(([Tweet]) -> Void)) {
        var tweets = [Tweet]()
        
        // .childAdded 자식이 추가된 그 노드를 끌고 옴. (데이터를 추가하고 fetch를 바로 하기 때문에 사용 가능)
        REF_TWEETS.observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { (user) in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
}
