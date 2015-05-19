//
//  Thumbnail.swift
//  My Games iOS
//
//  Created by Jorge Tapia on 5/19/15.
//  Copyright (c) 2015 JORGETAPIA.NET. All rights reserved.
//

import Foundation
import CoreData

class Thumbnail: NSManagedObject {

    @NSManaged var data: NSData
    @NSManaged var title: String
    @NSManaged var games: NSSet

}
