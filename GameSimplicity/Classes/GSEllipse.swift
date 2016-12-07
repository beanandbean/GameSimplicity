//
//  GSEllipse.swift
//  Pods
//
//  Created by wangsw on 06/12/2016.
//
//

import UIKit

final public class GSEllipse: GSShape {
    
    public var horizontalRadius: CGFloat { didSet { updateView() } }
    public var verticalRadius: CGFloat { didSet { updateView() } }
    
    public var width: CGFloat {
        get {
            return horizontalRadius * 2
        }
        set (value) {
            horizontalRadius = width / 2
        }
    }
    public var height: CGFloat {
        get {
            return verticalRadius * 2
        }
        set (value) {
            verticalRadius = height / 2
        }
    }
    
    public var radius: CGFloat {
        get {
            return horizontalRadius
        }
        set (value) {
            horizontalRadius = value
            verticalRadius = value
        }
    }
    
    override var defaultViewTransform: CGAffineTransform {
        return CGAffineTransform(translationX: -horizontalRadius * screenScale, y: -verticalRadius * screenScale)
    }
    
    override var size: CGSize {
        return CGSize(width: width * screenScale, height: height * screenScale)
    }
    
    override var path: CGPath {
        return CGPath(ellipseIn: CGRect(origin: CGPoint.zero, size: size), transform: nil)
    }
    
    public convenience init(centerX: CGFloat, centerY: CGFloat, horizontalRadius: CGFloat, verticalRadius: CGFloat, color: UIColor) {
        self.init(horizontalRadius: horizontalRadius, verticalRadius: verticalRadius, color: color)
        translateX = centerX
        translateY = centerY
    }
    
    public convenience init(center: CGPoint, horizontalRadius: CGFloat, verticalRadius: CGFloat, color: UIColor) {
        self.init(centerX: center.x, centerY: center.y, horizontalRadius: horizontalRadius, verticalRadius: verticalRadius, color: color)
    }
    
    public convenience init(centerX: CGFloat, centerY: CGFloat, radius: CGFloat, color: UIColor) {
        self.init(centerX: centerX, centerY: centerY, horizontalRadius: radius, verticalRadius: radius, color: color)
    }
    
    public convenience init(center: CGPoint, radius: CGFloat, color: UIColor) {
        self.init(centerX: center.x, centerY: center.y, horizontalRadius: radius, verticalRadius: radius, color: color)
    }
    
    public convenience init(center: CGPoint, size: CGSize, color: UIColor) {
        self.init(centerX: center.x, centerY: center.y, horizontalRadius: size.width / 2, verticalRadius: size.height / 2, color: color)
    }
    
    public convenience init(rect: CGRect, color: UIColor) {
        self.init(centerX: rect.origin.x + rect.width / 2, centerY: rect.origin.y + rect.height / 2, horizontalRadius: rect.width / 2, verticalRadius: rect.height / 2, color: color)
    }
    
    public convenience init(radius: CGFloat, color: UIColor) {
        self.init(horizontalRadius: radius, verticalRadius: radius, color: color)
    }
    
    public convenience init(size: CGSize, color: UIColor) {
        self.init(horizontalRadius: size.width / 2, verticalRadius: size.height / 2, color: color)
    }
    
    public init(horizontalRadius: CGFloat, verticalRadius: CGFloat, color: UIColor) {
        self.horizontalRadius = horizontalRadius
        self.verticalRadius = verticalRadius
        super.init(color: color)
    }
    
    override func update(attribute: GSAnimationAttribute, change: CGFloat) {
        switch attribute {
        case .width:
            width += change
        case .height:
            height += change
        case .radius:
            radius += change
        case .horizontalRadius:
            horizontalRadius += change
        case .verticalRadius:
            verticalRadius += change
        default:
            super.update(attribute: attribute, change: change)
        }
    }
    
}
