//
//  Pannable.swift
//  Pods-UBottomSheet_Example
//
//  Created by ugur on 19.09.2019.
//

import UIKit

public protocol Pannable {
    func attach(to parent: UIViewController)
    func detach()
}
 
