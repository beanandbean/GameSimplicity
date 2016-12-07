//
//  GSRectangle.swift
//  Pods
//
//  Created by wangsw on 05/12/2016.
//
//

import UIKit

final public class GSRectangle: GSShape {

    public var width: CGFloat { didSet { updateView() } }
    public var height: CGFloat { didSet { updateView() } }
    public var cornerWidth: CGFloat = 0.0 { didSet { updateView() } }
    public var cornerHeight: CGFloat = 0.0 { didSet { updateView() } }
    
    public var cornerRadius: CGFloat {
        get {
            return cornerWidth
        }
        set (value) {
            cornerWidth = value
            cornerHeight = value
        }
    }
    
    override var defaultViewTransform: CGAffineTransform {
        return CGAffineTransform.identity
    }
    
    override var size: CGSize {
        return CGSize(width: width * screenScale, height: height * screenScale)
    }
    
    override var path: CGPath {
        let optCornerWidth = max(0, min(cornerWidth, width / 2))
        let optCornerHeight = max(0, min(cornerHeight, height / 2))
        return CGPath(roundedRect: CGRect(origin: CGPoint.zero, size: size), cornerWidth: optCornerWidth * screenScale, cornerHeight: optCornerHeight * screenScale, transform: nil)
    }

    public convenience init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
        self.init(width: width, height: height, color: color)
        translateX = x
        translateY = y
    }
    
    public convenience init(origin: CGPoint, size: CGSize, color: UIColor) {
        self.init(x: origin.x, y: origin.y, width: size.width, height: size.height, color: color)
    }
    
    public convenience init(rect: CGRect, color: UIColor) {
        self.init(origin: rect.origin, size: rect.size, color: color)
    }

    public convenience init(size: CGSize, color: UIColor) {
        self.init(width: size.width, height: size.height, color: color)
    }
    
    public init(width: CGFloat, height: CGFloat, color: UIColor) {
        self.width = width
        self.height = height
        super.init(color: color)
    }
    
    override func update(attribute: GSAnimationAttribute, change: CGFloat) {
        switch attribute {
        case .width:
            width += change
        case .height:
            height += change
        case .cornerRadius:
            cornerRadius += change
        case .cornerWidth:
            cornerWidth += change
        case .cornerHeight:
            cornerHeight += change
        default:
            super.update(attribute: attribute, change: change)
        }
    }
    
}
