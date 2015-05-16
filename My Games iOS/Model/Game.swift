//
//  Game.swift
//  My Games iOS
//
//  Created by Jorge Tapia on 5/16/15.
//  Copyright (c) 2015 JORGETAPIA.NET. All rights reserved.
//

import Foundation
import CoreData

class Game: NSManagedObject {

    @NSManaged var buy: String
    @NSManaged var desc: String
    @NSManaged var publisher: String
    @NSManaged var source: String
    @NSManaged var title: String
    @NSManaged var modes: String
    @NSManaged var genre: Genre
    @NSManaged var platform: Platform
    @NSManaged var thumbnail: Thumbnail

}
