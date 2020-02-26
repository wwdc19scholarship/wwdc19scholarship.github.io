//
//  ControlView.swift
//  Book_Sources
//
//  Created by scauos on 2019/3/24.
//

import UIKit
import CoreGraphics

class ControlView: UIView {

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var bound = self.bounds
        bound = bound.insetBy(dx: -15, dy: -15)
        return bounds.contains(point)
        
    }

}
