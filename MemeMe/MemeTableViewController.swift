//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Kevin Murray on 5/19/15.
//  Copyright (c) 2015 Kevin Murray. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  var memes: [Meme]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib
    
    // Get shared memes from array of saved items in delegate
    let object = UIApplication.sharedApplication().delegate
    let appDelegate = object as! AppDelegate
    memes = appDelegate.memes
  }

  // Table View Delegate
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return memes.count
  }
  
  // display image of each shared meme as part of the table/list view
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
    let memeItem = self.memes[indexPath.row]
    
    cell.textLabel?.text = memeItem.topText
    cell.imageView?.image = memeItem.memedImage
    
    return cell
  }
  
  // determine which meme item was selected and then segue to detailed meme controller to display the meme that was selected
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailView") as! MemeDetailViewController
    detailController.meme = self.memes[indexPath.row]
    self.navigationController!.pushViewController(detailController, animated: true)

  }
  
}


