//
//  Canvas.swift
//  ColorPixel
//
//  Created by Chung-Sama on 2018/01/06.
//  Copyright © 2018 Chung-Sama. All rights reserved.
//

import UIKit

public class Canvas: UIView {
    
    class Pixel: UIView {}
//    var pixels: Array<Array<Pixel>>!
    
    var viewModel: CanvasViewModel
    let width: Int
    let height: Int
    let pixelSize: CGFloat
    var pixelsState: [PixelState] = []
    public init(width: Int, height: Int, pixelSize: CGFloat, pixelsState: [PixelState]) {
        self.viewModel = CanvasViewModel()
        self.pixelsState = pixelsState
        self.width = width
        self.height = height
        self.pixelSize = pixelSize
        super.init(frame: CGRect(x: 0, y: 0, width: CGFloat(width) * pixelSize, height: CGFloat(height) * pixelSize))
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        for pixelState in self.pixelsState {
            let pixelCreated = self.createPixel(x: pixelState.x, y: pixelState.y, color: pixelState.color)
//            self.pixels[1].append(pixelCreated)
            addSubview(pixelCreated)
        }
    }
    private func createPixel(x: Int, y: Int, color: UIColor) -> Pixel {
        let pixel = Pixel()
        pixel.frame = CGRect(x: CGFloat(x) * pixelSize,
                             y: CGFloat(y) * pixelSize,
                             width: pixelSize,
                             height: pixelSize)
        pixel.backgroundColor = color
        pixel.layer.borderWidth = 0.5
        pixel.layer.borderColor = UIColor.lightGray.cgColor
        pixel.isUserInteractionEnabled = false
        return pixel
    }
}
