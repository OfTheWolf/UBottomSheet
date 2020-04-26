//
//  PassThroughView.swift
//  BottomSheetDemo
//
//  Created by ugur on 19.04.2020.
//  Copyright © 2020 Sobe. All rights reserved.
//

import UIKit

public class PassThroughView: UIView {
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
         let view = super.hitTest(point, with: event)
         return view == self ? nil : view
     }
}
