//
//  MGVerticalProgressBar.swift
//  PicturePuzzle
//
//  Created by Gupta, Mrigank on 27/07/17.
//  Copyright © 2017 Gupta, Mrigank. All rights reserved.
//

import Foundation
import UIKit

class MGVerticalProgressBar: UIView {
    fileprivate var progressLayer: CAShapeLayer?
    fileprivate var textLayer: CATextLayer?
    fileprivate var innerImageLayer: CAShapeLayer?
    fileprivate var innerProgress: Float = 0.5 {
        didSet {
            if let progressLayer = progressLayer {
                animateLayer(progressLayer, rect: bounds, progress: progress,
                             insetX: insetX, insetY: insetY, cornerRadius: cornerRadius)
            }
        }
    }
    
    @IBInspectable public var insetX: Float = 2.0 {
        didSet {
            if let progressLayer = progressLayer {
                progressLayer.path = getRectangularBezierPath(forRect: bounds, progress: progress,
                                                              insetX: insetX, insetY: insetY, cornerRadius: cornerRadius).cgPath
            }
        }
    }
    
    @IBInspectable public var insetY: Float = 2.0 {
        didSet {
            if let progressLayer = progressLayer {
                progressLayer.path = getRectangularBezierPath(forRect: bounds, progress: progress,
                                                              insetX: insetX, insetY: insetY, cornerRadius: cornerRadius).cgPath
            }
        }
    }
    
    @IBInspectable public var cornerRadius: Float = 4.0 {
        didSet {
            layer.cornerRadius = CGFloat(cornerRadius)
        }
    }
    
    @IBInspectable public var progress: Float {
        get {
            return innerProgress
        }
        set {
            if newValue > 1.0 {
                innerProgress = 1.0
            }else if newValue < 0.0 {
                innerProgress = 0.0
            }else {
                innerProgress = newValue
            }
        }
    }
    
