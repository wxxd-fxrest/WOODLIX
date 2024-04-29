//
//  UserInfo+CoreDataProperties.swift
//  WOODLIX
//
//  Created by 밀가루 on 4/26/24.
//
//

import Foundation
import CoreData


extension UserInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfo> {
        return NSFetchRequest<UserInfo>(entityName: "UserInfo")
    }

    @NSManaged public var id: String?
    @NSManaged public var password: String?

}

extension UserInfo : Identifiable {

}
