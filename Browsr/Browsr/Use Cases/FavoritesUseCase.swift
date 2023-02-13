//
//  FavoritesUseCase.swift
//  Browsr
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import Foundation
import Combine

final class FavoritesUseCase {
    
    private let favoritesRepository: FavoritesRepository
    private let networkStatusService: NetworkStatusService
    
    init(
        favoritesRepository: FavoritesRepository,
        networkStatusService: NetworkStatusService
    ) {
        self.favoritesRepository = favoritesRepository
        self.networkStatusService = networkStatusService
    }
    
    func addFavorite(_ organizationViewModel: OrganizationViewModel) {
        self.favoritesRepository.addFavorite(organizationViewModel)
    }
    
    func getFavorites() -> AnyPublisher<[OrganizationViewModel], Never> {
        self.favoritesRepository.getFavorites()
    }
}
