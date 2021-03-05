//
//  LoginViewController.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/05.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Properties
    private let logoImageView: UIImageView = {
        let logo = UIImageView()
        logo.contentMode = .scaleAspectFit
        logo.clipsToBounds = true
        logo.image = #imageLiteral(resourceName: "TwitterLogo")
        return logo
    }()
    
    private lazy var emailContainerView: UIView = {
        let emailView = UIView()
        emailView.backgroundColor = .red
        emailView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let emailImage = UIImageView()
        emailView.addSubview(emailImage)
        
        emailImage.image = #imageLiteral(resourceName: "mail")
        emailImage.anchor(left: emailView.leftAnchor,
                          bottom: emailView.bottomAnchor,
                          paddingLeft: 8, paddingBottom: 8,
                          width: 24, height: 24)
        return emailView
    }()
    
    private lazy var passwordContainerView: UIView = {
        let passwordView = UIView()
        passwordView.backgroundColor = .green
        passwordView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let passwordImage = UIImageView()
        passwordView.addSubview(passwordImage)
        
        passwordImage.image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        passwordImage.anchor(left: passwordView.leftAnchor,
                             bottom: passwordView.bottomAnchor,
                             paddingLeft: 8, paddingBottom: 8,
                             width: 24, height: 24)
        return passwordView
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0)
        logoImageView.setDimensions(width: 150, height: 150)
        
        let stackView = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView])
        stackView.axis = .vertical
        stackView.spacing = 8
        
        view.addSubview(stackView)
        stackView.anchor(top: logoImageView.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingLeft: 16, paddingRight: 16)
    }
}
