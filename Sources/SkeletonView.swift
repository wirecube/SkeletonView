//
//  SkeletonView.swift
//  SkeletonView
//
//  Created by Juanpe Catalán on 01/11/2017.
//  Copyright © 2017 SkeletonView. All rights reserved.
//

import UIKit

public extension UIView {
    
    func showSkeleton(usingColor color: UIColor = SkeletonDefaultConfig.tintColor) {
        showSkeleton(withType: .solid, usingColors: [color])
    }
    
    func showGradientSkeleton(usingGradient gradient: SkeletonGradient = SkeletonDefaultConfig.gradient) {
        showSkeleton(withType: .gradient, usingColors: gradient.colors)
    }
    
    func showAnimatedSkeleton(usingColor color: UIColor = SkeletonDefaultConfig.tintColor, animation: SkeletonLayerAnimation? = nil) {
        showSkeleton(withType: .solid, usingColors: [color], animated: true, animation: animation)
    }
    
    func showAnimatedGradientSkeleton(usingGradient gradient: SkeletonGradient = SkeletonDefaultConfig.gradient, animation: SkeletonLayerAnimation? = nil) {
        showSkeleton(withType: .gradient, usingColors: gradient.colors, animated: true, animation: animation)
    }
    
    func hideSkeleton(reloadDataAfter reload: Bool = true, animated: Bool = false) {
        skeletonFlowDelegate?.willBeginHidingSkeletons(withRootView: self)
        recursiveHideSkeleton(reloadDataAfter: reload, animated: animated)
    }
    
    func startSkeletonAnimation(_ anim: SkeletonLayerAnimation? = nil) {
        skeletonIsAnimated = true
        recursiveSearch(inArray: subviewsSkeletonables,
                        leafBlock:  startSkeletonLayerAnimationBlock(anim)) {
                            $0.startSkeletonAnimation(anim)
                        }
    }

    func stopSkeletonAnimation() {
        skeletonIsAnimated = false
        recursiveSearch(inArray: subviewsSkeletonables,
                        leafBlock: stopSkeletonLayerAnimationBlock) {
                            $0.stopSkeletonAnimation()
        }
    }
}

extension UIView {
    
    func showSkeleton(withType type: SkeletonType = .solid, usingColors colors: [UIColor], animated: Bool = false, animation: SkeletonLayerAnimation? = nil) {
        skeletonIsAnimated = animated
        skeletonFlowDelegate = SkeletonFlowHandler()
        skeletonFlowDelegate?.willBeginShowingSkeletons(withRootView: self)
        recursiveShowSkeleton(withType: type, usingColors: colors, animated: animated, animation: animation)
    }
    
    fileprivate func recursiveShowSkeleton(withType type: SkeletonType = .solid, usingColors colors: [UIColor], animated: Bool = false, animation: SkeletonLayerAnimation? = nil) {
        addDummyDataSourceIfNeeded()
        recursiveSearch(inArray: subviewsSkeletonables,
                        leafBlock: {
                            guard !isSkeletonActive else { return }
                            isUserInteractionEnabled = false
                            (self as? PrepareForSkeleton)?.prepareViewForSkeleton()
                            addSkeletonLayer(withType: type, usingColors: colors, animated: animated, animation: animation)
        }) {
            $0.recursiveShowSkeleton(withType: type, usingColors: colors, animated: animated, animation: animation)
        }
    }
    
    fileprivate func recursiveHideSkeleton(reloadDataAfter reload: Bool = true, animated: Bool = true) {
        removeDummyDataSourceIfNeeded()
        isUserInteractionEnabled = true
        recursiveSearch(inArray: subviewsSkeletonables,
                        leafBlock: {
                            removeSkeletonLayer(animated: animated)
                        }, recursiveBlock: {
                            $0.recursiveHideSkeleton(reloadDataAfter: reload, animated: animated)
                        })
    }
    
    fileprivate func startSkeletonLayerAnimationBlock(_ anim: SkeletonLayerAnimation? = nil) -> VoidBlock {
        return {
            guard let layer = self.skeletonLayer else { return }
            layer.start(anim)
        }
    }
    
    fileprivate var stopSkeletonLayerAnimationBlock: VoidBlock {
        return {
            guard let layer = self.skeletonLayer else { return }
            layer.stopAnimation()
        }
    }
}

extension UIView {
    @objc var subviewsSkeletonables: [UIView] {
        return subviews.filter { $0.isSkeletonable }
    }
}

extension UITableView {
    override var subviewsSkeletonables: [UIView] {
        return visibleCells.filter { $0.isSkeletonable }
    }
}

extension UITableViewCell {
    override var subviewsSkeletonables: [UIView] {
        return contentView.subviews.filter { $0.isSkeletonable }
    }
}

extension UICollectionView {
    override var subviewsSkeletonables: [UIView] {
        return subviews.filter { $0.isSkeletonable }
    }
}

extension UICollectionViewCell {
    override var subviewsSkeletonables: [UIView] {
        return contentView.subviews.filter { $0.isSkeletonable }
    }
}

extension UIStackView {
    override var subviewsSkeletonables: [UIView] {
        return arrangedSubviews.filter { $0.isSkeletonable }
    }
}

extension UIView {
    
    func addSkeletonLayer(withType type: SkeletonType, usingColors colors: [UIColor], gradientDirection direction: SkeletonGradientDirection? = nil, animated: Bool, animation: SkeletonLayerAnimation? = nil) {
        self.skeletonLayer = SkeletonLayerFactory().makeSkeletonLayer(withType: type, usingColors: colors, andHolder: self)
        layer.insertSublayer(skeletonLayer!.contentLayer, at: UInt32.max)
        if animated { skeletonLayer!.start(animation) }
        skeletonStatus = .on
    }
    
    func removeSkeletonLayer(animated: Bool = false) {
        guard isSkeletonActive,
            let layer = skeletonLayer else { return }
        layer.removeLayer(animated: animated)
        skeletonLayer = nil
        skeletonStatus = .off
    }
}

