//
//  ThumbnailChooserCollectionViewController.swift
//  My Games iOS
//
//  Created by Jorge Tapia on 5/20/15.
//  Copyright (c) 2015 JORGETAPIA.NET. All rights reserved.
//

import UIKit

class ThumbnailChooserCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var chooseButton: UIBarButtonItem!
    
    var data = Thumbnail.allThumbnails() as! [Thumbnail]
    var selectedIndexPath: NSIndexPath?
    
    weak var delegate: AnyObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseButton.enabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Actions
    @IBAction func cancelAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func chooseAction(sender: AnyObject) {
        if delegate.isKindOfClass(EditGameTableViewController) {
            (delegate as! EditGameTableViewController).thumbnail = data[selectedIndexPath!.row]
            (delegate as! EditGameTableViewController).addImageButton.setImage(UIImage(data: data[selectedIndexPath!.row].data), forState: UIControlState.Normal)
            
            dismissViewControllerAnimated(true, completion: { () -> Void in
                if (self.delegate as! EditGameTableViewController).titleTextField.text.isEmpty {
                    (self.delegate as! EditGameTableViewController).saveButton.enabled = false
                } else {
                    (self.delegate as! EditGameTableViewController).saveButton.enabled = true
                }
            })
        } else if delegate.isKindOfClass(AddGameTableViewController) {
            (delegate as! AddGameTableViewController).thumbnail = data[selectedIndexPath!.row]
            (delegate as! AddGameTableViewController).addImageButton.setImage(UIImage(data: data[selectedIndexPath!.row].data), forState: UIControlState.Normal)
            (delegate as! AddGameTableViewController).addImageButton.accessibilityIdentifier = data[selectedIndexPath!.row].title
            
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: Methods
    func reloadData() {
        data = Thumbnail.allThumbnails() as! [Thumbnail]
        
        collectionView?.performBatchUpdates({ () -> Void in
            collectionView?.reloadSections(NSIndexSet(index: 0))
            }, completion: { (completed: Bool) -> Void in
                collectionView?.reloadData()
        })
        
        if data.count == 0 {
            chooseButton.enabled = false
        }
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
        var cell = collectionView.cellForItemAtIndexPath(indexPath)
        
        var selectionImage = cell?.viewWithTag(2) as! UIImageView
        selectionImage.hidden = false
        
        chooseButton.enabled = true
        selectedIndexPath = indexPath
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        var cell = collectionView.cellForItemAtIndexPath(indexPath)
        
        var selectionImage = cell?.viewWithTag(2) as! UIImageView
        selectionImage.hidden = true
        
        selectedIndexPath = nil
        chooseButton.enabled = false
    }
}
