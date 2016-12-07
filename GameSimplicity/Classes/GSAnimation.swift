//
//  GSAnimation.swift
//  Pods
//
//  Created by wangsw on 06/12/2016.
//
//

public enum GSAnimationEvent {
    case execution, completion, halt, pause, resume
}

public class GSAnimation: GSListenerHandler<GSAnimationEvent> {

    public internal(set) var isExecuting = false
    public internal(set) var isPaused = false
    
    public func execute() {
        precondition(!isExecuting && !isPaused, "Cannot execute an already-active animation \(self)!")
        broadcast(event: .execution)
        isExecuting = true
    }
    
    public func completion() {
        precondition(isExecuting, "Cannot stop a non-active animation \(self)!")
        isExecuting = false
        broadcast(event: .completion)
    }
    
    public func halt() {
        precondition(isExecuting, "Cannot stop a non-active animation \(self)!")
        isExecuting = false
        broadcast(event: .halt)
    }
    
    public func pause() {
        precondition(isExecuting, "Cannot pause a non-active animation \(self)!")
        isExecuting = false
        isPaused = true
        broadcast(event: .pause)
    }
    
    public func resume() {
        precondition(!isExecuting && isPaused, "Cannot resume a non-paused animation \(self)!")
        broadcast(event: .resume)
        isExecuting = true
        isPaused = false
    }
    
    public func copy() -> GSAnimation {
        fatalError("Cannot copy an abstract GSAnimation \(self)!")
    }
    
}
