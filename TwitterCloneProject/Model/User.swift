//
//  User.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/08.
//

import Foundation
import Firebase

struct User {
    var fullname: String
    let email: String
    var username: String
    var profileImageURL: URL?
    let uid: String
    var stats: UserRelationStats?
    var bio: String?
    
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    var isFollowed: Bool = false
    
    init(uid:String, dictionary: [String: AnyObject]) {
        self.uid = uid
        
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
        
        guard let profileImageURL = dictionary["profileImageURL"] as? String else { return }
        guard let URL = URL(string: profileImageURL) else { return }
        self.profileImageURL = URL
    }
}

struct UserRelationStats {
    var followers: Int
    var following: Int
}
