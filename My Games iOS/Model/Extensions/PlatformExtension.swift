//
//  PlatformExtension.swift
//  My Games iOS
//
//  Created by Jorge Tapia on 5/15/15.
//  Copyright (c) 2015 JORGETAPIA.NET. All rights reserved.
//

import UIKit
import CoreData

extension Platform {
    
    class func createNew(title: String?) -> Platform? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        
        let platformEntity = NSEntityDescription.entityForName("Platform", inManagedObjectContext: managedObjectContext!)
        
        var newPlatform = Platform(entity: platformEntity!, insertIntoManagedObjectContext: managedObjectContext)
        newPlatform.title = title != nil ? title! : String()
        
        return newPlatform
    }

    class func platformWithTitle(title: String) -> Platform? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedObjectContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest()
        
        var entity = NSEntityDescription.entityForName("Platform", inManagedObjectContext: managedObjectContext!)
        fetchRequest.entity = entity
        
        let predicate = NSPredicate(format: "title == %@", title)
        fetchRequest.predicate = predicate
        
        var error: NSError? = nil
        var platform: Platform? = managedObjectContext?.executeFetchRequest(fetchRequest, error: &error)?.last as! Platform?
        
        if error != nil {
            NSLog("Unresolved error \(error), \(error?.userInfo)")
            abort()
        }
        
        return platform
    }
    
    class func allPlatforms() -> [AnyObject]? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedObjectContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest()
        var entity = NSEntityDescription.entityForName("Platform", inManagedObjectContext: managedObjectContext!)
        fetchRequest.entity = entity
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var error: NSError? = nil
        var platforms = managedObjectContext?.executeFetchRequest(fetchRequest, error: &error)
        if error != nil {
            NSLog("Unresolved error \(error), \(error?.userInfo)")
            abort()
        }
        
        return platforms
    }
    
    class func remove(platform: Platform) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        
        managedObjectContext?.deleteObject(platform)
        
        appDelegate.saveContext()
    }
    
    class func removeAll() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        
        let items = allPlatforms()
        
        for thumbnail in items! {
            managedObjectContext?.deleteObject(thumbnail as! NSManagedObject)
        }
        
        appDelegate.saveContext()
    }

}
