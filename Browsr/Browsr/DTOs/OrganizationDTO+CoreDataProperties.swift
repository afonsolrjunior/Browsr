//
//  OrganizationDTO+CoreDataProperties.swift
//  Browsr
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//
//

import Foundation
import CoreData


extension OrganizationDTO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrganizationDTO> {
        return NSFetchRequest<OrganizationDTO>(entityName: "OrganizationDTO")
    }

    @NSManaged public var name: String?
    @NSManaged public var avatarUrl: String?

}

extension OrganizationDTO : Identifiable {

}
