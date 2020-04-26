//
//  Extensions.swift
//  UBottomSheet
//
//  Created by ugur on 19.09.2019.
//  Copyright © 2019 otw. All rights reserved.
//

import UIKit

@nonobjc extension UIViewController {
    func ub_add(_ child: UIViewController, in container: UIView, animated: Bool = true) {
        addChild(child)
        container.addSubview(child.view)
        child.didMove(toParent: self)
        child.view.pinToEdges(to: container)
//        if animated{
//            child.view.frame = container.bounds.offsetBy(dx: 0, dy: container.bounds.height)
//            UIView.animate(withDuration: 0.3) {
//                child.view.frame = container.bounds
//            }
//        }else{
//            child.view.frame = container.bounds
//        }
        
    }

    func ub_remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }

}

extension UIView{
    func pinToEdges(to view: UIView){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func constraint(_ parent: UIViewController, for attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint?{
        return parent.view.constraints.first(where: { (c) -> Bool in
             c.firstItem as? UIView == self && c.firstAttribute == attribute
         })
    }
}

extension Array where Element == CGFloat{
    func nearest(to x: CGFloat) -> CGFloat{
        return self.reduce(self.first!) { abs($1 - x) < abs($0 - x) ? $1 : $0 }
    }
}
