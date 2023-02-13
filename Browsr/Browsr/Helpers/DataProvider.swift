//
//  DataProvider.swift
//  Browsr
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import UIKit
import Combine

final class DataProvider: NSObject, UITableViewDataSource {

    private(set) var items: [OrganizationViewModel] = []
    public var imageLoader: ((OrganizationViewModel) -> AnyPublisher<UIImage, Never>)?
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    func update(items: [OrganizationViewModel]) {
        self.items.append(contentsOf: items)
    }
    
    func replace(items: [OrganizationViewModel]) {
        self.items = items
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        
        imageLoader?(items[indexPath.row]).receive(on: RunLoop.main).sink {[weak self] image in
            guard let self else { return }
            var configuration = UIListContentConfiguration.cell()
            configuration.text = self.items[indexPath.row].name
            configuration.imageToTextPadding = 4
            configuration.image = image
            cell.contentConfiguration = configuration
        }.store(in: &cancellables)
        
        return cell
    }
    
}
