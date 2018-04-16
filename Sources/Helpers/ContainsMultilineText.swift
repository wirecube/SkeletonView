//
//  ContainsMultilineText.swift
//  SkeletonView-iOS
//
//  Created by Juanpe Catalán on 07/11/2017.
//  Copyright © 2017 SkeletonView. All rights reserved.
//

import UIKit

private enum AssociatedKeys {
    static var lastLineFillingPercent = "lastLineFillingPercent"
    static var forceShortenLastLine = "forceShortenLastLine"
}

protocol ContainsMultilineText {
    var numLines: Int { get }
    var lastLineSkeletonFillPercent: Int { get }
    var forceShortenLastSkeletonLine: Bool { get }
}

extension ContainsMultilineText {
    var numLines: Int { return 0 }
}

public extension UILabel {
    
    @IBInspectable
    var lastLineSkeletonFillPercent: Int {
        get { return lastLineFillingPercent }
        set { lastLineFillingPercent = min(newValue, 100) }
    }
    
    @IBInspectable
    var forceShortenLastSkeletonLine: Bool {
        get { return forceShorten }
        set { forceShorten = newValue }
    }
}

public extension UITextView {
    
    @IBInspectable
    var lastLineSkeletonFillPercent: Int {
        get { return lastLineFillingPercent }
        set { lastLineFillingPercent = min(newValue, 100) }
    }

    @IBInspectable
    var forceShortenLastSkeletonLine: Bool {
        get { return forceShorten }
        set { forceShorten = newValue }
    }
}

extension UILabel: ContainsMultilineText {
    var numLines: Int { 
        return numberOfLines
    }
    
    var lastLineFillingPercent: Int {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.lastLineFillingPercent) as? Int ?? SkeletonDefaultConfig.multilineLastLineFillPercent }
        set { objc_setAssociatedObject(self, &AssociatedKeys.lastLineFillingPercent, newValue, AssociationPolicy.retain.objc) }
    }
    
    var forceShorten: Bool {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.forceShortenLastLine) as? Bool ?? false }
        set { objc_setAssociatedObject(self, &AssociatedKeys.forceShortenLastLine, newValue, AssociationPolicy.retain.objc) }
    }

}

extension UITextView: ContainsMultilineText {
    
    var lastLineFillingPercent: Int {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.lastLineFillingPercent) as? Int ?? SkeletonDefaultConfig.multilineLastLineFillPercent }
        set { objc_setAssociatedObject(self, &AssociatedKeys.lastLineFillingPercent, newValue, AssociationPolicy.retain.objc) }
    }
    
    var forceShorten: Bool {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.forceShortenLastLine) as? Bool ?? false }
        set { objc_setAssociatedObject(self, &AssociatedKeys.forceShortenLastLine, newValue, AssociationPolicy.retain.objc) }
    }
}
