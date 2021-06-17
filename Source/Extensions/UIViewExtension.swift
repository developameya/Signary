//
//  UIViewExtension.swift
//  Signary
//
//  Created by Ameya Bhagat on 17/06/21.
//

import UIKit

extension UIView {
    
    func rotate(_ toValue: CGFloat, duration:CFTimeInterval = 0.2) {
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
    
        self.layer.add(animation,forKey: nil)
    }
}
