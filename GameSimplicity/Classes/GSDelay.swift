//
//  GSDelay.swift
//  Pods
//
//  Created by wangsw on 06/12/2016.
//
//

public class GSDelay: GSAnimation {
    
    let duration: TimeInterval
    let action: (() -> Void)?
    
    var startTime: TimeInterval = 0
    var pauseTime: TimeInterval = 0
    var timer: Timer?
    
    public init(duration: TimeInterval) {
        self.duration = duration
        action = nil
    }
    
    public init(duration: TimeInterval, action: (() -> Void)?) {
        self.duration = duration
        self.action = action
    }
    
    public init(duration: TimeInterval, action: @escaping () -> Void) {
        self.duration = duration
        self.action = action
    }
    
    public override func execute() {
        super.execute()
        precondition(timer == nil, "Cannot execute an already-active animation \(self)!")
        startTime = Date.timeIntervalSinceReferenceDate
        timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(timerFire), userInfo: nil, repeats: false)
    }
    
    public override func completion() {
        precondition(timer != nil, "Cannot stop a non-active animation \(self)!")
        timer?.invalidate()
        timer = nil
        super.completion()
    }
    
    public override func halt() {
        precondition(timer != nil, "Cannot stop a non-active animation \(self)!")
        timer?.invalidate()
        timer = nil
        super.halt()
    }
    
    public override func pause() {
        precondition(timer != nil, "Cannot stop a non-active animation \(self)!")
        pauseTime = Date.timeIntervalSinceReferenceDate
        timer?.invalidate()
        timer = nil
        super.pause()
    }
    
    public override func resume() {
        super.resume()
        precondition(timer == nil, "Cannot execute an already-active animation \(self)!")
        let remain = startTime + duration - pauseTime
        startTime = Date.timeIntervalSinceReferenceDate + remain - duration
        timer = Timer.scheduledTimer(timeInterval: remain, target: self, selector: #selector(timerFire), userInfo: nil, repeats: false)
    }
    
    @objc func timerFire() {
        action?()
        completion()
    }
    
    public override func copy() -> GSAnimation {
        return GSDelay(duration: duration, action: action)
    }
    
}
