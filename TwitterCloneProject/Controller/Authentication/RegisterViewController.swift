//
//  RegisterViewController.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/05.
//

import UIKit

class RegisterViewController: UIViewController {

    // MARK: - Properties
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(plusPhotoButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        let emailView = Utilites().inputContainerView(withImage: image, textField: emailTextField)
        return emailView
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        let passwordView = Utilites().inputContainerView(withImage: image, textField: passwordTextField)
        return passwordView
    }()
    
    private lazy var fullNameContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        let emailView = Utilites().inputContainerView(withImage: image, textField: fullNameTextField)
        return emailView
    }()
    
    private lazy var userNameContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        let passwordView = Utilites().inputContainerView(withImage: image, textField: userNameTextField)
        return passwordView
    }()
    
    private let emailTextField: UITextField = {
        let tf = Utilites().makeTwitterTextField(withPlaceHolder: "Email")
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Utilites().makeTwitterTextField(withPlaceHolder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let fullNameTextField: UITextField = {
        let tf = Utilites().makeTwitterTextField(withPlaceHolder: "Full Name")
        return tf
    }()
    
    private let userNameTextField: UITextField = {
        let tf = Utilites().makeTwitterTextField(withPlaceHolder: "Username")
        return tf
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        button.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = Utilites().makeAtrributedButton("Already have an account?", " Log In")
        button.addTarget(self, action: #selector(returnLoginViewController), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    // MARK: - Selectors
    @objc func returnLoginViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func plusPhotoButtonPressed() {
        print("add Photo")
    }
    
    @objc func registerButtonPressed() {
        print("register Button Pressed")
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .twitterBlue
        view.addSubview(plusPhotoButton)
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0)
        plusPhotoButton.setDimensions(width: 128, height: 128)
        
        let stackView = UIStackView(arrangedSubviews: [emailContainerView,
                                                       passwordContainerView,
                                                       fullNameContainerView,
                                                       userNameContainerView,
                                                       registerButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: plusPhotoButton.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 32, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor,
                                     bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                     right: view.rightAnchor,
                                     paddingLeft: 40, paddingRight: 40)
    }
}
