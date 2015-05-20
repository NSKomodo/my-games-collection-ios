//
//  GenreChooserTableViewController.swift
//  My Games iOS
//
//  Created by Jorge Tapia on 5/19/15.
//  Copyright (c) 2015 JORGETAPIA.NET. All rights reserved.
//

import UIKit
import CoreData

class GenreChooserTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var chooseButton: UIBarButtonItem!
    
    var selectedIndexPath: NSIndexPath?
    var data = Genre.allGenres() as! [Genre]
    
    weak var delegate: AnyObject?
    
    var genreTitleTextField: UITextField!
    var addGenreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            if (delegate as! EditGameTableViewController).delegate.game.genre != data[selectedIndexPath!.row] {
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
                (self.delegate as! EditGameTableViewController).genreLabel.text = self.data[self.selectedIndexPath!.row].title
            } else if self.delegate!.isKindOfClass(AddGameTableViewController) {
                (self.delegate as! AddGameTableViewController).genreLabel.text = self.data[self.selectedIndexPath!.row].title
            }
        })
    }
    
    func addAction() {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var managedObjectContext = appDelegate.managedObjectContext
        
        var genreEntity = NSEntityDescription.entityForName("Genre", inManagedObjectContext: managedObjectContext!)
        
        var newGenre = Genre(entity: genreEntity!, insertIntoManagedObjectContext: managedObjectContext)
        newGenre.title = genreTitleTextField.text
        
        appDelegate.saveContext()
        
        for var i = 0; i < tableView.numberOfRowsInSection(1); i++ {
            var indexPath = NSIndexPath(forRow: i, inSection: 1)
            
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        selectedIndexPath = nil
        
        data = Genre.allGenres() as! [Genre]
        tableView.reloadData()
        
        genreTitleTextField.text = String()
        view.endEditing(true)
    }
    
    func validateTitle() {
        addGenreButton.enabled = !genreTitleTextField.text.isEmpty
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
            var cell = tableView.dequeueReusableCellWithIdentifier("NewGenreCell") as! UITableViewCell
            
            genreTitleTextField = cell.viewWithTag(1) as! UITextField
            genreTitleTextField.delegate = self
            genreTitleTextField.addTarget(self, action: "validateTitle", forControlEvents: UIControlEvents.EditingChanged)
            
            addGenreButton = cell.viewWithTag(2) as! UIButton
            addGenreButton.addTarget(self, action: "addAction", forControlEvents: UIControlEvents.TouchUpInside)
            addGenreButton.enabled = false
            
            return cell
        } else {
            var genre = data[indexPath.row]
            
            var cell = tableView.dequeueReusableCellWithIdentifier("GenreCell") as! UITableViewCell
            cell.textLabel?.text = genre.title
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Add New Genre"
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
