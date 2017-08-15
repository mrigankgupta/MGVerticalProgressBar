//
//  VerticalProgressView.swift
//  PicturePuzzle
//
//  Created by Gupta, Mrigank on 27/07/17.
//  Copyright © 2017 Gupta, Mrigank. All rights reserved.
//

import Foundation
import UIKit

class VerticalProgressView: UIView {
    fileprivate var progressLayer: CAShapeLayer?
    private var textLayer: CATextLayer?
    private var innerProgress: Float = 0.5 {
        didSet {
            if let progressLayer = progressLayer {
                animateLayer(progressLayer, with: bounds)
            }
        }
    }
    
    public var insetX: Float = 2.0 {
        didSet {
            if let progressLayer = progressLayer {
                progressLayer.path = getRectangularBezierPath(forRect: bounds, progress: progress, insetX: insetX, insetY: insetY, cornerRadius: cornerRadius).cgPath
            }
        }
    }
    
    public var insetY: Float = 2.0 {
        didSet {
            if let progressLayer = progressLayer {
                progressLayer.path = getRectangularBezierPath(forRect: bounds, progress: progress, insetX: insetX, insetY: insetY, cornerRadius: cornerRadius).cgPath
            }
        }
    }
    
    public var cornerRadius: Float = 4.0 {
        didSet {
            layer.cornerRadius = CGFloat(cornerRadius)
        }
    }
    
    public var progress: Float {
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
    
    public var trackImage: UIImage? {
        didSet {
            layer.contents = trackImage?.cgImage
            layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    public var fillImage: UIImage? {
        didSet {
            progressLayer?.contents = fillImage?.cgImage
            progressLayer?.fillColor = UIColor.clear.cgColor
        }
    }
    
    public var trackColor = UIColor.gray {
        didSet {
            layer.backgroundColor = trackColor.cgColor
        }
    }
    
    public var fillColor = UIColor.blue {
        didSet {
            progressLayer?.fillColor = fillColor.cgColor
        }
    }
    
    public var percentText = "" {
        didSet {
            if let textLayer = textLayer {
                textLayer.string = percentText
            }
        }
    }
    
    public var fontSize:Float = 10.0 {
        didSet {
            if let textLayer = textLayer {
                textLayer.fontSize = CGFloat(fontSize)
            }
        }
    }
    
    public var fontColor:CGColor = UIColor.white.cgColor {
        didSet {
            if let textLayer = textLayer {
                textLayer.foregroundColor = fontColor
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createTrackBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createTrackBar()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if progressLayer == nil {
            progressLayer = createProgressLayer(bounds)
            layer.addSublayer(progressLayer!)
        }
        if textLayer == nil && progressLayer != nil {
            textLayer = createTextLayer(bounds)
            layer.addSublayer(textLayer!)
        }
    }
    
    public func layerProperties() {
        layer.cornerRadius = CGFloat(cornerRadius)
        layer.masksToBounds = true
    }
    
    private func createTrackBar() {
        layerProperties()
        layer.backgroundColor = trackColor.cgColor
    }
    
    private func createProgressLayer(_ rect:CGRect) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = rect
        let bezier = getRectangularBezierPath(forRect: rect, progress: progress, insetX: insetX, insetY: insetY, cornerRadius: cornerRadius)
        layer.path = bezier.cgPath
        layer.fillColor = fillColor.cgColor
        return layer
    }
    
    private func createTextLayer(_ rect:CGRect) -> CATextLayer {
        let layer = CATextLayer()
        let fullRectInset = rect.insetBy(dx: CGFloat(insetX), dy: CGFloat(insetY))
        let textRect = CGRect(x: fullRectInset.origin.x, y: fullRectInset.origin.y + fullRectInset.size.height - fullRectInset.size.width, width: fullRectInset.size.width, height: fullRectInset.size.width)
        layer.frame = textRect
        layer.alignmentMode = kCAAlignmentCenter
        layer.isWrapped = true
        layer.fontSize = 10
        return layer
    }

    private func animateLayer(_ layer:CAShapeLayer, with rect:CGRect) {
        let basicAnimation = CABasicAnimation(keyPath: "path")
        let currentPresentationLayer = layer.presentation()
        if let oldBezierPath = currentPresentationLayer?.path {
            let finalBezeirPath = getRectangularBezierPath(forRect: rect, progress: progress, insetX: insetX, insetY: insetY, cornerRadius: cornerRadius)
            basicAnimation.fromValue = oldBezierPath
            basicAnimation.toValue = finalBezeirPath.cgPath
            basicAnimation.duration = 2.0
            basicAnimation.fillMode = kCAFillModeBoth
            basicAnimation.delegate = self
            layer.path = finalBezeirPath.cgPath
            layer.add(basicAnimation, forKey: "progress")
        }
    }
    
    private func getRectangularBezierPath(forRect rect:CGRect, progress:Float, insetX:Float, insetY:Float, cornerRadius:Float) -> UIBezierPath {
        let fullRectInset = rect.insetBy(dx: CGFloat(insetX), dy: CGFloat(insetY))
        let progressHeight = fullRectInset.size.height*CGFloat(progress)
        let progressRect = CGRect(x: fullRectInset.origin.x, y: fullRectInset.origin.y + fullRectInset.size.height - progressHeight, width: fullRectInset.size.width, height: progressHeight)
        return UIBezierPath(roundedRect: progressRect, cornerRadius: CGFloat(cornerRadius))
    }
}

extension VerticalProgressView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    }
}
