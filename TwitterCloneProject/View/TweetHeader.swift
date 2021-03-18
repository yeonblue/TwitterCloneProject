//
//  TweetHeader.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/18.
//

import UIKit

class TweetHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
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
    
    private lazy var retweetsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "1 Retweets"
        return label
    }()
    
    private lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "2 Likes"
        return label
    }()
    
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
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let labelStackView = UIStackView(arrangedSubviews: [fullnameLabel,
                                                            usernameLabel])
        
        labelStackView.axis = .vertical
        labelStackView.spacing = -5
        
        let stackView = UIStackView(arrangedSubviews: [profileImageView,
                                                       labelStackView])
        stackView.spacing = 12
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor,
                         left: leftAnchor,
                         paddingTop: 16, paddingLeft: 16)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: stackView.bottomAnchor,
                            left: leftAnchor,
                            right: rightAnchor,
                            paddingTop: 20,
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
                         paddingTop: 20, height: 40)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selector
    
    @objc func handleProfileImageTapped() {
        
    }
    
    @objc func showActionSheet() {
        
    }
}
