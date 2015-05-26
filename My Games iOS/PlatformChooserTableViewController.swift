//
//  PlatformChooserTableViewController.swift
//  My Games iOS
//
//  Created by Jorge Tapia on 5/20/15.
//  Copyright (c) 2015 JORGETAPIA.NET. All rights reserved.
//

import UIKit
import CoreData

class PlatformChooserTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var chooseButton: UIBarButtonItem!
    
    var selectedIndexPath: NSIndexPath?
    var data = Platform.allPlatforms() as! [Platform]
    
    weak var delegate: AnyObject?
    
    var platformTitleTextField: UITextField!
    var addPlatformButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: "resignOnTap")
        singleTapRecognizer.numberOfTapsRequired = 1
        singleTapRecognizer.numberOfTapsRequired = 1
        singleTapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(singleTapRecognizer)
        
        chooseButton.enabled = false
        
        clearsSelectionOnViewWillAppear = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Actions
    @IBAction func cancelAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func chooseAction(sender: AnyObject) {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if self.delegate!.isKindOfClass(EditGameTableViewController) {
            if (delegate as! EditGameTableViewController).delegate.game.platform != data[selectedIndexPath!.row] {
                if (delegate as! EditGameTableViewController).titleTextField.text.isEmpty {
                    (delegate as! EditGameTableViewController).saveButton.enabled = false
                } else {
                    (delegate as! EditGameTableViewController).saveButton.enabled = true
                }
            }
        }
        
        appDelegate.saveContext()
        
        dismissViewControllerAnimated(true, completion: { () -> Void in
            if self.delegate!.isKindOfClass(EditGameTableViewController) {
                (self.delegate as! EditGameTableViewController).platformLabel.text = self.data[self.selectedIndexPath!.row].title
            } else if self.delegate!.isKindOfClass(AddGameTableViewController) {
                (self.delegate as! AddGameTableViewController).platformLabel.text = self.data[self.selectedIndexPath!.row].title
            }
        })
    }
    
    func addAction() {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var managedObjectContext = appDelegate.managedObjectContext
        
        var platformEntity = NSEntityDescription.entityForName("Platform", inManagedObjectContext: managedObjectContext!)
        
        var newPlatform = Platform(entity: platformEntity!, insertIntoManagedObjectContext: managedObjectContext)
        newPlatform.title = platformTitleTextField.text
        
        appDelegate.saveContext()
        
        for var i = 0; i < tableView.numberOfRowsInSection(1); i++ {
            var indexPath = NSIndexPath(forRow: i, inSection: 1)
            
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        selectedIndexPath = nil
        
        data = Platform.allPlatforms() as! [Platform]
        tableView.reloadData()
        
        platformTitleTextField.text = String()
        view.endEditing(true)
    }
    
    func validateTitle() {
        addPlatformButton.enabled = !platformTitleTextField.text.isEmpty
    }
    
    // MARK: Methods
    func resignOnTap() {
        view.endEditing(true)
    }
    
    // MARK: Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return data.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCellWithIdentifier("NewPlatformCell") as! UITableViewCell
            
            platformTitleTextField = cell.viewWithTag(1) as! UITextField
            platformTitleTextField.delegate = self
            platformTitleTextField.addTarget(self, action: "validateTitle", forControlEvents: UIControlEvents.EditingChanged)
            
            addPlatformButton = cell.viewWithTag(2) as! UIButton
            addPlatformButton.addTarget(self, action: "addAction", forControlEvents: UIControlEvents.TouchUpInside)
            addPlatformButton.enabled = false
            
            return cell
        } else {
            var platform = data[indexPath.row]
            
            var cell = tableView.dequeueReusableCellWithIdentifier("PlatformCell") as! UITableViewCell
            cell.textLabel?.text = platform.title
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Add New Platform"
        } else if section == 1 {
            return Platform.allPlatforms()?.count > 0 ? "Choose Existing" : nil
        } else {
            return nil
        }
    }
    
    // MARK: Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            if selectedIndexPath != nil {
                tableView.cellForRowAtIndexPath(selectedIndexPath!)?.accessoryType = UITableViewCellAccessoryType.None
                tableView.deselectRowAtIndexPath(selectedIndexPath!, animated: true)
            }
            
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            
            selectedIndexPath = indexPath
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            chooseButton.enabled = true
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        cell?.accessoryType = UITableViewCellAccessoryType.None
        
        selectedIndexPath = nil
        chooseButton.enabled = false
    }
    
    // MARK: Text field delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        
        return true
    }
    
}
