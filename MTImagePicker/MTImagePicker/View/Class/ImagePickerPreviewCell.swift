//
//  ImagePickerPreviewCell.swift
//  MTImagePicker
//
//  Created by Luo on 5/24/16.
//  Copyright © 2016 Luo. All rights reserved.
//

import UIKit

class ImagePickerPreviewCell:UICollectionViewCell,UIScrollViewDelegate {
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    weak var controller:MTImagePickerPreviewController?
    private var model:MTImagePickerModel!
    
    
    override func awakeFromNib() {
        scrollview.zoomScale = 1
        scrollview.contentSize = CGSizeZero
        scrollview.delegate = self
        // 支持单击全屏，双击放大
        let singTapGesture = UITapGestureRecognizer(target: self, action: #selector(ImagePickerPreviewCell.onImageSingleTap(_:)))
        singTapGesture.numberOfTapsRequired = 1
        singTapGesture.numberOfTouchesRequired = 1
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(ImagePickerPreviewCell.onImageDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.numberOfTouchesRequired = 1
        singTapGesture.requireGestureRecognizerToFail(doubleTapGesture)
        
        imageView.addGestureRecognizer(singTapGesture)
        imageView.addGestureRecognizer(doubleTapGesture)
    }
    
    override func prepareForReuse() {
        scrollview.zoomScale = 1.0
        imageView.image = nil
    }
    
    
    func initWithModel(model:MTImagePickerModel,controller:MTImagePickerPreviewController) {
        self.model = model
        self.controller = controller
        imageView.image = model.getPreviewImage()
    }
    
    func onImageSingleTap(sender:UITapGestureRecognizer) {
        if let controller = self.controller {
            controller.topView.hidden = !controller.topView.hidden
            controller.bottomView.hidden = !controller.bottomView.hidden
        }
    }
    
    func didEndScroll() {
        self.model.getImageAsync(){
            image in
            self.imageView.image = image
        }
    }
    
    func onImageDoubleTap(sender:UITapGestureRecognizer) {
        let zoomScale = scrollview.zoomScale
        if zoomScale <= 1.0 {
            let loc = sender.locationInView(sender.view) as CGPoint
            let wh:CGFloat = 1
            let x:CGFloat = loc.x - 0.5
            let y:CGFloat = loc.y - 0.5
            let rect = CGRectMake(x, y, wh, wh)
            scrollview.zoomToRect(rect, animated: true)
        } else {
            scrollview.setZoomScale(1.0, animated: true)
        }
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        var xcenter = imageView.center.x
        var ycenter = imageView.center.y
        
        xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter
        
        ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter
        imageView.center = CGPointMake(xcenter, ycenter)
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}


