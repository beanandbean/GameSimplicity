//
//  GSSequenceAnimation.swift
//  Pods
//
//  Created by wangsw on 06/12/2016.
//
//

public class GSSequenceAnimation: GSAnimation {
    
    var animations: [GSAnimation]
    var finalListener: GSListener!
    
    convenience public init(animation: GSAnimation) {
        self.init(animations: [animation])
    }
    
    public init(animations: [GSAnimation]) {
        self.animations = animations
        super.init()
        
        for (index, animation) in animations.enumerated() {
            precondition(animations.index(where: { $0 === animation }) == index, "Cannot add an animation twice to a sequence \(self)!")
            animation.on(.halt) {
                self.halt()
            }
            if index + 1 < animations.endIndex {
                animation.on(.completion) {
                    animations[index + 1].execute()
                }
            } else {
                finalListener = animation.on(.completion) {
                    self.completion()
                }
            }
        }
    }
    
    public func append(animation: GSAnimation) {
        precondition(animations.index(where: { $0 === animation }) == nil, "Cannot add an animation twice to a sequence \(self)!")
        animation.on(.halt) {
            self.halt()
        }
        animations.last!.remove(listener: finalListener, onEvent: .completion)
        animations.last!.on(.completion) {
            animation.execute()
        }
        finalListener = animation.on(.completion) {
            self.completion()
        }
        animations.append(animation)
    }
    
    public override func execute() {
        super.execute()
        animations.first!.execute()
    }
    
    public override func halt() {
        let index = animations.index(where: { $0.isExecuting })
        precondition(index != nil, "Cannot stop a non-active animation \(self)!")
        animations[index!].halt()
        super.halt()
    }
    
    public override func pause() {
        let index = animations.index(where: { $0.isExecuting })
        precondition(index != nil, "Cannot pause a non-active animation \(self)!")
        animations[index!].pause()
        super.pause()
    }
    
    public override func resume() {
        super.resume()
        let index = animations.index(where: { !$0.isExecuting && $0.isPaused })
        precondition(index != nil, "Cannot resume a non-paused animation \(self)!")
        animations[index!].resume()
    }
    
    public override func copy() -> GSAnimation {
        return GSSequenceAnimation(animations: animations.map({ $0.copy() }))
    }
    
}
