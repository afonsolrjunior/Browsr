//
//  OrganizationsRepository.swift
//  Browsr
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import Foundation
import Combine
import Browsr_Lib

protocol OrganizationsRepository {
    func getOrganizations() -> AnyPublisher<[OrganizationViewModel], Error>
    func getOrganization(name: String) -> AnyPublisher<OrganizationViewModel, Error>
}

final class OrganizationService: OrganizationsRepository {
    
    private let organizationsService: OrganizationsService
    private let imageService: ImageService
    private var nextRequestUrl = ""
    
    init(organizationsService: OrganizationsService, imageService: ImageService) {
        self.organizationsService = organizationsService
        self.imageService = imageService
    }
    
    func getOrganizations() -> AnyPublisher<[OrganizationViewModel], Error> {
        let endPoint: OrganizationsEndpoint
        
        if nextRequestUrl.isEmpty {
            endPoint = .organizations()
        } else {
            endPoint = .organizations(nextPagePath: formatNextPagePath(nextRequestUrl))
        }
        
        let request = OrganizationsRequest(endpoint: endPoint)
        
        return organizationsService.getOrganizations(request: request).map {[weak self] pagedResponse in
            guard let self else { return [] }
            self.nextRequestUrl = pagedResponse.nextPageUrl
            return pagedResponse.results
                .map({  OrganizationViewModel(name: $0.name,
                                              avatarImageLoader: self.imageService.getImage(for: $0.avatarUrlString)) })
        }.eraseToAnyPublisher()
    }
    
    func getOrganization(name: String) -> AnyPublisher<OrganizationViewModel, Error> {
        let request = OrganizationsRequest(endpoint: .search(name: name))
        
        return organizationsService.getOrganizations(request: request).map {[weak self] organization in
            guard let self else { return  }
            return OrganizationViewModel(name: organization.name,
                                         avatarImageLoader: self.imageService.getImage(for: organization.avatarUrlString))
        }.eraseToAnyPublisher()
    }
    
    private func formatNextPagePath(_ path: String) -> String {
        guard path.isEmpty else { return path }
        let components = path.components(separatedBy: CharacterSet(charactersIn: "?"))
        let newPath = "?" + (components.last ?? "")
        return newPath
    }
    
    
    
    
}
