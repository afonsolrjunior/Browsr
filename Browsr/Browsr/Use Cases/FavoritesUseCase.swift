//
//  FavoritesUseCase.swift
//  Browsr
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import Foundation
import Combine

final class FavoritesUseCase {
    
    let favoritesRepository: FavoritesRepository
    let imageService: ImageService
    let networkStatusService: NetworkStatusService
    
    init(
        favoritesRepository: FavoritesRepository,
        imageService: ImageService,
        networkStatusService: NetworkStatusService
    ) {
        self.favoritesRepository = favoritesRepository
        self.imageService = imageService
        self.networkStatusService = networkStatusService
    }
    
    
    func addFavorite(_ organizationViewModel: OrganizationViewModel) {
        self.favoritesRepository.addFavorite(organizationViewModel)
    }
    
    func getFavorites() -> AnyPublisher<[OrganizationViewModel], Never> {
        self.favoritesRepository.getFavorites()
    }
}
