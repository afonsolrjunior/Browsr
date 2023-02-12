//
//  ListCoordinator.swift
//  Browsr
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import UIKit

final class ListCoordinator: NSObject, Coordinator {
    var children: [Coordinator] = []
    
    private let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init()
    }
    
    func start() {
        
    }
    
    func rootViewController() -> UIViewController {
        viewController
    }
}
