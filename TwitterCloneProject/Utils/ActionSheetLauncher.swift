//
//  ActionSheetLauncher.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/21.
//

import UIKit

private let reuseIdentifier = "ActionSheetCell"

protocol ActionSheetLauncherDelegate: class {
    func didSelect(option: ActionSheetOptions)
}

class ActionSheetLauncher: NSObject {
    
    // MARK: - Properties
    
    private let user: User
    private let tableView = UITableView()
    private let tableCellHeight: CGFloat = 60
    private var alertSheetHeight: CGFloat?
    
    weak var delegate: ActionSheetLauncherDelegate?
    
    // blackView가 네이게이션 바도 가리기 위해 UIWindow를 가져옴
    private var window: UIWindow?
    
    private lazy var blackView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleActionSheetDismissal))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.systemGroupedBackground
        button.addTarget(self, action: #selector(handleActionSheetDismissal), for: .touchUpInside)
        return button
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView()
        view.addSubview(cancelButton)
        cancelButton.anchor(left: view.leftAnchor,
                            right: view.rightAnchor,
                            paddingLeft: 12, paddingRight: 12, height: 50)
        cancelButton.centerY(inView: view)
        cancelButton.layer.cornerRadius = 50 / 2
        
        return view
    }()
    
    private lazy var viewModel = ActionSheetViewModel(user: user)
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init()
        configureTableView()
    }
    
    // MARK: - Selector
    
    @objc func handleActionSheetDismissal() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.showTableView(false)
        }
    }
    
    // MARK: - Helpers
    
    func show() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        self.window = window
        self.alertSheetHeight = CGFloat(viewModel.options.count * 60) + 100
        
        window.addSubview(blackView)
        blackView.frame = window.frame
        
        window.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: window.frame.height,
                                 width: window.frame.width, height: alertSheetHeight!)
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.blackView.alpha = 1
            self?.showTableView(true)
        }
    }
    
    func showTableView(_ shouldShow: Bool) {
        guard let window = window else { return }
        guard let height = alertSheetHeight else { return }
        
        let y = shouldShow ? window.frame.height - height
                           : window.frame.height
        
        tableView.frame.origin.y = y
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = tableCellHeight
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 10
        tableView.isScrollEnabled = false
        
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
}

// MARK: - UITableViewDataSource/Delegate

extension ActionSheetLauncher: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ActionSheetCell
        cell.option = viewModel.options[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = viewModel.options[indexPath.row]
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.showTableView(false)
        } completion: { _ in
            self.delegate?.didSelect(option: option)
        }
    }
}
