//
//  GSEntranceMonitor.swift
//  Pods
//
//  Created by wangsw on 06/12/2016.
//
//

public enum GSEntranceMonitorEvent {
    case on, off, enterState
}

public class GSEntranceMonitor: GSListenerHandler<GSEntranceMonitorEvent>, GSManagedTickEventReceiver {
    
    let condition: () -> Bool
    
    public internal(set) var isOn = false
    var inState = true
    
    public init(forCondition condition: @escaping () -> Bool) {
        self.condition = condition
    }
    
    public func turnOn() {
        precondition(!isOn, "Cannot turn on an already-on monitor \(self)!")
        broadcast(event: .on)
        isOn = true
        inState = true
        GSTickEventManager.sharedManager.add(eventReceiver: self)
    }
    
    public func turnOff() {
        precondition(isOn, "Cannot turn off an already-off monitor \(self)!")
        GSTickEventManager.sharedManager.remove(eventReceiver: self)
        isOn = false
        broadcast(event: .off)
    }
    
    public func update() {
        if condition() {
            if !inState {
                inState = true
                broadcast(event: .enterState)
            }
        } else if inState {
            inState = false
        }
    }
    
}
