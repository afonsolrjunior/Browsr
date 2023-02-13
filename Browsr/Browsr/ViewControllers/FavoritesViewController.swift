//
//  FavoritesViewController.swift
//  Browsr
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import UIKit
import Combine

final class FavoritesViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = dataProvider
        return tableView
    }()
    
    private let presenter: FavoritesPresenter
    private let dataProvider: DataProvider
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(presenter: FavoritesPresenter, dataProvider: DataProvider) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        
        self.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
        
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        ])
        
    }
    
    private func bind() {
        
        presenter.getFavorites()
            .receive(on: RunLoop.main)
            .sink { completion in
                print(completion)
            } receiveValue: { viewModels in
                self.dataProvider.update(items: viewModels)
                self.tableView.reloadData()
            }.store(in: &cancellables)

    }
    
}

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.removeFavorite(dataProvider.items[indexPath.row])
        tableView.reloadData()
    }
    
}
