//
//  GSFrameAnimation.swift
//  Pods
//
//  Created by wangsw on 09/12/2016.
//
//

import Foundation

public class GSFrameAnimation: GSAnimation {
    
    let frameCount: Int
    let frameDuration: TimeInterval
    let update: (Int) -> Void
    
    var index = 0
    var startTime: TimeInterval = 0
    var pauseTime: TimeInterval = 0
    var timer: Timer?
    
    public init(frames: Int, durationPerFrame: TimeInterval, update: @escaping (Int) -> Void) {
        frameCount = frames
        frameDuration = durationPerFrame
        self.update = update
    }
    
    public init(frames: Int, framesPerSecond: Double, update: @escaping (Int) -> Void) {
        frameCount = frames
        frameDuration = 1 / framesPerSecond
        self.update = update
    }
    
    public override func execute() {
        super.execute()
        precondition(timer == nil, "Cannot execute an already-active animation \(self)!")
        startTime = Date.timeIntervalSinceReferenceDate
        index = 0
        timer = Timer.scheduledTimer(timeInterval: frameDuration, target: self, selector: #selector(timerFire), userInfo: nil, repeats: true)
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
        let duration = frameDuration * Double(index + 1)
        let remain = startTime + duration - pauseTime
        startTime = Date.timeIntervalSinceReferenceDate + remain - duration
        timer = Timer.scheduledTimer(timeInterval: remain, target: self, selector: #selector(remainTimerFire), userInfo: nil, repeats: false)
    }
    
    @objc func remainTimerFire() {
        timerFire()
        if index < frameCount {
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: frameDuration, target: self, selector: #selector(timerFire), userInfo: nil, repeats: true)
        }
    }
    
    @objc func timerFire() {
        precondition(index < frameCount, "Cannot update a GSFrameAnimation \(self) past its last frame")
        index += 1
        update(index)
        if index == frameCount {
            completion()
        }
    }
    
    public override func copy() -> GSAnimation {
        return GSFrameAnimation(frames: frameCount, durationPerFrame: frameDuration, update: update)
    }
    
}

