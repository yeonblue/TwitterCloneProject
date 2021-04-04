//
//  UploadTweetController.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/08.
//

import UIKit
import ActiveLabel

enum UploadTweetConfiguration {
    case tweet
    case reply(Tweet)
}

class UploadTweetController: UIViewController {
    
    // MARK: - Properties
    private let user: User
    private let config: UploadTweetConfiguration
    private lazy var viewModel = UploadTweetViewModel(config: config)
    
    // 네비게이션 바에 버튼이 추가되고 addTarget이 불려져야 하므로 let이 아닌 lazy var로 선언 필요
    // 따라서 버튼 생성이 필요한 그 때 호출
    private lazy var tweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = button.frame.height / 2
        button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var replyLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.mentionColor = .twitterBlue
        return label
    }()
    
    private let captionTextView = InputTextView()
    
    // MARK: - LifeCycle
    init(user: User, config: UploadTweetConfiguration) {
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureMentionHandler()
    }
    
    // MARK: - Selectors
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleUploadTweet() {
        guard let caption = captionTextView.text else { return }
        TweetService.shared.uploadTweet(caption: caption, type: config) { (error, ref) in
            if let error = error {
                print("DEBUG: Tweet Upload Failed with \(error.localizedDescription)")
                return
            }
            
            if case .reply(let tweet) = self.config {
                NotificationService.shared.uploadNotification(type: .reply, tweet: tweet)
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - API
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()

        let imageCaptionStackView = UIStackView(arrangedSubviews: [profileImageView,
                                                                   captionTextView])
        imageCaptionStackView.axis = .horizontal
        imageCaptionStackView.spacing = 12
        
        // 이미지뷰, 텍스트뷰 각각 크기 조절 가능. 각각 정해진 크기를 가질 수 있음
        imageCaptionStackView.alignment = .leading
        
        let stackView = UIStackView(arrangedSubviews: [replyLabel,
                                                       imageCaptionStackView])
        stackView.axis = .vertical
        stackView.spacing = 12
        view.addSubview(stackView)
        
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 16,
                         paddingLeft: 16,
                         paddingRight: 16)

        profileImageView.sd_setImage(with: user.profileImageURL, completed: nil)
        
        tweetButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        captionTextView.placeholderLabel.text = viewModel.placeholderText
        replyLabel.isHidden = !viewModel.shouldShowReplyLabel
        
        guard let replyText = viewModel.replyText else { return }
        replyLabel.text = replyText
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: tweetButton)
    }
    
    func configureMentionHandler() {
        replyLabel.handleMentionTap { mention in
            print(mention)
        }
    }
}

