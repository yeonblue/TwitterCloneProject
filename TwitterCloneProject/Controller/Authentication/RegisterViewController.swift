//
//  RegisterViewController.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/05.
//

import UIKit

class RegisterViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .twitterBlue
    }
}
