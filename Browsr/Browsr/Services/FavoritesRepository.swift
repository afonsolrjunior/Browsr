//
//  FavoritesRepository.swift
//  Browsr
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import Foundation
import Combine

protocol AddFavoriteService {
    func addFavorite(_ organizationViewModel: OrganizationViewModel)
}

protocol GetFavoritesService {
    func getFavorites() -> AnyPublisher<[OrganizationViewModel], Never>
}

protocol RemoveFavoriteService {
    func removeFavorite(_ organizationViewModel: OrganizationViewModel)
}

protocol FavoritesRepository: AddFavoriteService & GetFavoritesService & RemoveFavoriteService {}

final class CoreDataFavoritesService: FavoritesRepository {
    
    let coreDataService: CoreDataService
    
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }
    
    func addFavorite(_ organizationViewModel: OrganizationViewModel) {
        self.coreDataService.addFavorite(organization: organizationViewModel)
    }
    
    func removeFavorite(_ organizationViewModel: OrganizationViewModel) {
        self.coreDataService.removeFavorite(organization: organizationViewModel)
    }
    
    func getFavorites() -> AnyPublisher<[OrganizationViewModel], Never> {
        return Future {[weak self] promise in
            
            let favorites = self?.coreDataService.getFavorites().map({ OrganizationViewModel(name: $0.name ?? "",
                                                                                             avatarUrl: $0.avatarUrl ?? "") }) ?? []
            promise(.success(favorites))
            
        }.eraseToAnyPublisher()
    }
    
    
    
    
}
