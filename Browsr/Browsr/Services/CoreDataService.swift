//
//  CoreDataService.swift
//  Browsr
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import Foundation
import CoreData

final class CoreDataService {
    
    // MARK: - Core Data stack

    private lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Browsr")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getFavorites() -> [OrganizationDTO] {
        let context = persistentContainer.viewContext
        let fetchRequest = OrganizationDTO.fetchRequest()
        
        return context.performAndWait {
            do {
                let organizations = try context.fetch(fetchRequest)
                return organizations
            } catch {
                return []
            }
            
        }
        
    }
    
    func addFavorite(organization: OrganizationViewModel) {
        let context = persistentContainer.viewContext
        let fetchRequest = OrganizationDTO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", organization.name)
        
        return context.performAndWait {
            do {
                let objects = try context.fetch(fetchRequest)
                
                if objects.isEmpty {
                    let favorite = OrganizationDTO(context: context)
                    favorite.name = organization.name
                    favorite.avatarUrl = organization.avatarUrl
                    
                    try context.save()
                }

            } catch {
                
            }
            
        }
        
    }
    
    func removeFavorite(organization: OrganizationViewModel) {
        let context = persistentContainer.viewContext
        let fetchRequest = OrganizationDTO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", organization.name)
        
        return context.performAndWait {
            do {
                let objects = try context.fetch(fetchRequest)
                for object in objects {
                    context.delete(object)
                }
                try context.save()
            } catch {
                
            }
            
        }
        
    }
    
}
