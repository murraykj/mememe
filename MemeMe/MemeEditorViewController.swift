//
//  MemeEditorViewController.swift
//  Meme Editor
//
//  Created by Kevin Murray on 5/14/15.
//  Copyright (c) 2015 Kevin Murray. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

  // outlets for stroyboard controls
  @IBOutlet weak var imagePickerView: UIImageView!
  @IBOutlet weak var cameraButton: UIBarButtonItem!
  @IBOutlet weak var textFieldTop: UITextField!
  @IBOutlet weak var textFieldBottom: UITextField!
  @IBOutlet weak var shareButton: UIBarButtonItem!
  @IBOutlet weak var topNavigationBar: UINavigationBar!
  @IBOutlet weak var bottomToolbar: UIToolbar!
  
  // set text color and style attributes
  let memeTextAttributes = [
    NSStrokeColorAttributeName : UIColor.blackColor(),
    NSForegroundColorAttributeName : UIColor.whiteColor(),
    NSBackgroundColorAttributeName : UIColor.whiteColor(),
    NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    NSStrokeWidthAttributeName : 3.0
  ]

  
  // Display functions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // set the delegate for the text fields
    self.textFieldTop.delegate = self
    self.textFieldBottom.delegate = self
    
    // Set initial text in text fields
    textFieldTop.text = "Top"
    textFieldBottom.text = "Bottom"
    
    //Set text attributes
    textFieldTop.defaultTextAttributes = memeTextAttributes
    textFieldBottom.defaultTextAttributes = memeTextAttributes
    
    // Set text alignment
    textFieldTop.textAlignment = NSTextAlignment.Center;
    textFieldBottom.textAlignment = NSTextAlignment.Center;
    

  }
  
  override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)
    
      // set button displays
      cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    
    if imagePickerView.image == nil {
      shareButton.enabled = false
    }
    
      // Subscribe to keyboard notifications to allow the view to raise when necessary
      self.subscribeToKeyboardNotifications()
  }

  // Unsubscribe for notifications
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    self.unsubscribeFromKeyboardNotifications()
  }
  
  
  // Image Picker Functions
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      imagePickerView.image = image
      
      shareButton.enabled = true
      
      self.dismissViewControllerAnimated(true, completion: nil)
      
      
    }
  }
  
  // launch controller to pick an image from an album
  @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
    let pickerController = UIImagePickerController()
    pickerController.delegate = self
    pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    self.presentViewController(pickerController, animated: true, completion: nil)
  }
  
  // launch controller to pick by using hte camera to take a picture
  @IBAction func pickAnImageFromCamera(sender: AnyObject) {
    let pickerController = UIImagePickerController()
    pickerController.delegate = self
    pickerController.sourceType = UIImagePickerControllerSourceType.Camera
    self.presentViewController(pickerController, animated: true, completion: nil)
  }
  
  // dismiss controller
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  
  // Text Field Delegate
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    // clear placeholder text when editing begins
    textField.text = nil
    
    return true
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    
    return true;
  }
  
  // Manage notifications from Keyboard
  // subcribe to keyboard functions
  func subscribeToKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
  }
  
  // unsubcribe to keyboard functions when done
  func unsubscribeFromKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().removeObserver(self, name:
      UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name:
      UIKeyboardWillHideNotification, object: nil)
  }
  
  // when keyboard is displayed adjust view up
  func keyboardWillShow(notification: NSNotification) {
    if textFieldBottom.isFirstResponder() {
      self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
  }
  
  // when keyboard is hidden adjust view down
  func keyboardWillHide(notification: NSNotification) {
    if textFieldBottom.isFirstResponder() {
      self.view.frame.origin.y += getKeyboardHeight(notification)
    }
  }
  
  // get height of keyboard to be used in functions above
  func getKeyboardHeight(notification: NSNotification) -> CGFloat {
    let userInfo = notification.userInfo
    let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
    return keyboardSize.CGRectValue().height
  }
  
  
  
  // Create a UIImage for Memed image that combines the Image View and the Text Fields
  func generateMemedImage() -> UIImage
  {
    // Hide the toolbar and Nav bar
    self.topNavigationBar.hidden = true
    self.bottomToolbar.hidden = true
    
    // render view to an image
    UIGraphicsBeginImageContext(self.view.frame.size)
    self.view.drawViewHierarchyInRect(self.view.frame,
      afterScreenUpdates: true)
    let memedImage : UIImage =
    UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    // unhide the toolbar and Nav bar
    self.topNavigationBar.hidden = false
    self.bottomToolbar.hidden = false
    
    return memedImage
  }
  
  
  // Save Meme
  func saveMeme() {
    //Create the meme
    var meme = Meme(topText: textFieldTop.text!, bottomText: textFieldBottom.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
    
    // save the meme to the array by appending it to the end
//    let object = UIApplication.sharedApplication().delegate
//    let appDelegate = object as! AppDelegate
//    appDelegate.memes.append(meme)
    
    // save the meme to the array by appending it to the end - shorter view of above commented out text
    (UIApplication.sharedApplication().delegate as!
    AppDelegate).memes.append(meme)

    println("saving")  // Debug line
    
  }
  
  
  // Share Meme
  @IBAction func shareMeme(sender: AnyObject) {
    
    // create and get Memed image
    let sharedMeme = generateMemedImage()
    
    // display activity controller and pass in Memed image
    let controller = UIActivityViewController(activityItems: [sharedMeme], applicationActivities: nil)
    
    controller.completionWithItemsHandler = {(activity, success, items, error) in
      //Save Meme and then dismiss activity controller after completing activity
      self.saveMeme()
      self.dismissViewControllerAnimated(true, completion: nil)
      
    }
    
    // present the activity controller
    self.presentViewController(controller, animated: true, completion: nil)
    
  }

  // dismiss the activity view controller
  @IBAction func cancel() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
 
}

