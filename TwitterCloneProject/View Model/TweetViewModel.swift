//
//  TweetViewModel.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/13.
//

import UIKit

struct TweetViewModel {
    
    // MARK: - Properties
    
    let tweet: Tweet
    let user: User
    
    var profileImageURL: URL? {
        return tweet.user.profileImageURL
    }
        
    var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, . hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        
        let now = Date()
        return formatter.string(from: tweet.timestamp, to: now) ?? "0s"
    }
    
    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullname,
                                              attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        title.append(NSAttributedString(string: " @\(user.username)",
                                        attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                     .foregroundColor: UIColor.lightGray]))
        
        title.append(NSAttributedString(string: " · \(timestamp)",
                                        attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                     .foregroundColor: UIColor.lightGray]))
        return title 
    }
    
    var usernameText: String {
        return "@ \(user.username)"
    }
    
    var headerTimeStamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a - yyyy/MM/dd"
        
        return formatter.string(from: tweet.timestamp)
    }
    
    var retweetAttributedString: NSAttributedString {
        return makeAttributedText(value: tweet.retweetCount, text: " Retweets")
    }
    
    var likesAttributedString: NSAttributedString {
        return makeAttributedText(value: tweet.likes, text: " Likes")
    }
    
    var likeButtonTintColor: UIColor {
        return tweet.didLike ? .red : .lightGray
    }
    
    var likeButtonImage: UIImage {
        let imageName = tweet.didLike ? "like_filled" : "like"
        return UIImage(named: imageName)!
    }
    
    var shouldHideReplyLabel: Bool {
        return !tweet.isReply
    }
    
    var replyText: String? {
        guard let replyingToUsername = tweet.replyingTo else { return nil }
        return "→ replying to @\(replyingToUsername)"
    }
    
    // MARK: - Lifecycle
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
    
    // MARK: - Helpers
    
    fileprivate func makeAttributedText(value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)",
                                                        attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        
        attributedTitle.append(NSAttributedString(string: " \(text)",
                                                  attributes: [.font:            UIFont.systemFont(ofSize: 14),
                                                               .foregroundColor: UIColor.lightGray]))
        
        return attributedTitle
    }
    
    func size(forwidth width: CGFloat) -> CGSize {
        
        let measureLabel = UILabel()
        measureLabel.text = tweet.caption
        measureLabel.numberOfLines = 0
        measureLabel.lineBreakMode = .byWordWrapping
        measureLabel.translatesAutoresizingMaskIntoConstraints = false
        measureLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        return measureLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
