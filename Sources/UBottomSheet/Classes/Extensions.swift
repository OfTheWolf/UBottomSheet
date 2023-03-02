//
//  Extensions.swift
//  UBottomSheet
//
//  Created by ugur on 19.09.2019.
//  Copyright © 2019 otw. All rights reserved.
//

import UIKit

extension UIViewController {
    func ub_add(_ child: UIViewController,
                in container: UIView,
                animated: Bool,
                topInset: CGFloat,
                completion: (() -> Void)? = nil) {
        addChild(child)
        container.addSubview(child.view)
        child.didMove(toParent: self)
        let frame = CGRect(x: view.frame.minX,
                           y: view.frame.minY,
                           width: view.frame.width,
                           height: view.frame.maxY - topInset)
        if animated {
            container.frame = frame.offsetBy(dx: 0, dy: frame.height)
            child.view.frame = container.bounds
            UIView.animate(withDuration: 0.3, animations: {
                container.frame = frame
            }) { _ in
                completion?()
            }
        } else {
            container.frame = frame
            child.view.frame = container.bounds
            completion?()
        }
        
    }

    func ub_remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }

}

extension UIView {
    func pinToEdges(to view: UIView, insets: UIEdgeInsets = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: insets.right).isActive = true
    }
    
    func constraint(_ parent: UIViewController, for attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        return parent.view.constraints.first(where: { (constraint) -> Bool in
            constraint.firstItem as? UIView == self && constraint.firstAttribute == attribute
         })
    }
}

extension Array where Element == CGFloat {
    func nearest(to x: CGFloat) -> CGFloat? {
        guard let first = first else { return nil }
        return self.reduce(first) { abs($1 - x) < abs($0 - x) ? $1 : $0 }
    }
}
