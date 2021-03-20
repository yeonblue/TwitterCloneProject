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
    
    func uploadTweet(caption: String, type: UploadTweetConfiguration, completion:@escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values:[String: Any] = ["uid": uid,
                                    "timestamp": Int(Date().timeIntervalSince1970),
                                    "likes": 0,
                                    "retweets": 0,
                                    "caption": caption]
        
        switch type {
        case .tweet:
            let ref = REF_TWEETS.childByAutoId()
            
            REF_TWEETS.childByAutoId().updateChildValues(values) { (err, reference) in
                // tweet update 이후 user-tweet에 해당 유저가 작성한 twwet 목록 update
                guard let twwetID = ref.key else { return }
                REF_USER_TWEET.child(uid).updateChildValues([twwetID: 1],
                                                            withCompletionBlock: completion)
            }
        case .reply(let tweet):
            REF_TWEET_REPLIES.child(tweet.tweetID).childByAutoId().updateChildValues(values,
                                                                                     withCompletionBlock: completion)
        }
    }
    
    func fetchTweets(completion: @escaping(([Tweet]) -> Void)) {
        var tweets = [Tweet]()
        
        // .childAdded 자식이 추가된 그 노드를 끌고 옴. (데이터를 추가하고 fetch를 바로 하기 때문에 사용 가능)
        REF_TWEETS.observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchTweets(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        REF_USER_TWEET.child(user.uid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key

            REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }

                UserService.shared.fetchUser(uid: uid) { user in
                    let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
        }
    }
    
    func fetchReplies(forTweet tweet: Tweet, completion: @escaping ([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        REF_TWEET_REPLIES.child(tweet.tweetID).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            let tweetID = snapshot.key

            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
            
            
         }
    }
    
}
