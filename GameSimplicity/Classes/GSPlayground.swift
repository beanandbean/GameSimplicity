//
//  GSPlayground.swift
//  Pods
//
//  Created by wangsw on 05/12/2016.
//
//

import UIKit

final class GSPlaygroundView: UIView {
    
    var playground: GSPlayground // Maintain GSPlayground's lifecycle in the view tree
    
    init(playground: GSPlayground) {
        self.playground = playground
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

public enum GSPlaygroundEvent {
    case tap, swipeLeft, swipeRight, swipeUp, swipeDown
    case globalTap, globalSwipeLeft, globalSwipeRight, globalSwipeUp, globalSwipeDown
}

final public class GSPlayground: GSListenerHandler<GSPlaygroundEvent> {

    public let width: CGFloat, height: CGFloat
    public var size: CGSize {
        return CGSize(width: width, height: height)
    }
    
    public var centerX: CGFloat {
        return width / 2
    }
    public var centerY: CGFloat {
        return height / 2
    }
    public var center: CGPoint {
        return CGPoint(x: centerX, y: centerY)
    }
    
    weak var view: GSPlaygroundView!
    var sprites = [GSSprite]()
    
    var scaleRatio: CGFloat!
    var widthConstraint: NSLayoutConstraint!
    var heightConstraint: NSLayoutConstraint!
    
    public init(inView parent: UIView, size: CGSize) {
        width = size.width
        height = size.height
        super.init()
        
        let view = GSPlaygroundView(playground: self)
        self.view = view
        
        widthConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: width)
        heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: height)
        view.addConstraint(widthConstraint)
        view.addConstraint(heightConstraint)
        
        parent.addSubview(view)
        parent.addConstraint(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: parent, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        parent.addConstraint(NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: parent, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        parent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(gesture:))))
        
        for direction in [UISwipeGestureRecognizerDirection.left, .right, .up, .down] {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(gesture:)))
            gesture.direction = direction
            parent.addGestureRecognizer(gesture)
        }
        
        scaleTo(size: parent.bounds.size)
    }
    
    func scaleTo(size: CGSize) {
        scaleRatio = min(size.width / width, size.height / height)
        widthConstraint.constant = width * scaleRatio
        heightConstraint.constant = height * scaleRatio
        for sprite in sprites {
            sprite.updateScale(scale: scaleRatio)
        }
    }
    
    public func add(sprite: GSSprite) {
        precondition(sprites.index(where: { $0 === sprite }) == nil, "Cannot add a GSSprite twice to a playground \(self)!")
        sprites.append(sprite)
        sprite.updateScale(scale: scaleRatio)
        view.addSubview(sprite.view)
    }
    
    public func contains(sprite: GSSprite) -> Bool {
        return sprites.index(where: { $0 === sprite }) != nil
    }
    
    public func remove(sprite: GSSprite) {
        let index = sprites.index(where: { $0 === sprite })
        precondition(index != nil, "Cannot remove a non-existent GSSprite from a playground \(self)!")
        sprites.remove(at: index!)        
        sprite.view.removeFromSuperview()
    }
    
    @objc func handleTapGesture(gesture: UITapGestureRecognizer) {
        broadcast(event: .globalTap)
        let location = gesture.location(in: view)
        for sprite in sprites.reversed() {
            if sprite.userInteractionEnabled && sprite.shapePath.contains(location) {
                sprite.broadcast(event: .tap)
                return
            }
        }
        broadcast(event: .tap)
    }
    
    @objc func handleSwipeGesture(gesture: UISwipeGestureRecognizer) {
        let index = [UISwipeGestureRecognizerDirection.left, .right, .up, .down].index(of: gesture.direction)
        precondition(index != nil, "Cannot process multi-direction swipe \(gesture.direction)!")
        broadcast(event: [.globalSwipeRight, .globalSwipeRight, .globalSwipeUp, .globalSwipeDown][index!])
        let location = gesture.location(in: view)
        for sprite in sprites.reversed() {
            if sprite.userInteractionEnabled && sprite.shapePath.contains(location) {
                sprite.broadcast(event: [.swipeLeft, .swipeRight, .swipeUp, .swipeDown][index!])
                return
            }
        }
        broadcast(event: [.swipeLeft, .swipeRight, .swipeUp, .swipeDown][index!])
    }
    
}
