//
//  GameExtension.swift
//  My Games iOS
//
//  Created by Jorge Tapia on 5/15/15.
//  Copyright (c) 2015 JORGETAPIA.NET. All rights reserved.
//

import UIKit
import CoreData

extension Game {
    
    class func allGames() -> [AnyObject]? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedObjectContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest()
        
        var entity = NSEntityDescription.entityForName("Game", inManagedObjectContext: managedObjectContext!)
        fetchRequest.entity = entity
        
        var error: NSError? = nil
        var games = managedObjectContext?.executeFetchRequest(fetchRequest, error: &error)
        if error != nil {
            NSLog("Unresolved error \(error), \(error?.userInfo)")
            abort()
        }
        
        return games
    }
    
    class func allGames(#genre: Genre) -> [AnyObject]? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
        let managedObjectContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest()
    
        var entity = NSEntityDescription.entityForName("Game", inManagedObjectContext: managedObjectContext!)
        fetchRequest.entity = entity
        
        let predicate = NSPredicate(format: "genre == %@", genre)
        fetchRequest.predicate = predicate
    
        var error: NSError? = nil
        var games = managedObjectContext?.executeFetchRequest(fetchRequest, error: &error)
        if error != nil {
            NSLog("Unresolved error \(error), \(error?.userInfo)")
            abort()
        }
    
        return games
    }
    
    class func allGames(#title: String) -> [AnyObject]? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedObjectContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest()
        
        var entity = NSEntityDescription.entityForName("Game", inManagedObjectContext: managedObjectContext!)
        fetchRequest.entity = entity
        
        let predicate = NSPredicate(format: "(title BEGINSWITH[c] %@) OR (title CONTAINS[c] %@)", title, " \(title)")
        fetchRequest.predicate = predicate
        
        var error: NSError? = nil
        var games = managedObjectContext?.executeFetchRequest(fetchRequest, error: &error)
        if error != nil {
            NSLog("Unresolved error \(error), \(error?.userInfo)")
            abort()
        }
        
        return games
    }
    
    class func remove(game: Game) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        
        managedObjectContext?.deleteObject(game)
        
        appDelegate.saveContext()
    }
    
    class func removeAll() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        
        let items = allGames()
        
        for thumbnail in items! {
            managedObjectContext?.deleteObject(thumbnail as! NSManagedObject)
        }
        
        appDelegate.saveContext()
    }
    
}


