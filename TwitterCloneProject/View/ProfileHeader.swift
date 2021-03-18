//
//  ProfileHeader.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/14.
//

import UIKit

protocol ProfileHeaderDelegate: class {
    func handleDismiss()
    func handleEditProfileFollow(_ header: ProfileHeader)
}

class ProfileHeader: UICollectionReusableView {
    
    // MARK: - Properties
    weak var delegate: ProfileHeaderDelegate?
    
    var user: User? {
        didSet {
            configure()
        }
    }
    private let filterBar = ProfileFilterView()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_white_24dp").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self,
                         action: #selector(handleDismissal),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor,
                          paddingTop: 40, paddingLeft: 16,
                          width: 30, height: 30)
    
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        return iv
    }()
    
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Test", for: .normal)
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self,
                         action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "fullname Label"
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "@username Label"
        label.textColor = .lightGray
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 3
        label.text = "bioLabel"
        
        return label
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        let followTap = UITapGestureRecognizer(target: self,
                                               action: #selector(handleFollowersTapped))
        label.addGestureRecognizer(followTap)
        label.isUserInteractionEnabled = true
        
        label.text = "0 following"
        return label
    }()
    
    private let followersLabel: UILabel = {
        let label = UILabel()
        let followTap = UITapGestureRecognizer(target: self,
                                               action: #selector(handleFollowingTapped))
        label.addGestureRecognizer(followTap)
        label.isUserInteractionEnabled = true
        label.text = "0 follwers"
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        filterBar.delegate = self
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor,
                             left: leftAnchor,
                             right: rightAnchor,
                             height: 100)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: containerView.bottomAnchor, left: leftAnchor,
                                paddingTop: -25, paddingLeft: 8,
                                width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: containerView.bottomAnchor, right: rightAnchor,
                                       paddingTop: 12, paddingRight: 16,
                                       width: 100, height: 36)
        editProfileFollowButton.layer.cornerRadius = 36 / 2
        
        let userinfoStackView = UIStackView(arrangedSubviews: [fullnameLabel,
                                                               usernameLabel,
                                                               bioLabel])
        
        userinfoStackView.axis = .vertical
        userinfoStackView.distribution = .fillProportionally
        userinfoStackView.spacing = 4
        
        addSubview(userinfoStackView)
        userinfoStackView.anchor(top: profileImageView.bottomAnchor,
                                 left: leftAnchor,
                                 right: rightAnchor,
                                 paddingTop: 8,
                                 paddingLeft: 12,
                                 paddingRight: 12)
        
        let followStackView = UIStackView(arrangedSubviews: [followingLabel,
                                                             followersLabel])
        
        addSubview(followStackView)
        followStackView.axis = .horizontal
        followStackView.spacing = 8
        followStackView.distribution = .fillEqually
        followStackView.anchor(top: userinfoStackView.bottomAnchor,
                               left: leftAnchor,
                               paddingTop: 8,
                               paddingLeft: 12)
        
        addSubview(filterBar)
        filterBar.anchor(left: leftAnchor,
                         bottom: bottomAnchor,
                         right: rightAnchor,
                         height: 50)
        
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor,
                             bottom: bottomAnchor,
                             width: frame.width / 3,
                             height: 2)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selector
    @objc func handleDismissal() {
        // 헤더 셀이라 dismiss 접근 불가. 프로토콜 사용
        delegate?.handleDismiss()
    }
    
    @objc func handleEditProfileFollow() {
        delegate?.handleEditProfileFollow(self)
    }
    
    @objc func handleFollowersTapped() {
        
    }
    
    @objc func handleFollowingTapped() {
        
    }
    
    // MARK: - Helpers
    func configure() {
        guard let user = user else { return }
        let viewModel = ProfileHeaderViewModel(user: user)
        profileImageView.sd_setImage(with: user.profileImageURL, completed: nil)
        
        followingLabel.attributedText = viewModel.followingString
        followersLabel.attributedText = viewModel.followersString
        
        editProfileFollowButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        
        fullnameLabel.text = user.fullname
        usernameLabel.text = viewModel.usernameText
    }
}

extension ProfileHeader: ProfileFilterViewDelegate {
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath) {
        guard let cell = view.collectionView.cellForItem(at: indexPath) as? ProfileFilterCell else { return }
        
        let xPosition = cell.frame.origin.x
        
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPosition
        }
    }
}
