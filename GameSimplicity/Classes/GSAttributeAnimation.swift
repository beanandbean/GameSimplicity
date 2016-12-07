//
//  GSAttributeAnimation.swift
//  Pods
//
//  Created by wangsw on 06/12/2016.
//
//

public enum GSAnimationAttribute: String {
    case x = "x", y = "y", scaleX = "scaleX", scaleY = "scaleY", rotation = "rotation"
    case alpha = "alpha"
    case width = "width", height = "height"
    case cornerRadius = "cornerRadius", cornerWidth = "cornerWidth", cornerHeight = "cornerHeight"
    case radius = "radius", horizontalRadius = "horizontalRadius", verticalRadius = "verticalRadius"
}

public final class GSAttributeAnimation: GSAnimation, GSManagedTickEventReceiver {
    
    let sprites: [GSSprite]
    let changes: [(GSAnimationAttribute, CGFloat)]
    let duration: TimeInterval
    
    var prevTime: TimeInterval = 0
    var endTime: TimeInterval = 0
    
    public convenience init(onSprite sprite: GSSprite, byAttributes attributes: [GSAnimationAttribute: CGFloat], duration: TimeInterval) {
        self.init(onSprites: [sprite], byAttributes: attributes, duration: duration)
    }
    
    public convenience init(onSprite sprite: GSSprite, byAttributes attributes: [(GSAnimationAttribute, CGFloat)], duration: TimeInterval) {
        self.init(onSprites: [sprite], byAttributes: attributes, duration: duration)
    }
    
    public init(onSprites sprites: [GSSprite], byAttributes attributes: [GSAnimationAttribute: CGFloat], duration: TimeInterval) {
        self.sprites = sprites
        changes = attributes.map({ (attribute, change) in
            return (attribute, change / CGFloat(duration))
        })
        self.duration = duration
    }
    
    public init(onSprites sprites: [GSSprite], byAttributes attributes: [(GSAnimationAttribute, CGFloat)], duration: TimeInterval) {
        self.sprites = sprites
        changes = attributes.map({ (attribute, change) in
            return (attribute, change / CGFloat(duration))
        })
        self.duration = duration
    }
    
    public init(onSprites sprites: [GSSprite], byAttributeSpeeds attributes: [GSAnimationAttribute: CGFloat], duration: TimeInterval) {
        self.sprites = sprites
        changes = attributes.map({ $0 })
        self.duration = duration
    }
    
    public init(onSprites sprites: [GSSprite], byAttributeSpeeds attributes: [(GSAnimationAttribute, CGFloat)], duration: TimeInterval) {
        self.sprites = sprites
        changes = attributes
        self.duration = duration
    }
    
    public override func execute() {
        super.execute()
        let now = Date.timeIntervalSinceReferenceDate
        endTime = now + duration
        prevTime = now
        GSTickEventManager.sharedManager.add(eventReceiver: self)
    }
    
    public override func completion() {
        GSTickEventManager.sharedManager.remove(eventReceiver: self)
        super.completion()
    }
    
    public override func halt() {
        GSTickEventManager.sharedManager.remove(eventReceiver: self)
        super.halt()
    }
    
    public override func pause() {
        GSTickEventManager.sharedManager.remove(eventReceiver: self)
        super.pause()
    }
    
    public override func resume() {
        super.resume()
        let now = Date.timeIntervalSinceReferenceDate
        endTime = now + endTime - prevTime
        prevTime = now
        GSTickEventManager.sharedManager.add(eventReceiver: self)
    }
    
    public func update() {
        precondition(isExecuting, "Cannot update a non-active animation \(self)!")
        let now = Date.timeIntervalSinceReferenceDate
        let diff = CGFloat(min(endTime, now) - prevTime)
        for (attribute, change) in changes {
            let updateChange = diff * change
            for sprite in sprites {
                sprite.update(attribute: attribute, change: updateChange)
            }
        }
        if now >= endTime {
            completion()
        } else {
            prevTime = now
        }
    }
    
    public override func copy() -> GSAnimation {
        return GSAttributeAnimation(onSprites: sprites, byAttributeSpeeds: changes, duration: duration)
    }
    
}
