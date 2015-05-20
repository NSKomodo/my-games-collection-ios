//
//  EditGameTableViewController.swift
//  My Games iOS
//
//  Created by Jorge Tapia on 5/18/15.
//  Copyright (c) 2015 JORGETAPIA.NET. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreData

class EditGameTableViewController: UITableViewController, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var addImageButton: UIButton!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var publisherTextField: UITextField!
    @IBOutlet weak var modesTextField: UITextField!
    
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var platformLabel: UILabel!
    
    @IBOutlet weak var buyTextField: UITextField!
    
    @IBOutlet weak var descTextView: UITextView!

    weak var delegate: DetailTableViewController!
    var thumbnail: Thumbnail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: "resignOnTap")
        singleTapRecognizer.numberOfTapsRequired = 1
        singleTapRecognizer.numberOfTapsRequired = 1
        singleTapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(singleTapRecognizer)
        
        clearsSelectionOnViewWillAppear = true
        
        // Populate data
        addImageButton.setImage(UIImage(data: delegate.game.thumbnail.data), forState: UIControlState.Normal)
        
        titleTextField.text = delegate.game.title
        publisherTextField.text = delegate.game.publisher
        modesTextField.text = delegate.game.modes
        
        genreLabel.text = delegate.game.genre.title
        platformLabel.text = delegate.game.platform.title
        
        buyTextField.text = delegate.game.buy
        
        descTextView.text = delegate.game.desc
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func pickImageAction(sender: AnyObject) {
        var actionSheet: UIActionSheet = UIActionSheet()
        actionSheet.delegate = self
        actionSheet.cancelButtonIndex = 0
        actionSheet.addButtonWithTitle("Cancel")
        actionSheet.addButtonWithTitle("Take Photo")
        actionSheet.addButtonWithTitle("From Photo Library")
        actionSheet.addButtonWithTitle("Existing Thumbnail")
        actionSheet.showInView(self.view)
    }

    // MARK: Actions
    @IBAction func cancelAction(sender: AnyObject) {
        if thumbnail != nil {
            Thumbnail.remove(thumbnail!)
        }
        
        resignOnTap()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        if titleTextField.text.isEmpty {
            titleTextField.becomeFirstResponder()
            titleTextField.placeholder = "Title is required"
            
            return
        }
        
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if thumbnail != nil {
            delegate.game.thumbnail = thumbnail!
        }
        
        delegate.game.title = titleTextField.text
        delegate.title = titleTextField.text
        delegate.game.publisher = publisherTextField.text
        delegate.game.modes = !modesTextField.text.isEmpty ? modesTextField.text.stringByReplacingOccurrencesOfString(",", withString: "\n", options: NSStringCompareOptions.LiteralSearch, range: nil) : String()
        
        delegate.game.genre = Genre.genreWithTitle(genreLabel.text!)!
        delegate.game.platform = Platform.platformWithTitle(platformLabel.text!)!
        
        delegate.game.buy = buyTextField.text
        
        delegate.game.desc = descTextView.text
        
        appDelegate.saveContext()
        
        delegate.reloadData()
        resignOnTap()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Methods:
    func resignOnTap() {
        view.endEditing(true)
    }
    
    // MARK: Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 2 {
                performSegueWithIdentifier("chooseGenreSegue", sender: self)
            } else if indexPath.row == 3 {
                performSegueWithIdentifier("choosePlatformSegue", sender: self)
            }
        }
    }
    
    // MARK: Text field delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    // MARK: Action sheet delegate
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
            UIAlertView(title: "My Game Collection", message: "TODO: Choose Existing Thumbnail", delegate: nil, cancelButtonTitle: "Dismiss").show()
        }
    }
    
    // MARK: Image picker controller delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var managedObjectContext = appDelegate.managedObjectContext
        
        var photoTaken = info[UIImagePickerControllerEditedImage] != nil ? info[UIImagePickerControllerEditedImage] as! UIImage : info[UIImagePickerControllerOriginalImage] as! UIImage
        
        var thumbnailEntity = NSEntityDescription.entityForName("Thumbnail", inManagedObjectContext: managedObjectContext!)
        
        var newThumbnail = Thumbnail(entity: thumbnailEntity!, insertIntoManagedObjectContext: managedObjectContext!)
        newThumbnail.title = titleTextField.text
        newThumbnail.data = UIImagePNGRepresentation(photoTaken)
        
        appDelegate.saveContext()
        
        thumbnail = newThumbnail
        
        appDelegate.saveContext()
        addImageButton.setImage(UIImage(data: newThumbnail.data), forState: UIControlState.Normal)
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "chooseGenreSegue" {
            var genreChooserNavigationController = segue.destinationViewController as! UINavigationController
            var genreChooserTableViewController = genreChooserNavigationController.topViewController as! GenreChooserTableViewController
            
            genreChooserTableViewController.delegate = self
        } else if segue.identifier == "choosePlatformSegue" {
            var platformChooserNavigationController = segue.destinationViewController as! UINavigationController
            var platformChooserTableViewController = platformChooserNavigationController.topViewController as! PlatformChooserTableViewController
            
            platformChooserTableViewController.delegate = self
        }
    }
}
