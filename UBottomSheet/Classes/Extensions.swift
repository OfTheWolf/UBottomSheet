//
//  Extensions.swift
//  UBottomSheet
//
//  Created by ugur on 19.09.2019.
//  Copyright © 2019 otw. All rights reserved.
//

import UIKit

extension UBottomSheetCoordinatorDataSource where Self: UIViewController {
    func ub_add(_ child: UIViewController, in container: UIView, animated: Bool = true) {
        addChild(child)
        container.addSubview(child.view)
        child.didMove(toParent: self)
        let minY = self.sheetPositions(view.frame.height).min() ?? 0
        let f = CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width, height: view.frame.maxY - minY)
        if animated{
            container.frame = f.offsetBy(dx: 0, dy: f.height)
            child.view.frame = container.bounds
            UIView.animate(withDuration: 0.3, animations: {
                container.frame = f
            }) { (_) in
                self.view.layoutIfNeeded()
            }
        }else{
            child.view.pinToEdges(to: container)
        }
        
    }

    func ub_remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }

}

extension UIView{
    func pinToEdges(to view: UIView, insets: UIEdgeInsets = .zero){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: insets.right).isActive = true
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
