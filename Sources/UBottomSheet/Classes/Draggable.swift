//
//  Draggable.swift
//  BottomSheetDemo
//
//  Created by ugur on 24.04.2020.
//  Copyright © 2020 Sobe. All rights reserved.
//

import UIKit

public typealias DraggableItem = Draggable & UIViewController

///UIViewControllers must conform this to make use of UBottomSheet gesture handling
public protocol Draggable {
    var sheetCoordinator: UBottomSheetCoordinator? { get set }
    func draggableView() -> UIScrollView?
}

///draggableView sets to nil by default. Set any scroll view to track.
public extension Draggable {
    func draggableView() -> UIScrollView? {
        return nil
    }
}
