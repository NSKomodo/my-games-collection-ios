//
//  GenreChooserTableViewController.swift
//  My Games iOS
//
//  Created by Jorge Tapia on 5/19/15.
//  Copyright (c) 2015 JORGETAPIA.NET. All rights reserved.
//

import UIKit

class GenreChooserTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var chooseButton: UIBarButtonItem!
    
    var selectedIndexPath: NSIndexPath?
    var data = Genre.allGenres() as! [Genre]
    
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
    @IBAction func chooseAction(sender: AnyObject) {
        
    }
    
    func addAction() {
        println("New Genre: \(genreTitleTextField.text)")
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
