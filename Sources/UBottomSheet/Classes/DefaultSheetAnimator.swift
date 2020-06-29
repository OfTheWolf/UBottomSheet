//
//  DefaultSheetAnimator.swift
//  BottomSheetDemo
//
//  Created by ugur on 24.04.2020.
//  Copyright © 2020 Sobe. All rights reserved.
//

import UIKit

public class DefaultSheetAnimator: Animatable {
    public func animate(animations: @escaping () -> Void, completion: ((Bool) -> Void)?){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [.curveEaseInOut, .allowUserInteraction], animations: animations, completion: completion)
    }
}
