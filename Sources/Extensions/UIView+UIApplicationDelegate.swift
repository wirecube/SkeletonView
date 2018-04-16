//
//  UIView+UIApplicationDelegate.swift
//  SkeletonView-iOS
//
//  Created by Juanpe Catalán on 08/02/2018.
//  Copyright © 2018 SkeletonView. All rights reserved.
//

import UIKit

extension UIView {
    
    enum SkeletonConstants {
        static let becomeActiveNotification = NSNotification.Name.UIApplicationDidBecomeActive
        static let enterForegroundNotification = NSNotification.Name.UIApplicationDidEnterBackground
        static let needAnimatedSkeletonKey = "needAnimateSkeleton"
    }
    
    func addAppNotificationsObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: SkeletonConstants.becomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: SkeletonConstants.enterForegroundNotification, object: nil)
    }
    
    func removeAppNoticationsObserver() {
        NotificationCenter.default.removeObserver(self, name: SkeletonConstants.becomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: SkeletonConstants.enterForegroundNotification, object: nil)
    }
    
    @objc func appDidBecomeActive() {
        if UserDefaults.standard.bool(forKey: SkeletonConstants.needAnimatedSkeletonKey) {
            startSkeletonAnimation()
        }
    }
    
    @objc func appDidEnterBackground() {
        UserDefaults.standard.set((isSkeletonActive && skeletonIsAnimated), forKey: SkeletonConstants.needAnimatedSkeletonKey)
    }
}
