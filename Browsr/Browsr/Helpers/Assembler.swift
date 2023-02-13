//
//  Assembler.swift
//  Browsr
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import UIKit
import Combine
import Browsr_Lib

final class Assembler {
    
    func lib() -> Browsr_Lib {
        return Browsr_Lib()
    }
    
    let networkStatusService = NetworkStatusMonitor()
    let cacheService = ImageCacheService()
    
    func imageService() -> ImageService {
        UIImageService(cacheService: cacheService,
                       imageDataService: lib())
    }
    
    lazy var organizationRepository = OrganizationService(organizationsService: lib())
    let coreDataService = CoreDataService()
    lazy var favoritesRepository = CoreDataFavoritesService(coreDataService: coreDataService)
    
    lazy var organizationsUseCase = OrganizationsUseCase(organizationsRepository: organizationRepository,
                                                         networkStatusService: networkStatusService)
    lazy var favoritesUseCase = FavoritesUseCase(favoritesRepository: favoritesRepository,
                                                 networkStatusService: networkStatusService)
    
    lazy var organizationsPresenter = OrganizationsPresenter(organizationsUseCase: organizationsUseCase,
                                                             addFavoriteService: favoritesRepository,
                                                             imageService: imageService())
    lazy var favoritesPresenter = FavoritesPresenter(getFavoritesService: favoritesRepository,
                                                     removeFavoriteService: favoritesRepository,
                                                     imageService: imageService())
    
    lazy var organizationsDataProvider = DataProvider()
    lazy var favoritesDataProvider = DataProvider()
    
    lazy var organizationsViewController = OrganizationsViewController(presenter: organizationsPresenter,
                                                                       dataProvider: organizationsDataProvider)
    lazy var favoritesViewController = FavoritesViewController(presenter: favoritesPresenter,
                                                               dataProvider: favoritesDataProvider)
    
    func organizationsCoordinator() -> ListCoordinator {
        ListCoordinator(viewController: organizationsViewController)
    }
    
    func favoritesCoordinator() -> ListCoordinator {
        ListCoordinator(viewController: favoritesViewController)
    }
    
    func mainCoordinator() -> MainCoordinator {
        MainCoordinator(coordinators: [favoritesCoordinator(), organizationsCoordinator()])
    }
}
