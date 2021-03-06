//
//  UserService.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/08.
//

import Foundation
import Firebase

typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

struct UserService {
    static let shared = UserService()
    
    /// 현재 로그인 중인 유저의 uid 정보를 얻어 유저정보를 가져옴
    func fetchUser(uid: String, completion: @escaping(User) -> Void) {
        //guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        REF_USERS.observe(.childAdded) { snapshot in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: dictionary)
            users.append(user)
            completion(users)
        }
    }
    
    func followUser(uid: String, completion: @escaping DatabaseCompletion) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).updateChildValues([uid: 1]) { err, ref in
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUid: 1],
                                                            withCompletionBlock: completion)
        }
        
    }
    
    func unfollowUser(uid: String, completion: @escaping DatabaseCompletion) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).removeValue { err, ref in
            REF_USER_FOLLOWERS.child(uid).child(currentUid).removeValue(completionBlock: completion)
        }
    }
    
    func checkIfUserIsFollowed(uid: String, completion: @escaping (Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
    func fetchUserStats(uid: String, completion: @escaping (UserRelationStats) -> Void) {
        REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            let followers = snapshot.children.allObjects.count
            
            REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { snapshot in
                let following = snapshot.children.allObjects.count
                
                let stats = UserRelationStats(followers: followers,
                                             following: following)
                
                completion(stats)
            }
        }
    }
    
    func updateProfileImage(image: UIImage, completion: @escaping (URL?) -> ()) {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let filename = UUID().uuidString
        let ref = STORAGE_PROFILE_IMAGES.child(filename)
        
        ref.putData(imageData, metadata: nil) { meta, err in
            ref.downloadURL { url, err in
                guard let profileImageURL = url?.absoluteString else { return }
                let values = ["profileImageURL": profileImageURL]
                
                REF_USERS.child(uid).updateChildValues(values) { err, ref in
                    completion(url)
                }
            }
        }
    }
    
    func saveUserDate(user: User, completion: @escaping (DatabaseCompletion) ) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["fullname": user.fullname,
                      "username": user.username,
                      "bio": user.bio ?? ""]
        REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
    }
    
    func fetchUser(withUserName username: String, completion: @escaping (User) -> Void) {
        REF_USER_USERNAMES.child(username).observeSingleEvent(of: .value) { snapshot in
            guard let uid = snapshot.value as? String else { return }
            
            self.fetchUser(uid: uid, completion: completion)
        }
    }
}
