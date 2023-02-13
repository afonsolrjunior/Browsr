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
        searchBar.autocapitalizationType = .none
        searchBar.delegate = self
        return searchBar
    }()
    
    private let presenter: OrganizationsPresenter
    private let dataProvider: DataProvider
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(presenter: OrganizationsPresenter, dataProvider: DataProvider) {
        self.presenter = presenter
        self.dataProvider = dataProvider
        self.dataProvider.imageLoader = presenter.getImage(for:)
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
        
        view.backgroundColor = .systemBackground
        
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
        
        let presenterOutput =  presenter.outputs()
        
        presenterOutput.0
            .receive(on: RunLoop.main)
            .sink { completion in
                print(completion)
            } receiveValue: { viewModels in
                self.dataProvider.update(items: viewModels)
                self.tableView.reloadData()
            }.store(in: &cancellables)
        
        presenterOutput.1
            .receive(on: RunLoop.main)
            .sink { completion in
                print(completion)
            } receiveValue: { viewModel in
                self.dataProvider.replace(items: [viewModel])
                self.tableView.reloadData()
            }.store(in: &cancellables)

    }
    
}

extension OrganizationsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.addFavorite(dataProvider.items[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !dataProvider.items.isEmpty && indexPath.row == dataProvider.items.count - 5 else { return }
        
        presenter.getNewPageSubject.send(())
    }
    
}

extension OrganizationsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        
        presenter.searchTextSubject.send(searchText)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard searchBar.text.isNilOrEmpty else { return }
        
    }
    
}
