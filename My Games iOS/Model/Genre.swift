//
//  Genre.swift
//  My Games iOS
//
//  Created by Jorge Tapia on 5/16/15.
//  Copyright (c) 2015 JORGETAPIA.NET. All rights reserved.
//

import Foundation
import CoreData

class Genre: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var games: NSSet

}
