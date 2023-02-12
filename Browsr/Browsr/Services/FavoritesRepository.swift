//
//  FavoritesRepository.swift
//  Browsr
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import Foundation
import Combine

protocol FavoritesRepository {
    func addFavorite(_ organizationViewModel: OrganizationViewModel)
    func getFavorites() -> AnyPublisher<[OrganizationViewModel], Never>
}

final class CoreDataFavoritesService: FavoritesRepository {
    
    let coreDataService: CoreDataService
    
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }
    
    func addFavorite(_ organizationViewModel: OrganizationViewModel) {
        self.coreDataService.addFavorite(organization: organizationViewModel)
    }
    
    func getFavorites() -> AnyPublisher<[OrganizationViewModel], Never> {
        return Future {[weak self] promise in
            
            let favorites = self?.coreDataService.getFavorites().map({ OrganizationViewModel(name: $0.name ?? "",
                                                                                             avatarUrl: $0.avatarUrl ?? "") }) ?? []
            promise(.success(favorites))
            
        }.eraseToAnyPublisher()
    }
    
    
    
    
}
