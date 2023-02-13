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
    public let getNewPageSubject = CurrentValueSubject<Void, Never>(())
    
    init(
        organizationsUseCase: OrganizationsUseCase,
        addFavoriteService: AddFavoriteService,
        imageService: ImageService
    ) {
        self.organizationsUseCase = organizationsUseCase
        self.addFavoriteService = addFavoriteService
        self.imageService = imageService
    }
    
    public func outputs() -> (AnyPublisher<[OrganizationViewModel], Error>, AnyPublisher<OrganizationViewModel, Error>) {
        let getOrganizationsPublisher: AnyPublisher<[OrganizationViewModel], Error>
        let getSearchedOrganizationPublisher: AnyPublisher<OrganizationViewModel, Error>
        
        getOrganizationsPublisher = getNewPageSubject.throttle(for: .seconds(2),
                                                               scheduler: RunLoop.main,
                                                               latest: true).flatMap { _ in
            return self.organizationsUseCase.getOrganizations()
        }.eraseToAnyPublisher()
        
        getSearchedOrganizationPublisher = searchTextSubject.flatMap {[weak self] name -> AnyPublisher<OrganizationViewModel, Error> in
            guard let self else {
                return Fail(outputType: OrganizationViewModel.self,
                            failure: BrowsrLibError.organizationNotFound)
                .eraseToAnyPublisher()
            }
            return self.organizationsUseCase.getOrganization(name: name).eraseToAnyPublisher()
        }.eraseToAnyPublisher()
        
        return (getOrganizationsPublisher, getSearchedOrganizationPublisher)
    }
    
    func addFavorite(_ organizationViewModel: OrganizationViewModel) {
        addFavoriteService.addFavorite(organizationViewModel)
    }
    
    func getImage(for organizationViewModel: OrganizationViewModel) -> AnyPublisher<UIImage, Never> {
        imageService.getImage(for: organizationViewModel.avatarUrl)
    }
}
