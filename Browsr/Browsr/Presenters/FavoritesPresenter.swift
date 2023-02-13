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
    
    private let reloadDataSubject = PassthroughSubject<Void, Never>()
    
    init(
        getFavoritesService: GetFavoritesService,
        removeFavoriteService: RemoveFavoriteService,
        imageService: ImageService
    ) {
        self.getFavoritesService = getFavoritesService
        self.removeFavoriteService = removeFavoriteService
        self.imageService = imageService
    }
    
    func reloadData() {
        reloadDataSubject.send(())
    }
    
    func getFavorites() -> AnyPublisher<[OrganizationViewModel], Never> {
        return reloadDataSubject.flatMap {[weak self] _ -> AnyPublisher<[OrganizationViewModel], Never> in
            guard let self else {
                return Just([]).eraseToAnyPublisher()
            }
            return self.getFavoritesService.getFavorites().eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
    
    func removeFavorite(_ organizationViewModel: OrganizationViewModel) {
        removeFavoriteService.removeFavorite(organizationViewModel)
    }
    
    func getImage(for organizationViewModel: OrganizationViewModel) -> AnyPublisher<UIImage, Never> {
        imageService.getImage(for: organizationViewModel.avatarUrl)
    }
    
}
