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
    
    var viewModel: CanvasViewModel
    let width: Int
    let height: Int
    let pixelSize: CGFloat
    var pixelsState: [PixelState] = []
    
    public var paintBrushColor = UIColor.black
    
    public init(x: CGFloat, y: CGFloat, width: Int, height: Int, pixelSize: CGFloat, pixelsState: [PixelState]) {
        self.viewModel = CanvasViewModel()
        self.pixelsState = pixelsState
        self.width = width
        self.height = height
        self.pixelSize = pixelSize
        super.init(frame: CGRect(x: x, y: y, width: CGFloat(width) * pixelSize, height: CGFloat(height) * pixelSize))
        viewModel.delegate = self
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDrag(sender:)))
        tapGestureRecognizer.delegate = self
        let dragGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleDrag(sender:)))
        dragGestureRecognizer.minimumPressDuration = 0
        addGestureRecognizer(dragGestureRecognizer)
        
        for pixelState in self.pixelsState {
            let pixelCreated = self.createPixel(x: pixelState.x, y: pixelState.y, color: pixelState.color)
            addSubview(pixelCreated)
        }
        isUserInteractionEnabled = true
        isMultipleTouchEnabled = false
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
    
    @objc private func handleDrag(sender: UIGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            draw(atPoint: sender.location(in: self))
            print("Tap \(sender.location(in: self))")
        case .ended:
            draw(atPoint: sender.location(in: self))
            viewModel.endDrawing()
        default: break
        }
    }
    
    private func draw(atPoint point: CGPoint) {
        let y = Int(point.y / pixelSize)
        let x = Int(point.x / pixelSize)
        guard y < height && x < width && y >= 0 && x >= 0 else { return }
        viewModel.drawAt(x: x, y: y, color: paintBrushColor)
    }
}
extension Canvas: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
extension Canvas: CanvasDelegate {
    func colorChanged(newPixelState pixelState: PixelState) {
        print("TapTap")
    }
    
    func clearCanvas() {
        
    }
}
