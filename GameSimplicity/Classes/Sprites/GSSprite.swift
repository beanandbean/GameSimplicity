//
//  GSSprite.swift
//  Pods
//
//  Created by wangsw on 05/12/2016.
//
//

import UIKit

public enum GSSpriteEvent {
    case tap, swipeLeft, swipeRight, swipeUp, swipeDown
}

public class GSSprite: GSListenerHandler<GSSpriteEvent> {
    
    public var translateX: CGFloat = 0.0 { didSet { updateTranform() } }
    public var translateY: CGFloat = 0.0 { didSet { updateTranform() } }
    public var translate: CGPoint {
        get {
            return CGPoint(x: translateX, y: translateY)
        }
        set (value) {
            translateX = value.x
            translateY = value.y
        }
    }
    
    public var scaleX: CGFloat = 1.0 { didSet { updateTranform() } }
    public var scaleY: CGFloat = 1.0 { didSet { updateTranform() } }
    public var scale: CGPoint {
        get {
            return CGPoint(x: scaleX, y: scaleY)
        }
        set (value) {
            scaleX = value.x
            scaleY = value.y
        }
    }
    
    public var rotation: CGFloat = 0.0 {
        didSet {
            rotation -= floor(rotation / CGFloat.pi / 2) * CGFloat.pi * 2
            updateTranform()
        }
    }
    
    var anchorTranslateX: CGFloat = 0.0 {
        didSet (old) {
            translateX += old - anchorTranslateX
            updateTranform()
        }
    }
    var anchorTranslateY: CGFloat = 0.0 {
        didSet (old) {
            translateY += old - anchorTranslateY
            updateTranform()
        }
    }
    
    public var anchorX: CGFloat {
        get {
            return translateX
        }
        set (value) {
            anchorTranslateX -= value - translateX
        }
    }
    public var anchorY: CGFloat {
        get {
            return translateY
        }
        set (value) {
            anchorTranslateY -= value - translateY
        }
    }
    public var anchor: CGPoint {
        get {
            return CGPoint(x: anchorX, y: anchorY)
        }
        set (value) {
            anchorX = value.x
            anchorY = value.y
        }
    }
    
    public var alpha: CGFloat = 1.0 {
        didSet {
            view.alpha = alpha
        }
    }
    
    var screenScale: CGFloat = 1.0
    
    public var physicalAnimator: GSPhysicalAnimator!
    
    var defaultViewTransform: CGAffineTransform {
        fatalError("Cannot create view transform for an abstract GSSprite \(self)!")
    }
    
    var userTransform: CGAffineTransform {
        return CGAffineTransform(translationX: translateX * screenScale, y: translateY * screenScale).rotated(by: rotation).translatedBy(x: anchorTranslateX * screenScale, y: anchorTranslateY * screenScale).scaledBy(x: scaleX, y: scaleY)
    }
    
    var finalTransform: CGAffineTransform {
        return defaultViewTransform.concatenating(userTransform)
    }
    
    var rawShapePath: CGPath {
        fatalError("Cannot create tap path for an abstract GSSprite \(self)!")
    }
    
    var shapePath: CGPath {
        var transform = finalTransform
        return withUnsafePointer(to: &transform, { rawShapePath.copy(using: $0) })!
    }
    
    public var bounds: CGRect {
        return shapePath.boundingBoxOfPath
    }
    
    var view: UIView! {
        didSet {
            updateTranform()
        }
    }
    
    public var userInteractionEnabled = true
    
    override init() {
        super.init()
        physicalAnimator = GSPhysicalAnimator(sprite: self)
    }
    
    deinit {
        physicalAnimator.clearPhysicalAnimation()
    }
    
    func updateScale(scale: CGFloat) {
        screenScale = scale
        updateTranform()
    }
    
    func updateTranform() {
        view.layer.anchorPoint = CGPoint.zero
        view.transform = finalTransform
    }
    
    func update(attribute: GSAnimationAttribute, change: CGFloat) {
        switch attribute {
        case .x:
            translateX += change
        case .y:
            translateY += change
        case .scaleX:
            scaleX += change
        case .scaleY:
            scaleY += change
        case .rotation:
            rotation += change
        case .alpha:
            alpha += change
        default:
            fatalError("Attribute\(attribute.rawValue) is not supported on the sprite \(self)!")
        }
    }
    
}
