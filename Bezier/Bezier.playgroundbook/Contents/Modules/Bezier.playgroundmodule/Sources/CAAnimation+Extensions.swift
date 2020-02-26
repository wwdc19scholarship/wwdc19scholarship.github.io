//
//  CAAnimation+Extensions.swift
//  DrawVC
//
//  Created by scauos on 2019/3/20.
//  Copyright © 2019 scauos. All rights reserved.
//

import QuartzCore
import UIKit

class CAAnimationHandler: NSObject, CAAnimationDelegate {
    
    var completion: ((Bool) -> Void)?
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        completion?(flag)
    }
}

public extension CAAnimation {
    public var completion: ((Bool) -> Void)? {
        set {
            if let animationDelegate = delegate as? CAAnimationHandler {
                animationDelegate.completion = newValue
            } else {
                let animationDelegate = CAAnimationHandler()
                animationDelegate.completion = newValue
                delegate = animationDelegate
            }
        }
        get {
            if let animationDelegate = delegate as? CAAnimationHandler {
                return animationDelegate.completion
            }
            return nil
        }
    }
}
public extension CALayer {
    public func removeLayerAndAnimation() {
        if let subs = self.sublayers {
            _ = subs.map{ $0.removeLayerAndAnimation() }
        } else {
            self.removeAllAnimations()
            self.removeFromSuperlayer()
        }
    }
}
extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.x, y: -origin.y,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage ?? self
        }
        
        return self
    }
}
