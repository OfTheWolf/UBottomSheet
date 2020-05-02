//
//  Extensions.swift
//  UBottomSheet_Example
//
//  Created by ugur on 1.05.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

extension UIView{
    func roundCorners(corners: UIRectCorner, radius: CGFloat, rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
