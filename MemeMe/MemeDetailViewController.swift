//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Kevin Murray on 5/22/15.
//  Copyright (c) 2015 Kevin Murray. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
  
  var meme : Meme!
  var detailImage : UIImage!

  // Outlet for image view
  @IBOutlet weak var memeDetailImage: UIImageView!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    // Hide Tab View Controller
    self.tabBarController?.tabBar.hidden = true
    
    // Set image to be displayed
    var image = meme.memedImage
    memeDetailImage.image = image;
    self.view.addSubview(memeDetailImage)
    
  }
  
  override func viewWillDisappear(animated: Bool) {
    
    // DISPLAY Tab View Controller
    super.viewWillDisappear(animated)
    self.tabBarController?.tabBar.hidden = false
  }
}