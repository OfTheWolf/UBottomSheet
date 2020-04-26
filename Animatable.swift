//
//  Animatable.swift
//  BottomSheetDemo
//
//  Created by ugur on 24.04.2020.
//  Copyright © 2020 Sobe. All rights reserved.
//

import Foundation

/**
 Conform this protocol to creat ecustom finish animation on pan gesture ended.
 */
public protocol Animatable {
    func animate(animations: @escaping () -> Void, completion: ((Bool) -> Void)?)
}
