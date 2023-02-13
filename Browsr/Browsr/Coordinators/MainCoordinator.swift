//
//  MainCoordinator.swift
//  Browsr
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import UIKit

protocol Coordinator: AnyObject {
    var children: [Coordinator] { get set }
    
    func start()
    func start(child: Coordinator)
    func rootViewController() -> UIViewController
}

extension Coordinator {
    func start(child: Coordinator) {
        children.append(child)
        child.start()
    }
}

final class MainCoordinator: NSObject, Coordinator {
    var children: [Coordinator] = []
    
    private let tabBarController = UITabBarController()
    
    init(coordinators: [Coordinator]) {
        self.children = coordinators
        super.init()
        setupTabs()
    }
    
    func start() {
        
    }
    
    func rootViewController() -> UIViewController {
        tabBarController
    }
    
    private func setupTabs() {
        tabBarController.delegate = self
        tabBarController.setViewControllers(children.map({ $0.rootViewController() }), animated: true)
        tabBarController.selectedIndex = 1
    }
}

extension MainCoordinator: UITabBarControllerDelegate {


    
    
}
