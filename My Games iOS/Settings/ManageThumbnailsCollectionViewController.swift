//
//  ManageThumbnailsCollectionViewController.swift
//  My Games iOS
//
//  Created by Jorge Tapia on 5/19/15.
//  Copyright (c) 2015 JORGETAPIA.NET. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreData

class ManageThumbnailsCollectionViewController: UICollectionViewController, UIAlertViewDelegate {
    
    @IBOutlet weak var trashButton: UIBarButtonItem!
    
    var data = Thumbnail.allThumbnails() as! [Thumbnail]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        trashButton.enabled = false
        collectionView?.allowsMultipleSelection = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Actions
    @IBAction func trashAction(sender: AnyObject) {
        var alert = UIAlertView(title: "My Games Collection", message: "This action deletes all the selected thumbnails and cannot be undone. Do you want to delete the selected thumbnails?", delegate: self, cancelButtonTitle: "No", otherButtonTitles: "Yes")
        alert.show()
    }
    
    // Collection view data source
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let thumbnail = data[indexPath.row]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ThumbnailCell", forIndexPath: indexPath) as! UICollectionViewCell
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = UIImage(data: thumbnail.data)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        
        var selectionImage = cell?.viewWithTag(2) as! UIImageView
        selectionImage.hidden = false
        
        trashButton.enabled = true
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        
        var selectionImage = cell?.viewWithTag(2) as! UIImageView
        selectionImage.hidden = true
        
        if collectionView.indexPathsForSelectedItems().count == 0 {
            trashButton.enabled = false
        }
    }
    
    // Alert view delegate
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex != alertView.cancelButtonIndex {
            var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            let selectedIndexPaths = collectionView?.indexPathsForSelectedItems() as! [NSIndexPath]
            
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
            
            for game in Game.allGames() as! [Game] {
                game.thumbnail = defaultThumbnail!
            }
            
            appDelegate.saveContext()
            
            for indexPath in selectedIndexPaths {
                Thumbnail.remove(self.data[indexPath.row])
            }
            
            self.data = Thumbnail.allThumbnails() as! [Thumbnail]
            
            collectionView?.performBatchUpdates({ () -> Void in
                collectionView?.deleteItemsAtIndexPaths(selectedIndexPaths)
            }, completion: { (completed: Bool) -> Void in
                
                self.collectionView?.reloadData()
                self.trashButton.enabled = false
                
                if self.data.count == 0 {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            })
        }
    }
}