//
//  ExploreController.swift
//  TwitterCloneProject
//
//  Created by yeonBlue on 2021/03/04.
//

import UIKit

private let reuseIdentifier = "UserTableCell"

class ExploreController: UITableViewController {
    
    // MARK: - Properties
    private var users = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var filterdUsers = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var isSearchMode:Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureSearchController()
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    // MARK: - API
    func fetchUsers() {
        UserService.shared.fetchUsers { users in
            self.users = users
        }
    }
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Explore"
        navigationController?.navigationBar.tintColor = .twitterBlue
        
        tableView.register(UserTableCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }
    
    func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a user"
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}

// MARK: - UITableViewDelegate/DataSource
extension ExploreController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchMode ? filterdUsers.count
                            : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserTableCell
        let user = isSearchMode ? filterdUsers[indexPath.row]
                                : users[indexPath.row]
        cell.user = user
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = isSearchMode ? filterdUsers[indexPath.row]
                                : users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension ExploreController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filterdUsers = users.filter({ $0.username.lowercased().contains(searchText)
                                      || $0.fullname.lowercased().contains(searchText)})
    }
}
