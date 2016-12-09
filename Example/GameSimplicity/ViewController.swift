//
//  ViewController.swift
//  GameSimplicity
//
//  Created by beanandbean on 12/05/2016.
//  Copyright (c) 2016 beanandbean. All rights reserved.
//

import UIKit
import GameSimplicity

func + (p1: CGPoint, p2: CGPoint) -> CGPoint {
    return CGPoint(x: p1.x + p2.x, y: p1.y + p2.y)
}

func - (p1: CGPoint, p2: CGPoint) -> CGPoint {
    return CGPoint(x: p1.x - p2.x, y: p1.y - p2.y)
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
        
        let playground = GSPlayground(inView: view, size: CGSize(width: 60, height: 80))
        
        let randomDarkColor = {
            return UIColor(hue: CGFloat(drand48()), saturation: 1.0, brightness: 0.3, alpha: 1.0)
        }
        let randomBrightColor = {
            return UIColor(hue: CGFloat(drand48()), saturation: 1.0, brightness: 1.0, alpha: 1.0)
        }
        
        let centerRect = GSRectangle(origin: playground.center - CGPoint(x: 5, y: 5), size: CGSize(width: 10, height: 10), color: randomDarkColor())
        centerRect.anchor = playground.center
        centerRect.physicalAnimator.updateSpeed(byAttributes: [.rotation: CGFloat.pi / 5])
        playground.add(sprite: centerRect)
        
        let centerSeqChangeColor = GSSequenceAnimation(animations: [
            GSDelay(duration: 0.5, action: {
                centerRect.color = randomDarkColor()
            }),
            GSDelay(duration: 0.5),
            ])
        let centerSeqAnimation = GSSequenceAnimation(animations: [
            GSExecute(block: {
                GSAttributeAnimation(onSprite: centerRect, byAttributes: [.alpha: -0.5], duration: 1).execute()
            }),
            GSAttributeAnimation(onSprite: centerRect, byAttributes: [.cornerRadius: 2.5], duration: 1),
            centerSeqChangeColor,
            GSExecute(block: {
                GSAttributeAnimation(onSprite: centerRect, byAttributes: [.alpha: 0.5], duration: 1).execute()
            }),
            GSAttributeAnimation(onSprite: centerRect, byAttributes: [.cornerRadius: -2.5], duration: 1),
            centerSeqChangeColor.copy()])
        centerSeqAnimation.on(.completion) { centerSeqAnimation.execute() }
        centerSeqAnimation.execute()
        
        centerRect.on(.tap) {
            if centerSeqAnimation.isPaused {
                centerRect.physicalAnimator.updateSpeed(byAttributes: [.rotation: CGFloat.pi / 5])
                centerSeqAnimation.resume()
            } else {
                centerRect.physicalAnimator.clearPhysicalAnimation()
                centerSeqAnimation.pause()
            }
        }
        
        playground.on(.globalSwipeLeft) {
            GSAttributeAnimation(onSprite: centerRect, byAttributes: [.x: -5], duration: 0.5).execute()
        }
        playground.on(.globalSwipeRight) {
            GSAttributeAnimation(onSprite: centerRect, byAttributes: [.x: 5], duration: 0.5).execute()
        }
        playground.on(.globalSwipeUp) {
            GSAttributeAnimation(onSprite: centerRect, byAttributes: [.y: -5], duration: 0.5).execute()
        }
        playground.on(.globalSwipeDown) {
            GSAttributeAnimation(onSprite: centerRect, byAttributes: [.y: 5], duration: 0.5).execute()
        }
        
        let numRects = 4
        let rects = (0..<numRects).map { (index) -> GSSprite in
            let rect = GSRectangle(origin: playground.center - CGPoint(x: 10, y: 15), size: CGSize(width: 25, height: 5), color: randomBrightColor())
            rect.alpha = 0.5
            rect.anchor = playground.center
            rect.rotation = CGFloat.pi * 2 * CGFloat(index) / CGFloat(numRects)
            playground.add(sprite: rect)
            
            rect.on(.tap) {
                rect.color = randomBrightColor()
            }
            
            return rect
        }
        
        let seqAnimation = GSSequenceAnimation(animations: [
            GSAttributeAnimation(onSprites: rects, byAttributes: [.x: -7.5], duration: 2.5),
            GSAttributeAnimation(onSprites: rects, byAttributes: [.x: 15], duration: 5),
            GSAttributeAnimation(onSprites: rects, byAttributes: [.x: -7.5], duration: 2.5)])
        seqAnimation.on(.completion) { seqAnimation.execute() }
        seqAnimation.execute()
        
        let frameAnimation = GSFrameAnimation(frames: 20, framesPerSecond: 2) { (index) in
            for (rectIndex, rect) in rects.enumerated() {
                rect.rotation = CGFloat.pi * 2 * CGFloat(rectIndex) / CGFloat(numRects) + CGFloat.pi / 10 * CGFloat(index)
            }
        }
        frameAnimation.on(.completion) { frameAnimation.execute() }
        frameAnimation.execute()
        
        let ball = GSEllipse(center: playground.center, horizontalRadius: 2, verticalRadius: 1.5, color: UIColor(hue: 0.0, saturation: 1.0, brightness: 1.0, alpha: 1.0))
        ball.userInteractionEnabled = false
        ball.physicalAnimator.updateSpeed(byAttributes: [.y: -12])
        ball.physicalAnimator.updateAcceleration(byAttributes: [.y: 4])
        playground.add(sprite: ball)
        
        let ballColorAnimation = GSAttributeAnimation(onSprite: ball, byAttributes: [.hue: 1], duration: 2)
        ballColorAnimation.on(.completion) { ballColorAnimation.execute() }
        ballColorAnimation.execute()
        
        let ballMonitor = GSEntranceMonitor { ball.translateY >= playground.centerY }
        ballMonitor.on(.enterState) {
            ball.physicalAnimator.updateSpeed(byAttributes: [.y: -24])
        }
        ballMonitor.turnOn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

