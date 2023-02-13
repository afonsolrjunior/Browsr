//
//  OrganizationsViewController.swift
//  Browsr
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import UIKit
import Combine

final class OrganizationsViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = dataProvider
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        return searchBar
    }()
    
    private let presenter: OrganizationsPresenter
    private let dataProvider: DataProvider
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(presenter: OrganizationsPresenter, dataProvider: DataProvider) {
        self.presenter = presenter
        self.dataProvider = dataProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        bind()
    }
    
    private func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        self.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
        
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        ])
        
    }
    
    private func bind() {
        
        presenter.getOrganizations()
            .receive(on: RunLoop.main)
            .sink { completion in
                print(completion)
            } receiveValue: { viewModels in
                self.dataProvider.update(items: viewModels)
                self.tableView.reloadData()
            }.store(in: &cancellables)
        
        presenter.getSearchedOrganization()
            .receive(on: RunLoop.main)
            .sink { completion in
                print(completion)
            } receiveValue: { viewModel in
                self.dataProvider.update(items: [viewModel])
                self.tableView.reloadData()
            }.store(in: &cancellables)

    }
    
}

extension OrganizationsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.addFavorite(dataProvider.items[indexPath.row])
    }
    
}

extension OrganizationsViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, searchText.count >= 3 else { return }
        
        presenter.searchTextSubject.send(searchText)
    }
    
}
