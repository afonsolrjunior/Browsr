//
//  DataProvider.swift
//  Browsr
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import UIKit

final class DataProvider: NSObject, UITableViewDataSource {

    private(set) var items: [OrganizationViewModel] = []
    
    func update(items: [OrganizationViewModel]) {
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
        
        var configuration = UIListContentConfiguration.cell()
        configuration.text = items[indexPath.row].name
        cell.contentConfiguration = configuration
        
        return cell
    }
    
}
