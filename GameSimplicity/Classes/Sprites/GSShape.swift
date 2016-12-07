//
//  GSShape.swift
//  Pods
//
//  Created by wangsw on 06/12/2016.
//
//

import UIKit

public class GSShape: GSSprite {
        
    public var color: UIColor { didSet { updateView() } }
    
    var size: CGSize {
        fatalError("Cannot create size for an abstract GSShape \(self)!")
    }
    
    var path: CGPath {
        fatalError("Cannot create path for an abstract GSShape \(self)!")
    }
    
    override var rawShapePath: CGPath {
        return path
    }
    
    init(color: UIColor) {
        self.color = color
        super.init()
        view = GSShapeView(sprite: self)
        updateView()
    }
    
    public func drawOn(context: CGContext) {
        context.addPath(path)
        context.setFillColor(color.cgColor)
        context.fillPath()
    }
    
    override func update(attribute: GSAnimationAttribute, change: CGFloat) {
        super.update(attribute: attribute, change: change)
    }
    
    override func updateScale(scale: CGFloat) {
        super.updateScale(scale: scale)
        updateView()
    }
    
    func updateView() {
        view.bounds = CGRect(origin: CGPoint.zero, size: size)
        view.setNeedsDisplay()
        updateTranform()
    }
    
}
