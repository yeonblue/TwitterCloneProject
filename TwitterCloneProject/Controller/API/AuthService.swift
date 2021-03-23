//
//  AuthService.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/07.
//

import Firebase
import UIKit

struct AuthUserInfo {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    func userLogin(email: String, password: String, completeion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email,
                           password: password,
                           completion: completeion)
    }
    
    func registerUser(userInfo: AuthUserInfo, completion: @escaping(Error?, DatabaseReference) -> Void) {
        
        let email = userInfo.email
        let password = userInfo.password
        let fullname = userInfo.fullname
        let username = userInfo.username
        let profileImage = userInfo.profileImage.jpegData(compressionQuality: 0.3)
        
        let profileImageName = UUID().uuidString
        let storageREF = STORAGE_PROFILE_IMAGES.child(profileImageName)
        
        storageREF.putData(profileImage!, metadata: nil) { (meta, error) in
            storageREF.downloadURL { (url, error) in
                guard let profileImageURL = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    guard let uid = result?.user.uid else { return }
                    
                    let values = ["email": email,
                                  "fullname": fullname,
                                  "username": username,
                                  "profileImageURL": profileImageURL]
                    
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                }
            }
        }
    }
}
