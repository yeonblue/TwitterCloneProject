//
//  ProfileViewHeaderViewModel.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/16.
//

import UIKit
import Firebase

enum ProfileFilterOption: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
            case .tweets: return "Tweets"
            case .replies: return "Tweets & Replies"
            case .likes: return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    private let user: User
    
    let usernameText: String
    
    var followersString: NSAttributedString? {
        return makeAttributedText(value: user.stats?.followers ?? 0, text: "followers")
    }
    
    var followingString: NSAttributedString? {
        return makeAttributedText(value: user.stats?.following ?? 0, text: "following")
    }
    
    var actionButtonTitle: String {
        // 만약 현재 유저라면 edit profile 버튼
        // 아니라면 following/not following 구분 로직
        
        if user.isCurrentUser {
            return "Edit Profile"
        }
        
        if !user.isFollowed && !user.isCurrentUser {
            return "Follow"
        }
        
        if user.isFollowed {
            return "Following"
        }
        
        return "Loading..."
    }
    
    init(user: User) {
        self.user = user
        self.usernameText = "@\(user.username)"
    }
    
    fileprivate func makeAttributedText(value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)",
                                                        attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        
        attributedTitle.append(NSAttributedString(string: " \(text)",
                                                  attributes: [.font:            UIFont.systemFont(ofSize: 14),
                                                               .foregroundColor: UIColor.lightGray]))
        
        return attributedTitle
    }
}
