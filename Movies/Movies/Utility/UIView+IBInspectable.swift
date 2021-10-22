//
//  UIView+IBInspectable.swift
//  Movies
//
//  Created by Rajesh Billakanti on 19/10/21.
//

import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}

