//
//  GenreExtension.swift
//  My Games iOS
//
//  Created by Jorge Tapia on 5/15/15.
//  Copyright (c) 2015 JORGETAPIA.NET. All rights reserved.
//

import UIKit
import CoreData

extension Genre {
    
    class func createNew(title: String?) -> Genre? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        
        let platformEntity = NSEntityDescription.entityForName("Genre", inManagedObjectContext: managedObjectContext!)
        
        var newGenre = Genre(entity: platformEntity!, insertIntoManagedObjectContext: managedObjectContext)
        newGenre.title = title != nil ? title! : String()
        
        return newGenre
    }

    class func genreWithTitle(title: String) -> Genre? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedObjectContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest()
        
        var entity = NSEntityDescription.entityForName("Genre", inManagedObjectContext: managedObjectContext!)
        fetchRequest.entity = entity
        
        let predicate = NSPredicate(format: "title == %@", title)
        fetchRequest.predicate = predicate
        
        var error: NSError? = nil
        var genre: Genre? = managedObjectContext?.executeFetchRequest(fetchRequest, error: &error)?.last as! Genre?
        
        if error != nil {
            NSLog("Unresolved error \(error), \(error?.userInfo)")
            abort()
        }
        
        return genre
    }
    
    class func allGenres() -> [AnyObject]? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedObjectContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest()
        var entity = NSEntityDescription.entityForName("Genre", inManagedObjectContext: managedObjectContext!)
        fetchRequest.entity = entity
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var error: NSError? = nil
        var genres = managedObjectContext?.executeFetchRequest(fetchRequest, error: &error)
        if error != nil {
            NSLog("Unresolved error \(error), \(error?.userInfo)")
            abort()
        }
        
        return genres
    }
    
    class func remove(genre: Genre) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        
        managedObjectContext?.deleteObject(genre)
        
        appDelegate.saveContext()
    }
    
    class func removeAll() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        
        let items = allGenres()
        
        for thumbnail in items! {
            managedObjectContext?.deleteObject(thumbnail as! NSManagedObject)
        }
        
        appDelegate.saveContext()
    }
    
}
