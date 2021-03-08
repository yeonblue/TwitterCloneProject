//
//  User.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/08.
//

import Foundation

struct User {
    let fullname: String
    let email: String
    let username: String
    var profileImageURL: URL?
    let uid: String
    
    init(uid:String, dictionary: [String: AnyObject]) {
        self.uid = uid
        
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        
        guard let profileImageURL = dictionary["profileImageURL"] as? String else { return }
        guard let URL = URL(string: profileImageURL) else { return }
        self.profileImageURL = URL
    }
}
