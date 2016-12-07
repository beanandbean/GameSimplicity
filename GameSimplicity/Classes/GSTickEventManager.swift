//
//  GSTickEventManager.swift
//  Pods
//
//  Created by wangsw on 06/12/2016.
//
//

public protocol GSManagedTickEventReceiver {
    
    func update()
    
}

func ===(this: GSManagedTickEventReceiver, that: GSManagedTickEventReceiver) -> Bool {
    return (this as AnyObject) === (that as AnyObject)
}

public class GSTickEventManager {
    
    public static let sharedManager = GSTickEventManager()
    
    var eventReceivers = [GSManagedTickEventReceiver]()
    var timer: Timer?
    
    //var prevTime: TimeInterval = 0
    //var fps: TimeInterval = 0
    
    public func add(eventReceiver: GSManagedTickEventReceiver) {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1/60, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            //prevTime = Date.timeIntervalSinceReferenceDate
        }
        precondition(eventReceivers.index(where: { $0 === eventReceiver }) == nil, "Cannot add an event receiver twice to a GSTickEventManager!")
        eventReceivers.append(eventReceiver)
    }
    
    public func remove(eventReceiver: GSManagedTickEventReceiver) {
        let index = eventReceivers.index(where: { $0 === eventReceiver })
        precondition(index != nil, "Cannot remove a non-existent event receiver twice from a GSTickEventManager!")
        eventReceivers.remove(at: index!)
    }
    
    @objc func update() {
        //let now = Date.timeIntervalSinceReferenceDate
        //fps = fps * 0.9 + 0.1 / (now - prevTime)
        //print("FPS: \(fps)")
        //prevTime = now
        
        for eventReceiver in eventReceivers {
            eventReceiver.update()
        }
    }
    
}
