//
//  ThumbnailsExtension.swift
//  My Games iOS
//
//  Created by Jorge Tapia on 5/15/15.
//  Copyright (c) 2015 JORGETAPIA.NET. All rights reserved.
//

import UIKit
import CoreData

extension Thumbnail {
    
    class func thumbnailWithTitle(title: String) -> Thumbnail? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedObjectContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest()
        
        var entity = NSEntityDescription.entityForName("Thumbnail", inManagedObjectContext: managedObjectContext!)
        fetchRequest.entity = entity
        
        let predicate = NSPredicate(format: "title == %@", title)
        fetchRequest.predicate = predicate
        
        var error: NSError? = nil
        var thumbnails: Thumbnail? = managedObjectContext?.executeFetchRequest(fetchRequest, error: &error)?.last as! Thumbnail?
        
        if error != nil {
            NSLog("Unresolved error \(error), \(error?.userInfo)")
            abort()
        }
        
        return thumbnails
    }

    class func thumbnailForGame(game: Game) -> Thumbnail? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedObjectContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest()
        
        var entity = NSEntityDescription.entityForName("Thumbnail", inManagedObjectContext: managedObjectContext!)
        fetchRequest.entity = entity
        
        let predicate = NSPredicate(format: "ANY games == %@", game)
        fetchRequest.predicate = predicate
        
        var error: NSError? = nil
        var thumbnails: Thumbnail? = managedObjectContext?.executeFetchRequest(fetchRequest, error: &error)?.last as! Thumbnail?
        
        if error != nil {
            NSLog("Unresolved error \(error), \(error?.userInfo)")
            abort()
        }
        
        return thumbnails
    }
    
    class func allThumbnails() -> [AnyObject]? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedObjectContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest()
        var entity = NSEntityDescription.entityForName("Thumbnail", inManagedObjectContext: managedObjectContext!)
        fetchRequest.entity = entity
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "title != %@", "default_image")
        fetchRequest.predicate = predicate
        
        var error: NSError? = nil
        var thumbnails = managedObjectContext?.executeFetchRequest(fetchRequest, error: &error)
        if error != nil {
            NSLog("Unresolved error \(error), \(error?.userInfo)")
            abort()
        }
        
        return thumbnails
    }
    
    class func remove(thumbnail: Thumbnail) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        
        var defaultThumbnail = Thumbnail.thumbnailWithTitle("default_image")
        
        if defaultThumbnail == nil {
            var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            var managedObjectContext = appDelegate.managedObjectContext
            
            let thumbnailEntity = NSEntityDescription.entityForName("Thumbnail", inManagedObjectContext: managedObjectContext!)
            defaultThumbnail = Thumbnail(entity: thumbnailEntity!, insertIntoManagedObjectContext: managedObjectContext!)
            defaultThumbnail?.title = "default_image"
            defaultThumbnail?.data = UIImagePNGRepresentation(UIImage(named: "default_image"))
            
            appDelegate.saveContext()
        }
        
        var allGames = Game.allGames() as! [Game]
        
        for game in allGames {
            if game.thumbnail == thumbnail {
                game.thumbnail = defaultThumbnail!
            }
        }
        
        managedObjectContext?.deleteObject(thumbnail)
        
        appDelegate.saveContext()
    }
    
    class func removeAll() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        
        var defaultThumbnail = Thumbnail.thumbnailWithTitle("default_image")
        
        if defaultThumbnail == nil {
            var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            var managedObjectContext = appDelegate.managedObjectContext
            
            let thumbnailEntity = NSEntityDescription.entityForName("Thumbnail", inManagedObjectContext: managedObjectContext!)
            defaultThumbnail = Thumbnail(entity: thumbnailEntity!, insertIntoManagedObjectContext: managedObjectContext!)
            defaultThumbnail?.title = "default_image"
            defaultThumbnail?.data = UIImagePNGRepresentation(UIImage(named: "default_image"))
            
            appDelegate.saveContext()
        }
        
        var allGames = Game.allGames() as! [Game]
        
        for game in allGames {
            game.thumbnail = defaultThumbnail!
        }
        
        let items = allThumbnails()
        
        for thumbnail in items! {
            if thumbnail as! Thumbnail == defaultThumbnail! {
                continue
            }
            
            managedObjectContext?.deleteObject(thumbnail as! NSManagedObject)
        }
        
        appDelegate.saveContext()
    }

}
