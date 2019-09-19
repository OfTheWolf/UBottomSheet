//
//  Extensions.swift
//  UBottomSheet
//
//  Created by ugur on 19.09.2019.
//  Copyright © 2019 otw. All rights reserved.
//

import UIKit

extension UIViewController {
    func ub_add(_ child: UIViewController, in _view: UIView? = nil) {
        addChild(child)
        if let v = _view{
            view.addSubview(v)
            v.addSubview(child.view)
        }else{
            view.addSubview(child.view)
        }
        child.didMove(toParent: self)
    }
    
    func ub_remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

extension UIView {
    
    func ub_firstSubView<T: UIView>(ofType type: T.Type) -> T? {
        var resultView: T?
        for view in subviews {
            if let view = view as? T {
                resultView = view
                break
            }
            else {
                if let foundView = view.ub_firstSubView(ofType: T.self) {
                    resultView = foundView
                    break
                }
            }
        }
        return resultView
    }
}


extension UIView {
    
    func edges(_ edges: UIRectEdge, to view: UIView, offset: UIEdgeInsets) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if edges.contains(.top) || edges.contains(.all) {
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: offset.top).isActive = true
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: offset.bottom).isActive = true
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset.left).isActive = true
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: offset.right).isActive = true
        }
    }
}
