//
//  OrganizationsPresenter.swift
//  Browsr
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import UIKit
import Combine

final class OrganizationsPresenter {
    
    private let organizationsUseCase: OrganizationsUseCase
    private let addFavoriteService: AddFavoriteService
    private let imageService: ImageService
    
    init(
        organizationsUseCase: OrganizationsUseCase,
        addFavoriteService: AddFavoriteService,
        imageService: ImageService
    ) {
        self.organizationsUseCase = organizationsUseCase
        self.addFavoriteService = addFavoriteService
        self.imageService = imageService
    }
    
    func getOrganizations() -> AnyPublisher<[OrganizationViewModel], Error> {
        return organizationsUseCase.getOrganizations()
    }
    
    func getOrganization(name: String) -> AnyPublisher<OrganizationViewModel, Error> {
        return organizationsUseCase.getOrganization(name: name)
    }
    
    func addFavorite(_ organizationViewModel: OrganizationViewModel) {
        addFavoriteService.addFavorite(organizationViewModel)
    }
}
