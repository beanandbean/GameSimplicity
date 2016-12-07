//
//  GSShapeView.swift
//  Pods
//
//  Created by wangsw on 05/12/2016.
//
//

import UIKit

final class GSShapeView: UIView {
    
    let sprite: GSShape
    
    init(sprite: GSShape) {
        self.sprite = sprite
        super.init(frame: CGRect.zero)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            sprite.drawOn(context: context)
        }
    }
    
}
