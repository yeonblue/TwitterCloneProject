//
//  NotificationCell.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/24.
//

import UIKit

protocol NotificationCellDelegate: class {
    func didTapProfileImage(_ cell: NotificationCell)
}

class NotificationCell: UITableViewCell {
    
    // MARK: - Properties
    
    var notification: Notification? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: NotificationCellDelegate?
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 40, height: 40)
        iv.layer.cornerRadius = 40 / 2
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        iv.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(handleProfileImageTapped))

        iv.addGestureRecognizer(tap)
        
        return iv
    }()
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Notification Test Message"
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = UIStackView(arrangedSubviews: [profileImageView,
                                                       notificationLabel])
        
        stackView.spacing = 8
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.centerY(inView: self,
                          leftAnchor: leftAnchor,
                          paddingLeft: 12)
        
        stackView.anchor(right: rightAnchor, paddingRight: 12)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selector
    
    @objc func handleProfileImageTapped() {
        delegate?.didTapProfileImage(self)
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let notification = notification else { return }
        
        let viewmodel = NotificationViewModel(notification: notification)
        profileImageView.sd_setImage(with: viewmodel.profileImageURL, completed: nil)
        notificationLabel.attributedText = viewmodel.notificationText
    }
}
