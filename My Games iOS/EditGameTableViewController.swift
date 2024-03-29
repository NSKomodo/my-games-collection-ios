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

class EditGameTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
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
    
    var originalTitle: String?
    var originalThumbnail: String?
    var originalPublisher: String?
    var originalModes: String?
    var originalGenre: String?
    var originalPlatform: String?
    var originalBuyLink: String?
    var originalDesc: String?
    
    var modifiedValue = false
    
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
        
        captureOriginalValues()
        saveButton.enabled = false
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
        
        if Thumbnail.allThumbnails()?.count > 0 {
            actionSheet.addButtonWithTitle("Existing Thumbnail")
        }
        
        actionSheet.showInView(self.view)
    }

    // MARK: Actions
    @IBAction func cancelAction(sender: AnyObject) {
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
    
    @IBAction func textEditingChanged(sender: AnyObject) {
        var textField = sender as! UITextField
        
        if textField != titleTextField {
            modifiedValue = true
        }
        
        if titleTextField.text.isEmpty && modifiedValue {
            saveButton.enabled = false
        } else if titleTextField.text.isEmpty && !modifiedValue {
            saveButton.enabled = false
        } else if !titleTextField.text.isEmpty && titleTextField.text == originalTitle && modifiedValue {
            saveButton.enabled = true
        } else if !titleTextField.text.isEmpty && titleTextField.text == originalTitle && !modifiedValue {
            saveButton.enabled = false
        } else if !titleTextField.text.isEmpty && titleTextField.text != originalTitle && modifiedValue {
            saveButton.enabled = true
        } else if !titleTextField.text.isEmpty && titleTextField.text != originalTitle && !modifiedValue {
            saveButton.enabled = true
        } else {
            saveButton.enabled = false
        }
    }
    
    
    // MARK: Methods:
    func captureOriginalValues() {
        originalThumbnail = delegate.game.thumbnail.title
        
        originalTitle = delegate.game.title
        originalPublisher = delegate.game.publisher
        originalModes = delegate.game.modes
        
        originalGenre = delegate.game.genre.title
        originalPlatform = delegate.game.platform.title
        
        originalBuyLink = delegate.game.buy
        
        originalDesc = delegate.game.desc
    }
    
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
    
    // MARK: Text view delegate
    func textViewDidChange(textView: UITextView) {
        
    }
    
    // MARK: Action sheet delegate
    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            // Simulator handler
            if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                UIAlertView(title: "My Games", message: "It is not possible to take photos using the iOS Simulator.", delegate: nil, cancelButtonTitle: "Dismiss").show()
                
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
            performSegueWithIdentifier("chooseThumbnailSegue", sender: self)
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
        
        saveButton.enabled = true
        
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
        } else if segue.identifier == "chooseThumbnailSegue" {
            var thumbnailChooserNavigationController = segue.destinationViewController as! UINavigationController
            var thumbnailChooserCollectionViewController = thumbnailChooserNavigationController.topViewController as! ThumbnailChooserCollectionViewController
            
            thumbnailChooserCollectionViewController.delegate = self
        }
    }
}
