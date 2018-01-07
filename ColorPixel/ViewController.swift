//
//  ViewController.swift
//  ColorPixel
//
//  Created by Chung-Sama on 2018/01/06.
//  Copyright © 2018 Chung-Sama. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    
    fileprivate var pixelView: Canvas?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureZoomSupport()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayImageNamed("google_pixel_phone")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: Rendering
    fileprivate func displayImageNamed(_ imageName: String) {
        displayImage(UIImage(named: imageName)!)
    }
    fileprivate func displayImage(_ image: UIImage) {
        let width = Int(image.size.width)
        let height = Int(image.size.height)
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            
            guard let imagePixelReader = ImagePixelReader(image: image) else { return }
            var pixelsState: [PixelState] = []
            //iterate over all pixels
            for x in 0 ..< width {
                for y in 0 ..< height{
                    let color = imagePixelReader.colorAt(x: x, y: y)
                    let pixelState = PixelState(x: x, y: y, color: color.uiColor)
                    print(pixelState)
                    pixelsState.append(pixelState)
                }
            }
            
            DispatchQueue.main.async {
                self.pixelView = Canvas(x: 0, y: 0, width: width, height: height, pixelSize: 20, pixelsState: pixelsState)
                self.scrollView.contentSize = self.pixelView!.frame.size
                self.scrollView.addSubview(self.pixelView!)
                self.updateZoomSettings(animated: true)
            }
        }
    }
    // MARK: - Zooming support
    
    fileprivate func configureZoomSupport() {
        scrollView.delegate = self
        scrollView.maximumZoomScale = 5
    }
    
    fileprivate func updateZoomSettings(animated: Bool) {
        let
        scrollSize  = scrollView.frame.size,
        contentSize = scrollView.contentSize,
        scaleWidth  = scrollSize.width / contentSize.width,
        scaleHeight = scrollSize.height / contentSize.height,
        scale       = max(scaleWidth, scaleHeight)
        print("\(scaleWidth): \(scaleHeight)")
        scrollView.minimumZoomScale = 0.01
        scrollView.setZoomScale(0.095, animated: animated)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return pixelView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let subView = scrollView.subviews[0] // get the view
        let offsetX = max(Double(scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5,0.0)
        let offsetY = max(Double(scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5,0.0)
        // adjust the center of view
        subView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + CGFloat(offsetX),y: scrollView.contentSize.height * 0.5 + CGFloat(offsetY))
    }
    
}

