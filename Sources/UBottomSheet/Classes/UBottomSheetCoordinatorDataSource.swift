//
//  UBottomSheetCoordinatorDataSource.swift
//  BottomSheetDemo
//
//  Created by ugur on 24.04.2020.
//  Copyright © 2020 Sobe. All rights reserved.
//

import UIKit

///Data source
public protocol UBottomSheetCoordinatorDataSource: AnyObject {
    ///Gesture end animation
    var animator: Animatable? { get }
    ///Sheet positions. For example top, middle, bottom y values.
    func sheetPositions(_ availableHeight: CGFloat) -> [CGFloat]
    ///Initial sheet y position.
    func initialPosition(_ availableHeight: CGFloat) -> CGFloat
    /**
     Top rubber band logic over top limit, min sheet height.

     - parameter total: total distance from the top limit
     - parameter limit: top limit or min sheet height
    */
    func rubberBandLogicTop(_ total: CGFloat, _ limit: CGFloat) -> CGFloat
    /**
     Bottom rubber band logic below bottom limit, max sheet height.
     
      - parameter total: total distance from the bottom limit
      - parameter limit: bottom limit or max sheet height
     */
    func rubberBandLogicBottom(_ total: CGFloat, _ limit: CGFloat) -> CGFloat
}

///Default data source implementation
extension UBottomSheetCoordinatorDataSource {
    public func sheetPositions(_ availableHeight: CGFloat) -> [CGFloat] {
        return [0.2, 0.7].map { $0 * availableHeight }
    }
    
    public var animator: Animatable?{
        return DefaultSheetAnimator()
    }
    
    public func initialPosition(_ availableHeight: CGFloat) -> CGFloat {
        return availableHeight * 0.2
    }
    
    public func rubberBandLogicTop(_ total: CGFloat, _ limit: CGFloat) -> CGFloat {
        let value = limit * (1 - log10(total / limit))
        guard !value.isNaN, value.isFinite else {
            return total
        }
        return value
    }
    
    public func rubberBandLogicBottom(_ total: CGFloat, _ limit: CGFloat) -> CGFloat {
        let value = limit * (1 + log10(total / limit))
        guard !value.isNaN, value.isFinite else {
            return total
        }
        return value
    }
    
}

///By default make all the view controller conforms to the UBottomSheetCoordinatorDataSource.
extension UIViewController: UBottomSheetCoordinatorDataSource {}

