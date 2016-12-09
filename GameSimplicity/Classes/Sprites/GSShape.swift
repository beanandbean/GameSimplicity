//
//  GSShape.swift
//  Pods
//
//  Created by wangsw on 06/12/2016.
//
//

import UIKit

enum GSShapeColorReperesentation {
    case RGB, HSB
}

public class GSShape: GSSprite {
    
    var colorRepresentation = GSShapeColorReperesentation.RGB {
        willSet (value) {
            let c = color
            switch value {
            case .RGB:
                c.getRed(&_red, green: &_green, blue: &_blue, alpha: &shapeAlpha)
            case .HSB:
                c.getHue(&_hue, saturation: &_saturation, brightness: &_brightness, alpha: &shapeAlpha)
            }
        }
    }
    
    var _red: CGFloat = 0 { didSet { updateView() } }
    var _green: CGFloat = 0 { didSet { updateView() } }
    var _blue: CGFloat = 0 { didSet { updateView() } }
    var _hue: CGFloat = 0  { didSet { updateView() } }
    var _saturation: CGFloat = 0 { didSet { updateView() } }
    var _brightness: CGFloat = 0 { didSet { updateView() } }
    
    public var red: CGFloat {
        get {
            if colorRepresentation != .RGB {
                colorRepresentation = .RGB
            }
            return _red
        }
        set (value) {
            if colorRepresentation != .RGB {
                colorRepresentation = .RGB
            }
            _red = value
        }
    }
    public var green: CGFloat {
        get {
            if colorRepresentation != .RGB {
                colorRepresentation = .RGB
            }
            return _green
        }
        set (value) {
            if colorRepresentation != .RGB {
                colorRepresentation = .RGB
            }
            _green = value
        }
    }
    public var blue: CGFloat {
        get {
            if colorRepresentation != .RGB {
                colorRepresentation = .RGB
            }
            return _blue
        }
        set (value) {
            if colorRepresentation != .RGB {
                colorRepresentation = .RGB
            }
            _blue = value
        }
    }
    
    public var hue: CGFloat {
        get {
            if colorRepresentation != .HSB {
                colorRepresentation = .HSB
            }
            return _hue
        }
        set (value) {
            if colorRepresentation != .HSB {
                colorRepresentation = .HSB
            }
            _hue = value
        }
    }
    public var saturation: CGFloat {
        get {
            if colorRepresentation != .HSB {
                colorRepresentation = .HSB
            }
            return _saturation
        }
        set (value) {
            if colorRepresentation != .HSB {
                colorRepresentation = .HSB
            }
            _saturation = value
        }
    }
    public var brightness: CGFloat{
        get {
            if colorRepresentation != .HSB {
                colorRepresentation = .HSB
            }
            return _brightness
        }
        set (value) {
            if colorRepresentation != .HSB {
                colorRepresentation = .HSB
            }
            _brightness = value
        }
    }
    
    public var shapeAlpha: CGFloat = 0 { didSet { updateView() } }
    
    public var color: UIColor {
        get {
            switch colorRepresentation {
            case .RGB:
                return UIColor(red: _red, green: _green, blue: _blue, alpha: shapeAlpha)
            case .HSB:
                return UIColor(hue: _hue, saturation: _saturation, brightness: _brightness, alpha: shapeAlpha)
            }
        }
        set (value) {
            switch colorRepresentation {
            case .RGB:
                value.getRed(&_red, green: &_green, blue: &_blue, alpha: &shapeAlpha)
            case .HSB:
                value.getHue(&_hue, saturation: &_saturation, brightness: &_brightness, alpha: &shapeAlpha)
            }
        }
    }
    
    var size: CGSize {
        fatalError("Cannot create size for an abstract GSShape \(self)!")
    }
    
    var path: CGPath {
        fatalError("Cannot create path for an abstract GSShape \(self)!")
    }
    
    override var rawShapePath: CGPath {
        return path
    }
    
    init(color: UIColor) {
        super.init()
        view = GSShapeView(sprite: self)
        self.color = color
    }
    
    public func drawOn(context: CGContext) {
        context.addPath(path)
        context.setFillColor(color.cgColor)
        context.fillPath()
    }
    
    override func update(attribute: GSAnimationAttribute, change: CGFloat) {
        switch attribute {
        case .red:
            red += change
        case .green:
            green += change
        case .blue:
            blue += change
        case .hue:
            hue += change
        case .saturation:
            saturation += change
        case .brightness:
            brightness += change
        default:
            super.update(attribute: attribute, change: change)
        }
    }
    
    override func updateScale(scale: CGFloat) {
        super.updateScale(scale: scale)
        updateView()
    }
    
    func updateView() {
        view.bounds = CGRect(origin: CGPoint.zero, size: size)
        view.setNeedsDisplay()
        updateTranform()
    }
    
}
