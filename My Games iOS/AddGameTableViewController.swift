//
//  AddGameTableViewController.swift
//  My Games iOS
//
//  Created by Jorge Tapia on 5/18/15.
//  Copyright (c) 2015 JORGETAPIA.NET. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreData

class AddGameTableViewController: UITableViewController, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var addImageButton: UIButton!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var publisherTextField: UITextField!
    @IBOutlet weak var modesTextField: UITextField!
    
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var platformLabel: UILabel!
    
    @IBOutlet weak var buyTextField: UITextField!
    
    @IBOutlet weak var descTextView: UITextView!
    
    weak var delegate: MasterTableViewController!
    var thumbnail: Thumbnail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: "resignOnTap")
        singleTapRecognizer.numberOfTapsRequired = 1
        singleTapRecognizer.numberOfTapsRequired = 1
        singleTapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(singleTapRecognizer)
        
        clearsSelectionOnViewWillAppear = true
        
        addImageButton.accessibilityIdentifier = "add_image"
        saveButton.enabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Actions
    @IBAction func cancelAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func saveAction(sender: AnyObject) {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        
        var gameEntity = NSEntityDescription.entityForName("Game", inManagedObjectContext: managedObjectContext!)
        var newGame = Game(entity: gameEntity!, insertIntoManagedObjectContext: managedObjectContext)
        
        if addImageButton.accessibilityIdentifier == "add_image" {
            var defaultThumbnail = Thumbnail.thumbnailWithTitle("default_image")
            
            if defaultThumbnail != nil {
                newGame.thumbnail = defaultThumbnail!
            } else {
                let defaultImageData = UIImagePNGRepresentation(UIImage(named: "default_image"))
                
                var thumbnailEntity = NSEntityDescription.entityForName("Thumbnail", inManagedObjectContext: managedObjectContext!)
                defaultThumbnail = Thumbnail(entity: thumbnailEntity!, insertIntoManagedObjectContext: managedObjectContext)
                defaultThumbnail?.title = "default_image"
                defaultThumbnail?.data = defaultImageData
                
                appDelegate.saveContext()
            }
            
            newGame.thumbnail = defaultThumbnail!
        } else {
            newGame.thumbnail = thumbnail!
        }
        
        // Verify if genres exist, if not, creates a default
        var defaultGenre = Genre.genreWithTitle("No Genre")
        
        if defaultGenre == nil {
            var genreEntity = NSEntityDescription.entityForName("Genre", inManagedObjectContext: managedObjectContext!)
            defaultGenre = Genre(entity: genreEntity!, insertIntoManagedObjectContext: managedObjectContext)
            defaultGenre?.title = "No Genre"
            
            appDelegate.saveContext()
        }
        
        // Verify if platform exist, if not, creates a default
        var defaultPlatform = Platform.platformWithTitle("No Platform")
        
        if defaultPlatform == nil {
            var platformEntity = NSEntityDescription.entityForName("Platform", inManagedObjectContext: managedObjectContext!)
            defaultPlatform = Platform(entity: platformEntity!, insertIntoManagedObjectContext: managedObjectContext)
            defaultPlatform?.title = "No Platform"
            
            appDelegate.saveContext()
        }
        
        newGame.title = titleTextField.text
        newGame.publisher = publisherTextField.text
        newGame.modes = !modesTextField.text.isEmpty ? modesTextField.text.stringByReplacingOccurrencesOfString(",", withString: "\n", options: NSStringCompareOptions.LiteralSearch, range: nil) : String()
        
        newGame.genre = genreLabel.text! == "Choose Genre" ? defaultGenre! : Genre.genreWithTitle(genreLabel.text!)!
        newGame.platform = platformLabel.text! == "Choose Platform" ? defaultPlatform! : Platform.platformWithTitle(platformLabel.text!)!
        
        newGame.buy = buyTextField.text
        
        newGame.desc = descTextView.text
        
        appDelegate.saveContext()
        delegate.reloadData()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addImageAction(sender: AnyObject) {
        var actionSheet: UIActionSheet = UIActionSheet()
        actionSheet.delegate = self
        actionSheet.cancelButtonIndex = 0
        actionSheet.addButtonWithTitle("Cancel")
        actionSheet.addButtonWithTitle("Take Photo")
        actionSheet.addButtonWithTitle("From Photo Library")
        
        if Thumbnail.allThumbnails()?.count > 0 {
            actionSheet.addButtonWithTitle("Existing Thumbnail")
        }
        
        actionSheet.showInView(self.view)
    }
    
    @IBAction func textEditingChanged(sender: AnyObject) {
        if (sender as! UITextField).text.isEmpty {
            saveButton.enabled = false
        } else {
            saveButton.enabled = true
        }
    }
    
    // MARK: Methods:
    func resignOnTap() {
        view.endEditing(true)
    }
    
    // MARK: Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 2 {
                performSegueWithIdentifier("chooseGenreFromAddSegue", sender: self)
            } else if indexPath.row == 3 {
                performSegueWithIdentifier("choosePlatformFromAddSegue", sender: self)
            }
        }
    }
    
    // Text field delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == titleTextField {
            titleTextField.resignFirstResponder()
            publisherTextField.becomeFirstResponder()
        } else if textField == publisherTextField {
            publisherTextField.resignFirstResponder()
            modesTextField.becomeFirstResponder()
        } else if textField == modesTextField {
            modesTextField.resignFirstResponder()
            buyTextField.becomeFirstResponder()
        } else if textField == buyTextField {
            buyTextField.resignFirstResponder()
            descTextView.becomeFirstResponder()
        }
        
        return true
    }
    
    // Action sheet delegate
    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            // Simulator handler
            if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                UIAlertView(title: "My Game Collection", message: "It is not possible to take photos using the iOS Simulator.", delegate: nil, cancelButtonTitle: "Dismiss").show()
                
                return
            }
            
            // Take Photo
            let imagePickerController = UIImagePickerController()
            
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
            imagePickerController.mediaTypes = [kUTTypeImage]
            imagePickerController.allowsEditing = true
            
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        } else if buttonIndex == 2 {
            // Choose Photo
            let imagePickerController = UIImagePickerController()
            
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePickerController.mediaTypes = [kUTTypeImage]
            imagePickerController.allowsEditing = true
            
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        } else if buttonIndex == 3 {
            performSegueWithIdentifier("chooseThumbnailFromAddSegue", sender: self)
        }
    }
    
    // Image picker controller delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if thumbnail != nil {
            Thumbnail.remove(thumbnail!)
        }
        
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var managedObjectContext = appDelegate.managedObjectContext
        
        var photoTaken = info[UIImagePickerControllerEditedImage] != nil ? info[UIImagePickerControllerEditedImage] as! UIImage : info[UIImagePickerControllerOriginalImage] as! UIImage
        
        var thumbnailEntity = NSEntityDescription.entityForName("Thumbnail", inManagedObjectContext: managedObjectContext!)
        
        var newThumbnail = Thumbnail(entity: thumbnailEntity!, insertIntoManagedObjectContext: managedObjectContext!)
        
        let thumbnailTitle = "new_game_\((Thumbnail.allThumbnails()?.count)! + 1)"
        
        newThumbnail.title = thumbnailTitle
        newThumbnail.data = UIImagePNGRepresentation(photoTaken)
        
        appDelegate.saveContext()
        
        thumbnail = newThumbnail
        
        addImageButton.accessibilityIdentifier = thumbnailTitle
        addImageButton.setImage(UIImage(data: newThumbnail.data), forState: UIControlState.Normal)
        addImageButton.accessibilityIdentifier = thumbnailTitle
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "chooseGenreFromAddSegue" {
            var genreChooserNavigationController = segue.destinationViewController as! UINavigationController
            var genreChooserTableViewController = genreChooserNavigationController.topViewController as! GenreChooserTableViewController
            
            genreChooserTableViewController.delegate = self
        } else if segue.identifier == "choosePlatformFromAddSegue" {
            var platformChooserNavigationController = segue.destinationViewController as! UINavigationController
            var platformChooserTableViewController = platformChooserNavigationController.topViewController as! PlatformChooserTableViewController
            
            platformChooserTableViewController.delegate = self
        } else if segue.identifier == "chooseThumbnailFromAddSegue" {
            var thumbnailChooserNavigationController = segue.destinationViewController as! UINavigationController
            var thumbnailChooserCollectionViewController = thumbnailChooserNavigationController.topViewController as! ThumbnailChooserCollectionViewController
            
            thumbnailChooserCollectionViewController.delegate = self
        }
    }
}
