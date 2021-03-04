//
//  ExploreController.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/04.
//

import UIKit

class ExploreController: UIViewController {
    
    // MARK: - Properties
    
    // Mark: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Explore"
    }
}
