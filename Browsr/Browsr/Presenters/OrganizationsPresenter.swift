//
//  OrganizationsPresenter.swift
//  Browsr
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import UIKit
import Combine
import Browsr_Lib

final class OrganizationsPresenter {
    
    private let organizationsUseCase: OrganizationsUseCase
    private let addFavoriteService: AddFavoriteService
    private let imageService: ImageService
    
    public let searchTextSubject = PassthroughSubject<String, Never>()
    
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
    
    func getSearchedOrganization() -> AnyPublisher<OrganizationViewModel, Error> {
        return searchTextSubject.flatMap {[weak self] name -> AnyPublisher<OrganizationViewModel, Error> in
            guard let self else {
                return Fail(outputType: OrganizationViewModel.self,
                            failure: BrowsrLibError.organizationNotFound)
                .eraseToAnyPublisher()
            }
            return self.organizationsUseCase.getOrganization(name: name.lowercased()).eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
    
    func addFavorite(_ organizationViewModel: OrganizationViewModel) {
        addFavoriteService.addFavorite(organizationViewModel)
    }
}
