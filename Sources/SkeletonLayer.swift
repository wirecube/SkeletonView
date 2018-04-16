//
//  SkeletonLayer.swift
//  SkeletonView-iOS
//
//  Created by Juanpe Catalán on 02/11/2017.
//  Copyright © 2017 SkeletonView. All rights reserved.
//

import UIKit

class SkeletonLayerFactory {
    
    func makeSkeletonLayer(withType type: SkeletonType, usingColors colors: [UIColor], andHolder holder: UIView) -> SkeletonLayer {
        return SkeletonLayer(withType: type, usingColors: colors, andSkeletonHolder: holder)
    }
    
    func makeMultilineLayer(withType type: SkeletonType, for index: Int, width: CGFloat) -> CALayer {
        let spaceRequiredForEachLine = SkeletonDefaultConfig.multilineHeight + SkeletonDefaultConfig.multilineSpacing
        let layer = type.layer
        layer.anchorPoint = .zero
        layer.name = CALayer.skeletonSubLayersName
        layer.frame = CGRect(x: 0.0, y: CGFloat(index) * spaceRequiredForEachLine, width: width, height: SkeletonDefaultConfig.multilineHeight)
        return layer
    }
}

public typealias SkeletonLayerAnimation = (CALayer) -> CAAnimation

public enum SkeletonType {
    case solid
    case gradient
    
    var layer: CALayer {
        switch self {
        case .solid:
            return CALayer()
        case .gradient:
            return CAGradientLayer()
        }
    }
    
    var layerAnimation: SkeletonLayerAnimation {
        switch self {
        case .solid:
            return { $0.skltn_pulse }
        case .gradient:
            return { $0.skltn_sliding }
        }
    }
}

struct SkeletonLayer {
    
    private var maskLayer: CALayer
    private weak var holder: UIView?
    
    var type: SkeletonType {
        return maskLayer is CAGradientLayer ? .gradient : .solid
    }
    
    var contentLayer: CALayer {
        return maskLayer
    }
    
    init(withType type: SkeletonType, usingColors colors: [UIColor], andSkeletonHolder holder: UIView) {
        self.holder = holder
        self.maskLayer = type.layer
        self.maskLayer.anchorPoint = .zero
        self.maskLayer.cornerRadius = holder.skeletonCornerRadius
        self.maskLayer.bounds = holder.skltn_maxBoundsEstimated
        addMultilinesIfNeeded()
        self.maskLayer.skltn_tint(withColors: colors)
    }
    
    func removeLayer(animated: Bool = false) {
        if animated == false {
            stopAnimation()
            maskLayer.removeFromSuperlayer()
        } else {
            let fadeAnimation = CABasicAnimation(keyPath: "opacity")
            fadeAnimation.toValue = 0
            fadeAnimation.duration = 0.3
            fadeAnimation.delegate = SkeletonLayerAnimationDelegate(layer: self)
            maskLayer.opacity = 0
            maskLayer.add(fadeAnimation, forKey: "fadeOut")
        }
    }
    
    func addMultilinesIfNeeded() {
        guard let multiLineView = holder as? ContainsMultilineText else { return }
        maskLayer.skltn_addMultilinesLayers(lines: multiLineView.numLines, type: type, lastLineFillPercent: multiLineView.lastLineFillingPercent, cornerRadius: self.holder?.skeletonCornerRadius ?? 0)
    }
}

extension SkeletonLayer {

    func start(_ anim: SkeletonLayerAnimation? = nil) {
        let animation = anim ?? type.layerAnimation
        contentLayer.skltn_playAnimation(animation, "skeletonAnimation")
    }
    
    func stopAnimation() {
        contentLayer.skltn_stopAnimation(forKey: "skeletonAnimation")
    }
}

class SkeletonLayerAnimationDelegate: NSObject, CAAnimationDelegate {
    
    var layer: SkeletonLayer
    init(layer: SkeletonLayer) {
        self.layer = layer
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.layer.removeLayer(animated: false)
    }
}
