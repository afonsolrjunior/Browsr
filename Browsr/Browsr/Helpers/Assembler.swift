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
    
    let lib = Browsr_Lib()
    
    let networkStatusService = NetworkStatusMonitor()
    let cacheService = ImageCacheService()
    lazy var imageService = UIImageService(cacheService: cacheService,
                                                   imageDataService: lib)
    
    lazy var organizationRepository = OrganizationService(organizationsService: lib)
    lazy var coreDataService = CoreDataService()
    lazy var favoritesRepository = CoreDataFavoritesService(coreDataService: coreDataService)
    
    lazy var organizationsUseCase = OrganizationsUseCase(organizationsRepository: organizationRepository,
                                                         imageService: imageService,
                                                         networkStatusService: networkStatusService)
    lazy var favoritesUseCase = FavoritesUseCase(favoritesRepository: favoritesRepository,
                                                 imageService: imageService,
                                                 networkStatusService: networkStatusService)
    
    lazy var organizationsPresenter = OrganizationsPresenter(organizationsUseCase: organizationsUseCase,
                                                             addFavoriteService: favoritesRepository,
                                                             imageService: imageService)
    lazy var favoritesPresenter = FavoritesPresenter(getFavoritesService: favoritesRepository,
                                                     removeFavoriteService: favoritesRepository,
                                                     imageService: imageService)
    
    lazy var organizationsDataProvider = DataProvider()
    lazy var favoritesDataProvider = DataProvider()
    
    lazy var organizationsViewController = OrganizationsViewController(presenter: organizationsPresenter,
                                                                       dataProvider: organizationsDataProvider)
    lazy var favoritesViewController = FavoritesViewController(presenter: favoritesPresenter,
                                                               dataProvider: favoritesDataProvider)
    
    lazy var organizationsCoordinator = ListCoordinator(viewController: organizationsViewController)
    lazy var favoritesCoordinator = ListCoordinator(viewController: favoritesViewController)
    lazy var mainCoordinator = MainCoordinator(coordinators: [organizationsCoordinator, favoritesCoordinator])
}
