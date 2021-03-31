//
//  TweetHeader.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/18.
//

import UIKit

protocol TweetHeaderDelegate: class {
    func showActionSheet()
}

class TweetHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    weak var delegate: TweetHeaderDelegate?
    
    var tweet: Tweet? {
        didSet {
            configure()
        }
    }
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(handleProfileImageTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        
        return iv
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "fullname Label"
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "@username Label"
        label.textColor = .lightGray
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.text = "Dummy Data"
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "9:30 PM - 2021/03/18"
        label.textAlignment = .left
        return label
    }()
    
    private lazy var optionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return button
    }()
    
    private let replyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var retweetsLabel = UILabel()
    private lazy var likesLabel = UILabel()
    
    private lazy var statsView: UIView = {
        let view = UIView()
        
        let updivider = UIView()
        let downdivier = UIView()
        
        updivider.backgroundColor = .systemGroupedBackground
        view.addSubview(updivider)
        updivider.anchor(top: view.topAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingLeft: 8, paddingRight: 8, height: 1)
        
        let stackView = UIStackView(arrangedSubviews: [retweetsLabel,
                                                       likesLabel])
        
        stackView.axis = .horizontal
        stackView.spacing = 12
        
        view.addSubview(stackView)
        stackView.centerY(inView: view)
        stackView.anchor(left: view.leftAnchor, paddingLeft: 16)
        
        downdivier.backgroundColor = .systemGroupedBackground
        view.addSubview(downdivier)
        downdivier.anchor(left: view.leftAnchor,
                          bottom: view.bottomAnchor,
                          right: view.rightAnchor,
                          paddingLeft: 8, paddingRight: 8, height: 1)
        
        return view
    }()
    
    private lazy var commentButton: UIButton = {
        let button = createButton(withImageName: "comment")
        button.addTarget(self,
                         action: #selector(handleCommentTapped),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = createButton(withImageName: "retweet")
        button.addTarget(self,
                         action: #selector(handleRetweetTapped),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = createButton(withImageName: "like")
        button.addTarget(self,
                         action: #selector(handleLikeTapped),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = createButton(withImageName: "share")
        button.addTarget(self,
                         action: #selector(handleShareTapped),
                         for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let labelStackView = UIStackView(arrangedSubviews: [fullnameLabel,
                                                            usernameLabel])
        
        labelStackView.axis = .vertical
        labelStackView.spacing = -5
        
        let imageCaptionStackView = UIStackView(arrangedSubviews: [profileImageView,
                                                       labelStackView])
        imageCaptionStackView.spacing = 12
        
        let stackView = UIStackView(arrangedSubviews: [replyLabel,
                                                       imageCaptionStackView])
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor,
                         left: leftAnchor,
                         paddingTop: 16, paddingLeft: 16)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: stackView.bottomAnchor,
                            left: leftAnchor,
                            right: rightAnchor,
                            paddingTop: 12,
                            paddingLeft: 16,
                            paddingRight: 16)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: captionLabel.bottomAnchor,
                         left: leftAnchor,
                         paddingTop: 20,
                         paddingLeft: 16)
        
        addSubview(optionButton)
        optionButton.centerY(inView: stackView)
        optionButton.anchor(right: rightAnchor, paddingRight: 8)
        
        addSubview(statsView)
        statsView.anchor(top: dateLabel.bottomAnchor,
                         left: leftAnchor,
                         right: rightAnchor,
                         paddingTop: 12, height: 40)
        
        let actionStackView = UIStackView(arrangedSubviews: [commentButton,
                                                             retweetButton,
                                                             likeButton,
                                                             shareButton])
        actionStackView.axis = .horizontal
        actionStackView.spacing = 70
        actionStackView.distribution = .fillEqually
        
        addSubview(actionStackView)
        actionStackView.centerX(inView: self)
        actionStackView.anchor(top: statsView.bottomAnchor, paddingTop: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selector
    
    @objc func handleProfileImageTapped() {
        
    }
    
    @objc func showActionSheet() {
        delegate?.showActionSheet()
    }

    @objc func handleCommentTapped() {
        
    }
    
    @objc func handleRetweetTapped() {
        
    }
    
    @objc func handleLikeTapped() {
        
    }
    
    @objc func handleShareTapped() {
        
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let tweet = tweet else { return }
        
        let viewModel = TweetViewModel(tweet: tweet)
        
        captionLabel.text = tweet.caption
        fullnameLabel.text = tweet.user.fullname
        usernameLabel.text = viewModel.usernameText
        profileImageView.sd_setImage(with: viewModel.profileImageURL, completed: nil)
        dateLabel.text = viewModel.headerTimeStamp
        
        retweetsLabel.attributedText = viewModel.retweetAttributedString
        likesLabel.attributedText = viewModel.likesAttributedString
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        likeButton.tintColor = viewModel.likeButtonTintColor
        
        replyLabel.isHidden = viewModel.shouldHideReplyLabel
        replyLabel.text = viewModel.replyText
    }
    
    func createButton(withImageName imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .gray
        button.setDimensions(width: 20, height: 20)
        
        return button
    }
}
