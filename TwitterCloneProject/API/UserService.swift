//
//  UserService.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/08.
//

import Foundation
import Firebase

struct UserService {
    static let shared = UserService()
    
    /// 현재 로그인 중인 유저의 uid 정보를 얻어 유저정보를 가져옴
    func fetchUser(completion: @escaping(User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
}