    @IBInspectable public var trackImage: UIImage? {
        didSet {
            layer.contents = trackImage?.cgImage
            layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    @IBInspectable public var fillImage: UIImage? {
        didSet {
            innerImageLayer?.contents = fillImage?.cgImage
            progressLayer?.fillColor = UIColor.white.cgColor
            innerImageLayer?.mask = progressLayer
            innerImageLayer?.contentsScale = fillImage!.scale
        }
    }
    
    @IBInspectable public var trackColor: UIColor = UIColor.gray {
        didSet {
            if trackImage == nil {
                layer.backgroundColor = trackColor.cgColor
            }
        }
    }
    
    @IBInspectable public var fillColor: UIColor = UIColor.blue {
        didSet {
            if fillImage == nil {
                progressLayer?.fillColor = fillColor.cgColor
            }
        }
    }
    
    @IBInspectable public var fontSize: Float = 10.0 {
        didSet {
            if let textLayer = textLayer {
                textLayer.fontSize = CGFloat(fontSize)
            }
        }
    }
    
    @IBInspectable public var fontColor: UIColor = UIColor.white {
        didSet {
            if let textLayer = textLayer {
                textLayer.foregroundColor = fontColor.cgColor
            }
        }
    }
    
    public var percentText = "" {
        didSet {
            if let textLayer = textLayer {
                textLayer.string = percentText
            }
        }
    }
    
    public func layerProperties() {
        layer.cornerRadius = CGFloat(cornerRadius)
        layer.masksToBounds = cornerRadius > 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTrackBar()
        configureProgressTrack()
        configureTextLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureTrackBar()
        configureProgressTrack()
        configureTextLayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        adjustTextLayer(frame: bounds)
        adjustImageLayer(frame: bounds)
        adjustProgressLayer(frame: bounds)
    }
}

fileprivate extension MGVerticalProgressBar {
    
    func adjustTextLayer(frame:CGRect) {
        textLayer?.frame = getBottomSquareFrame(frame: bounds, insetX: insetX, insetY: insetY)
    }
    
    func adjustProgressLayer(frame:CGRect) {
        progressLayer?.path = getRectangularBezierPath(forRect: bounds, progress: progress,
                                                       insetX: insetX, insetY: insetY, cornerRadius: cornerRadius).cgPath
        progressLayer?.frame = bounds
    }
    
    func adjustImageLayer(frame:CGRect) {
        innerImageLayer?.path = getRectangularBezierPath(forRect: bounds, progress: 1.0,
                                                         insetX: insetX, insetY: insetY, cornerRadius: cornerRadius).cgPath
        innerImageLayer?.frame = bounds
    }

    func configureTrackBar() {
        layerProperties()
        layer.backgroundColor = trackColor.cgColor
    }
    
    func configureProgressTrack() {
        if innerImageLayer == nil {
            innerImageLayer = createInnerLayer(frame: bounds, progress: progress,
                                               insetX: insetX, insetY: insetY, cornerRadius: cornerRadius, fillColor: UIColor.clear)
            innerImageLayer!.contentsScale = UIScreen.main.scale
            layer.addSublayer(innerImageLayer!)
        }
        if progressLayer == nil {
            progressLayer = createInnerLayer(frame: bounds, progress: progress,
                                             insetX: insetX, insetY: insetY, cornerRadius: cornerRadius, fillColor: fillColor)
            progressLayer!.contentsScale = UIScreen.main.scale
            layer.addSublayer(progressLayer!)
        }
    }
    
    func configureTextLayer() {
        if textLayer == nil {
            textLayer = createTextLayer(frame: bounds, insetX: insetX, insetY: insetY)
            textLayer!.contentsScale = UIScreen.main.scale
            layer.addSublayer(textLayer!)
        }
    }
    
    func createInnerLayer(frame:CGRect, progress:Float, insetX:Float, insetY:Float, cornerRadius:Float, fillColor:UIColor)-> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.path = getRectangularBezierPath(forRect: frame, progress: progress,
                                                       insetX: insetX, insetY: insetY, cornerRadius: cornerRadius).cgPath
        layer.fillColor = fillColor.cgColor
        return layer
    }
    
    func createTextLayer(frame:CGRect, insetX:Float, insetY:Float)-> CATextLayer {
        let layer = CATextLayer()
        layer.frame = getBottomSquareFrame(frame: frame, insetX:insetX, insetY:insetY)
        layer.alignmentMode = kCAAlignmentCenter
        layer.isWrapped = true
        return layer
    }
    
    func getBottomSquareFrame(frame:CGRect, insetX:Float, insetY:Float)-> CGRect {
        let fullRectInset = frame.insetBy(dx: CGFloat(insetX), dy: CGFloat(insetY))
        let newFrame = CGRect(x: fullRectInset.origin.x, y: fullRectInset.origin.y + fullRectInset.size.height - fullRectInset.size.width,
                               width: fullRectInset.size.width, height: fullRectInset.size.width)
        return newFrame
    }
    
    func animateLayer(_ layer:CAShapeLayer, rect:CGRect, progress:Float, insetX:Float, insetY:Float, cornerRadius:Float) {
        let basicAnimation = CABasicAnimation(keyPath: "path")
        let currentPresentationLayer = layer.presentation()
        if let oldBezierPath = currentPresentationLayer?.path {
            let finalBezeirPath = getRectangularBezierPath(forRect: rect, progress: progress,
                                                           insetX: insetX, insetY: insetY, cornerRadius: cornerRadius).cgPath
            basicAnimation.fromValue = oldBezierPath
            basicAnimation.toValue = finalBezeirPath
            basicAnimation.duration = 2.0
            basicAnimation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            layer.path = finalBezeirPath
            layer.add(basicAnimation, forKey: "progress")
        }
    }
    
    func getRectangularBezierPath(forRect rect:CGRect, progress:Float, insetX:Float, insetY:Float, cornerRadius:Float)-> UIBezierPath {
        let fullRectInset = rect.insetBy(dx: CGFloat(insetX), dy: CGFloat(insetY))
        let progressHeight = fullRectInset.size.height*CGFloat(progress)
        let progressRect = CGRect(x: fullRectInset.origin.x, y: fullRectInset.origin.y + fullRectInset.size.height - progressHeight,
                                  width: fullRectInset.size.width, height: progressHeight)
        return UIBezierPath(roundedRect: progressRect, cornerRadius: CGFloat(cornerRadius))
    }
}

