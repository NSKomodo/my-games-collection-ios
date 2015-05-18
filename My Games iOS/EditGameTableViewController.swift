//
//  EditGameTableViewController.swift
//  My Games iOS
//
//  Created by Jorge Tapia on 5/18/15.
//  Copyright (c) 2015 JORGETAPIA.NET. All rights reserved.
//

import UIKit

class EditGameTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var addImageButton: UIButton!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var publisherTextField: UITextField!
    @IBOutlet weak var modesTextField: UITextField!
    
    @IBOutlet weak var sourceTextField: UITextField!
    @IBOutlet weak var buyTextField: UITextField!
    
    @IBOutlet weak var descTextView: UITextView!

    weak var delegate: DetailTableViewController!
    var firstResponder: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: "resignOnTap")
        singleTapRecognizer.numberOfTapsRequired = 1
        singleTapRecognizer.numberOfTapsRequired = 1
        singleTapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(singleTapRecognizer)
        
        clearsSelectionOnViewWillAppear = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Actions
    @IBAction func cancelAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        delegate.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Methods:
    func resignOnTap() {
        view.endEditing(true)
    }
    
    // Text field delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }

}
