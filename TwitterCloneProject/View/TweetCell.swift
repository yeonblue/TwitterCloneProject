//
//  TweetCellCollectionViewCell.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/10.
//

import UIKit

protocol TweetCellDelegate: class {
    func handleProfileImageTapped(_ cell: TweetCell)
    func handleReplyTapped(_ cell: TweetCell)
    func handleLikeTapped(_ cell: TweetCell)
}

class TweetCell: UICollectionViewCell {
    
    // MARK: - Properties
    var tweet: Tweet? {
        didSet{
            configure()
        }
    }
    
    weak var delegate: TweetCellDelegate?
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(handleProfileImageTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        
        return iv
    }()
    
    private let captionLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "Label Test Text"
        return label
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "retweet"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "share"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return button
    }()
    
    private let infoLabel = UILabel()
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor,
                                left: leftAnchor,
                                paddingTop: 8,
                                paddingLeft: 8)
        
        let stackView = UIStackView(arrangedSubviews: [infoLabel,
                                                       captionLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        addSubview(stackView)
        stackView.anchor(top: profileImageView.topAnchor,
                         left: profileImageView.rightAnchor,
                         right: rightAnchor,
                         paddingLeft: 12, paddingRight: 12)
        
        infoLabel.text = "infoLabel Dummy Data"
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        
        
        let actionStackView = UIStackView(arrangedSubviews: [commentButton,
                                                             retweetButton,
                                                             likeButton,
                                                             shareButton])
        
        actionStackView.axis = .horizontal
        actionStackView.spacing = 70
        addSubview(actionStackView)
        actionStackView.anchor(bottom: bottomAnchor,
                               paddingBottom: 8)
        actionStackView.centerX(inView: self)
        
        let underlineView = UIView()
        underlineView.backgroundColor = .systemGroupedBackground
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor,
                             bottom: bottomAnchor,
                             right: rightAnchor,
                             paddingLeft: 3, paddingRight: 3,
                             height: 1)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc func handleCommentTapped() {
        delegate?.handleReplyTapped(self)
    }
    
    @objc func handleRetweetTapped() {
        
    }
    
    @objc func handleLikeTapped() {
        delegate?.handleLikeTapped(self)
    }
    
    @objc func handleShareTapped() {
        
    }
    
    @objc func handleProfileImageTapped() {
        delegate?.handleProfileImageTapped(self)
    }
    
    // MARK: = Helpers
    func configure() {
        guard let tweet = tweet else { return }
        let viewModel = TweetViewModel(tweet: tweet)
        
        captionLabel.text = tweet.caption
        infoLabel.attributedText = viewModel.userInfoText
        profileImageView.sd_setImage(with: viewModel.profileImageURL, completed: nil)
        
        likeButton.tintColor = viewModel.likeButtonTintColor
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        
        
    }
}
