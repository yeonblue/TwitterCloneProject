//
//  UploadTweetViewModel.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/20.
//

import UIKit

struct UploadTweetViewModel {
    
    let actionButtonTitle: String
    let placeholderText: String
    let shouldShowReplyLabel: Bool
    
    var replyText: String?
    
    init(config: UploadTweetConfiguration) {
        switch config {
        case .tweet:
            actionButtonTitle = "Tweet"
            placeholderText = "What's happening"
            shouldShowReplyLabel = false
        case .reply(let tweet):
            actionButtonTitle = "Reply"
            placeholderText = "Tweet your reply"
            shouldShowReplyLabel = true
            replyText = "Replying to @\(tweet.user.username)"
        }
    }
}
