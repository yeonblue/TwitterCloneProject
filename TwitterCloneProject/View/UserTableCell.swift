//
//  UserTableCell.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/18.
//

import UIKit

class UserTableCell: UITableViewCell {
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            configure()
        }
    }
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 32, height: 32)
        iv.layer.cornerRadius = 32 / 2
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .twitterBlue
        
        return iv
    }()
    
    private let usernameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Username Text"
        return label
    }()
    
    private let fullnameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Fullname Text"
        return label
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self,
                                 leftAnchor: leftAnchor,
                                 paddingLeft: 12)
        
        let stackView = UIStackView(arrangedSubviews: [usernameLabel,
                                                       fullnameLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        addSubview(stackView)
        
        stackView.centerY(inView: self,
                          leftAnchor: profileImageView.rightAnchor,
                          paddingLeft: 12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let user = user else { return }
        
        profileImageView.sd_setImage(with: user.profileImageURL, completed: nil)
        
        usernameLabel.text = user.username
        fullnameLabel.text = user.fullname
    }
}
