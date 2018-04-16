//
//  UIColor+Skeleton.swift
//  SkeletonView-iOS
//
//  Created by Juanpe Catalán on 03/11/2017.
//  Copyright © 2017 SkeletonView. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(_ hex: UInt) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func skltn_isLight() -> Bool {
        // algorithm from: http://www.w3.org/WAI/ER/WD-AERT/#color-contrast
        guard let components = cgColor.components,
              components.count >= 3 else { return false }
        let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
        return !(brightness < 0.5)
    }
    
    public var skltn_complementaryColor: UIColor {
        return skltn_isLight() ? skltn_darker : skltn_lighter
    }
    
    public var skltn_lighter: UIColor {
        return skltn_adjust(by: 1.35)
    }
    
    public var skltn_darker: UIColor {
        return skltn_adjust(by: 0.94)
    }
    
    func skltn_adjust(by percent: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: b * percent, alpha: a)
    }
    
    func skltn_makeGradient() -> [UIColor] {
        return [self, self.skltn_complementaryColor, self]
    }
}

public extension UIColor {
    static var skltn_greenSea     = UIColor(0x16a085)
    static var skltn_turquoise    = UIColor(0x1abc9c)
    static var skltn_emerald      = UIColor(0x2ecc71)
    static var skltn_peterRiver   = UIColor(0x3498db)
    static var skltn_amethyst     = UIColor(0x9b59b6)
    static var skltn_wetAsphalt   = UIColor(0x34495e)
    static var skltn_nephritis    = UIColor(0x27ae60)
    static var skltn_belizeHole   = UIColor(0x2980b9)
    static var skltn_wisteria     = UIColor(0x8e44ad)
    static var skltn_midnightBlue = UIColor(0x2c3e50)
    static var skltn_sunFlower    = UIColor(0xf1c40f)
    static var skltn_carrot       = UIColor(0xe67e22)
    static var skltn_alizarin     = UIColor(0xe74c3c)
    static var skltn_clouds       = UIColor(0xecf0f1)
    static var skltn_concrete     = UIColor(0x95a5a6)
    static var skltn_flatOrange   = UIColor(0xf39c12)
    static var skltn_pumpkin      = UIColor(0xd35400)
    static var skltn_pomegranate  = UIColor(0xc0392b)
    static var skltn_silver       = UIColor(0xbdc3c7)
    static var skltn_asbestos     = UIColor(0x7f8c8d)
}

