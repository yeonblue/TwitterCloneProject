//
//  RegisterViewController.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/05.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    // MARK: - Properties
    private let imagePickerController = UIImagePickerController()
    private var profileImage: UIImage?
    
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
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func registerButtonPressed() {
        guard let profileImage = profileImage       else { return }
        guard let email    = emailTextField.text    else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullNameTextField.text else { return }
        guard let username = userNameTextField.text else { return }
        
        //print("DEBUG: Email: \(email), Password: \(password)")
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            let values = ["email": email,
                          "fullname": fullname,
                          "username": username]
            
            // users - uid 아래 dictionary 정보 저장
            let ref = Database.database().reference().child("users").child(uid)
            
            ref.updateChildValues(values) { (error, ref) in
                print("Successfully updated user info")
            }
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
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

// MARK: - UIImagePickerControllerDelegate
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else { return }
        self.profileImage = profileImage
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.bounds.height / 2
        plusPhotoButton.clipsToBounds = true
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        // renderingMode가 templete일 경우 tintColor 적용 가능
        self.plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true , completion: nil)
    }
}
