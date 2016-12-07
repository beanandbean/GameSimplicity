//
//  GSListenerHandler.swift
//  Pods
//
//  Created by wangsw on 07/12/2016.
//
//

public class GSListenerHandler<Event: Hashable> {
    
    var listeners = [Event: [GSListener]]()
    
    @discardableResult
    public func on(_ events: [Event], _ callback: @escaping () -> Void) -> GSListener {
        let listener = GSListener(callback: callback)
        for event in events {
            if listeners[event] != nil {
                listeners[event]?.append(listener)
            } else {
                listeners[event] = [listener]
            }
        }
        return listener
    }
    
    @discardableResult
    public func on(_ event: Event, _ callback: @escaping () -> Void) -> GSListener {
        return on([event], callback)
    }
    
    public func remove(listener: GSListener, onEvents events: [Event]) {
        for event in events {
            if listeners[event] != nil {
                if let index = listeners[event]?.index(where: { $0 === listener }) {
                    listeners[event]?.remove(at: index)
                }
            }
        }
    }
    
    public func remove(listener: GSListener, onEvent event: Event) {
        remove(listener: listener, onEvents: [event])
    }
    
    func broadcast(event: Event) {
        if listeners[event] != nil {
            for listener in listeners[event]! {
                listener.execute()
            }
        }
    }
}
