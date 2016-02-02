/*
 * "Hello Swift, Goodbye Obj-C."
 * Converted by 'objc2swift'
 *
 * https://github.com/yahoojapan/objc2swift
 */

class SubmitViewController: UIViewController {
    @IBOutlet private weak var submitTextView: UITextView!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var dockViewHeightConstraint: NSLayoutConstraint!
    private var imagePickerController: QBImagePickerController {
    private   if !_imagePickerController {
    private     _imagePickerController = QBImagePickerController.new()
    private     _imagePickerController.delegate = self
    private     _imagePickerController.allowsMultipleSelection = true
    private     _imagePickerController.maximumNumberOfSelection = 4
    private }
    private return _imagePickerController
    private }
    private var imagePreviewView: ImagePreviewView
    @IBOutlet private weak var scrollView: UIScrollView!
    
    func viewDidLoad() {
        super.viewDidLoad()
        self.imagePreviewView = ImagePreviewView(frame: self.scrollView.bounds)
        self.imagePreviewView.delegate = self
        self.imagePreviewView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.imagePreviewView)
        self.scrollView.addConstraint(NSLayoutConstraint.constraintWithItem(self.imagePreviewView, attribute: NSLayoutAttributeTrailing, relatedBy: NSLayoutRelationEqual, toItem: self.scrollView, attribute: NSLayoutAttributeTrailing, multiplier: 1.0f, constant: 0))
        self.scrollView.addConstraint(NSLayoutConstraint.constraintWithItem(self.imagePreviewView, attribute: NSLayoutAttributeLeading, relatedBy: NSLayoutRelationEqual, toItem: self.scrollView, attribute: NSLayoutAttributeLeading, multiplier: 1.0f, constant: 0))
        self.scrollView.addConstraint(NSLayoutConstraint.constraintWithItem(self.imagePreviewView, attribute: NSLayoutAttributeTop, relatedBy: NSLayoutRelationEqual, toItem: self.scrollView, attribute: NSLayoutAttributeTop, multiplier: 1.0f, constant: 0))
        self.scrollView.addConstraint(NSLayoutConstraint.constraintWithItem(self.imagePreviewView, attribute: NSLayoutAttributeBottom, relatedBy: NSLayoutRelationEqual, toItem: self.scrollView, attribute: NSLayoutAttributeBottom, multiplier: 1.0f, constant: 0))
        var notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "showKeyboard:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "hideKeyboard:", name: UIKeyboardWillHideNotification, object: nil)
        self.submitTextView.becomeFirstResponder()
    }
    
    func viewDidLayoutSubviews() {
        self.imagePreviewView.setLayoutHeight(self.scrollView.bounds.size.height)
        self.resizePreview()
    }
    
    @IBAction func unwindtoSubmit(segue: UIStoryboardSegue) {
        print("SubmitView retun action")
    }
    
    func showKeyboard(notification: NSNotification) {
        var keyboardRect = notification.userInfo[UIKeyboardFrameEndUserInfoKey].CGRectValue()
        UIView.animateWithDuration(0.01, animations: { 
            self.dockViewHeightConstraint.constant = keyboardRect.size.height + 60
            self.view.layoutIfNeeded()
        })
    }
    
    func hideKeyboard(notification: NSNotification) {
        UIView.animateWithDuration(0.01, animations: { 
            self.dockViewHeightConstraint.constant = 60
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func changePhoto(sender: AnyObject) {
        self.presentViewController(self.imagePickerController, animated: true, completion: nil)
    }
    
    func reloadPreview() {
        self.imagePickerController.selectedAssets.array.enumerateObjectsUsingBlock({ (asset: PHAsset, idx: UInt, stop: Bool) in
            var imageView = self.imagePreviewView.viewWithTag(idx + 11) as! UIImageView
            var manager = PHImageManager.defaultManager()
            var options = PHImageRequestOptions.new()
            options.resizeMode = PHImageRequestOptionsResizeModeExact
            options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic
            manager.requestImageForAsset(asset, targetSize: imageView.bounds.size, contentMode: PHImageContentModeAspectFit, options: options, resultHandler: { (result: UIImage, info: [AnyObject: AnyObject]) in imageView.image = result })
        })
    }
    
    func resizePreview() {
        var size = self.imagePreviewView.viewWithTag(1).bounds.size
        if self.imagePickerController.selectedAssets.count < 2 {
            self.scrollView.contentSize = self.scrollView.bounds.size
        } else {
            size.width = size.width * self.imagePickerController.selectedAssets.count
            self.scrollView.contentSize = size
        }
    }
    
    func qb_imagePickerController(imagePickerController: QBImagePickerController, didFinishPickingAssets assets: [AnyObject]) {
        print("\(assets)")
        var manager = PHImageManager.defaultManager()
        assets.enumerateObjectsUsingBlock({ (obj: PHAsset, idx: UInt, stop: Bool) in
            print("\(idx)回目のしこしこ")
            var view = self.imagePreviewView.viewWithTag(idx + 1)
            var imageview = self.imagePreviewView.viewWithTag(idx + 11) as! UIImageView
            view.hidden = false
            var options = PHImageRequestOptions.new()
            options.resizeMode = PHImageRequestOptionsResizeModeExact
            options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic
            manager.requestImageForAsset(obj, targetSize: self.imagePreviewView.viewWithTag(1).bounds.size, contentMode: PHImageContentModeAspectFit, options: options, resultHandler: { (result: UIImage, info: [AnyObject: AnyObject]) in imageview.image = result })
        })
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func qb_imagePickerControllerDidCancel(imagePickerController: QBImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func deleteImage(selectedINndex: Int) {
        var lastView = self.imagePreviewView.viewWithTag(self.imagePickerController.selectedAssets.count)
        var lastImageView = self.imagePreviewView.viewWithTag(self.imagePickerController.selectedAssets.count + 10) as! UIImageView
        self.imagePickerController.selectedAssets.removeObjectAtIndex(selectedINndex)
        lastImageView.image = nil
        lastView.hidden = true
        self.reloadPreview()
        self.resizePreview()
    }
    
    @IBAction func sendButtonTap(sender: AnyObject) {
        print("ジコマン押した")
        var ichizen = PFObject.objectWithClassName("Ichizen")
        ichizen["text"] = self.submitTextView.text
        if self.imagePickerController.selectedAssets.count > 0 {
            var manager = PHImageManager.defaultManager()
            self.imagePickerController.selectedAssets.enumerateObjectsUsingBlock({ (obj: PHAsset, idx: UInt, stop: Bool) in
                manager.requestImageDataForAsset(obj, options: nil, resultHandler: { (imageData: NSData, dataUTI: String, orientation: UIImageOrientation, info: [AnyObject: AnyObject]) in
                    var imageFile = PFFile.fileWithName("img\(idx + 1)", data: imageData)
                    ichizen["Img\(idx + 1)"] = imageFile
                    if idx + 1 == self.imagePickerController.selectedAssets.count {
                        print("最後？")
                        print("text　Parseに投げれたぜ！")
                        ichizen.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError) in
                            if !succeeded {
                                print("投稿失敗。 \(error)")
                            } else {
                                print("投稿成功")
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                        })
                    }
                })
            })
        } else {
            ichizen.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError) in
                if !succeeded {
                    print("投稿失敗。 \(error)")
                } else {
                    print("投稿成功")
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        }
    }
}

private extension SubmitViewController: QBImagePickerControllerDelegate, ImagePreviewViewDelegate {
}
