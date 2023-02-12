//
//  OrganizationsUseCase.swift
//  Browsr
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import Foundation
import Combine

final class OrganizationsUseCase {
    
    let organizationsRepository: OrganizationsRepository
    let imageService: ImageService
    let networkStatusService: NetworkStatusService
    
    init(
        organizationsRepository: OrganizationsRepository,
        imageService: ImageService,
        networkStatusService: NetworkStatusService
    ) {
        self.organizationsRepository = organizationsRepository
        self.imageService = imageService
        self.networkStatusService = networkStatusService
    }
    
    func getOrganizations() -> AnyPublisher<[OrganizationViewModel], Error> {
        guard networkStatusService.getStatus() == .connected else {
            return Fail(outputType: [OrganizationViewModel].self,
                        failure: NetworkError.disconnected).eraseToAnyPublisher()
        }
        return self.organizationsRepository.getOrganizations().eraseToAnyPublisher()
    }
    
    func getOrganization(name: String) -> AnyPublisher<OrganizationViewModel, Error> {
        guard networkStatusService.getStatus() == .connected else {
            return Fail(outputType: OrganizationViewModel.self,
                        failure: NetworkError.disconnected).eraseToAnyPublisher()
        }
        return self.organizationsRepository.getOrganization(name: name).eraseToAnyPublisher()
    }
    
}
