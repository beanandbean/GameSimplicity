//
//  GSPhysicalAnimator.swift
//  Pods
//
//  Created by wangsw on 06/12/2016.
//
//

public class GSPhysicalAnimator: GSManagedTickEventReceiver {
    
    weak var sprite: GSSprite?
    
    var animatorOn = false
    var prevTime: TimeInterval = 0
    var physics = [GSAnimationAttribute: (CGFloat, CGFloat)]()
    
    public var isCleared: Bool {
        return physics.isEmpty
    }
    
    init(sprite: GSSprite) {
        self.sprite = sprite
    }
    
    public func clearPhysicalAnimation() {
        physics = [GSAnimationAttribute: (CGFloat, CGFloat)]()
        if animatorOn {
            GSTickEventManager.sharedManager.remove(eventReceiver: self)
            animatorOn = false
        }
    }
    
    public func updateSpeed(byAttributes attributes: [GSAnimationAttribute: CGFloat]) {
        if !animatorOn {
            GSTickEventManager.sharedManager.add(eventReceiver: self)
            prevTime = Date.timeIntervalSinceReferenceDate
            animatorOn = true
        }
        for (attribute, change) in attributes {
            if let (speed, acceleration) = physics[attribute] {
                physics[attribute] = (speed + change, acceleration)
            } else {
                physics[attribute] = (change, 0.0)
            }
        }
    }
    
    public func updateAcceleration(byAttributes attributes: [GSAnimationAttribute: CGFloat]) {
        if !animatorOn {
            GSTickEventManager.sharedManager.add(eventReceiver: self)
            prevTime = Date.timeIntervalSinceReferenceDate
            animatorOn = true
        }
        for (attribute, change) in attributes {
            if let (speed, acceleration) = physics[attribute] {
                physics[attribute] = (speed, acceleration + change)
            } else {
                physics[attribute] = (0.0, change)
            }
        }
    }
    
    public func update() {
        precondition(animatorOn, "Cannot update a non-active animator \(self)!")
        let now = Date.timeIntervalSinceReferenceDate
        let diff = CGFloat(now - prevTime)
        for (attribute, (speed, acceleration)) in physics {
            sprite?.update(attribute: attribute, change: speed * diff + 0.5 * acceleration * diff * diff)
            physics[attribute] = (speed + acceleration * diff, acceleration)
        }
        prevTime = now
    }
    
}
