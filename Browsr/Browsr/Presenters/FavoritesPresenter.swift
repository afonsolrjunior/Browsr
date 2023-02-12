//
//  FavoritesPresenter.swift
//  Browsr
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import UIKit
import Combine

final class FavoritesPresenter {
    
    private let getFavoritesService: GetFavoritesService
    private let removeFavoriteService: RemoveFavoriteService
    private let imageService: ImageService
    
    init(
        getFavoritesService: GetFavoritesService,
        removeFavoriteService: RemoveFavoriteService,
        imageService: ImageService
    ) {
        self.getFavoritesService = getFavoritesService
        self.removeFavoriteService = removeFavoriteService
        self.imageService = imageService
    }
    
    func getFavorites() -> AnyPublisher<[OrganizationViewModel], Never> {
        getFavoritesService.getFavorites()
    }
    
    func removeFavorite(_ organizationViewModel: OrganizationViewModel) {
        removeFavoriteService.removeFavorite(organizationViewModel)
    }
    
}
