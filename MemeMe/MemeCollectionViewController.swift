//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Kevin Murray on 5/21/15.
//  Copyright (c) 2015 Kevin Murray. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  
  @IBOutlet weak var imageView: UIImageView!
  
  var memes: [Meme]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Get shared memes from array of saved items in delegate
    let object = UIApplication.sharedApplication().delegate
    let appDelegate = object as! AppDelegate
    memes = appDelegate.memes
  }

  
  // Table View Delegate
  
  // determine number of meme items in array to be displayed
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return memes.count

  }

  // display image of each shared meme as part of the collection/grid view
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCell", forIndexPath: indexPath) as! MemeCollectionViewCell

    let memeItem = self.memes[indexPath.item]
    
//    cell.setText(memeItem.topText, bottomString:  memeItem.bottomText)
    
    let imageView = UIImageView(image: memeItem.memedImage)
    cell.backgroundView = imageView
    
    return cell
  }

  // determine which meme item was selected and then segue to detailed meme controller to display the meme that was selected
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
    
    let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailView") as! MemeDetailViewController
    detailController.meme = self.memes[indexPath.row]
    self.navigationController!.pushViewController(detailController, animated: true)
    
  }
  
}
