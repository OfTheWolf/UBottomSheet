//
//  ViewController.swift
//  UBottomSheet
//
//  Created by OfTheWolf on 09/19/2019.
//  Copyright (c) 2019 OfTheWolf. All rights reserved.
//

import UIKit
import UBottomSheet

class ViewController: UIViewController {
    var sheetCoordinator: UBottomSheetCoordinator!

    override func viewDidLoad() {
        super.viewDidLoad()
        sheetCoordinator = UBottomSheetCoordinator(parent: self,
                                                   delegate: self)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapsDemoBottomSheetController") as! MapsDemoBottomSheetController
        vc.sheetCoordinator = sheetCoordinator
        sheetCoordinator.addSheet(vc, to: self, didContainerCreate: { container in
            self.addBackDimmingBackView(below: container)
            let f = self.view.frame
            let rect = CGRect(x: f.minX, y: f.minY, width: f.width, height: f.height)
            container.roundCorners(corners: [.topLeft, .topRight], radius: 10, rect: rect)
        })
        sheetCoordinator.setCornerRadius(10)
        
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        sheetCoordinator.addDropShadowIfNotExist()
    }
    
    private func addBackDimmingBackView(below container: UIView){
        let backView = PassThroughView()
        self.view.insertSubview(backView, belowSubview: container)
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        backView.bottomAnchor.constraint(equalTo: container.topAnchor, constant: 0).isActive = true
        backView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        backView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
}

extension ViewController: UBottomSheetCoordinatorDelegate{

    func bottomSheet(_ container: UIView?, didChange state: SheetTranslationState) {
//        switch state {
//        case .progressing(_, let percent):
//            self.backView?.backgroundColor = UIColor.black.withAlphaComponent(max(0.2, percent/100 * 0.8))
//        case .finished(_, let percent):
//            self.backView?.backgroundColor = UIColor.black.withAlphaComponent(max(0.2, percent/100 * 0.8))
//        default:
//            break
//        }
    }

    func bottomSheet(_ container: UIView?, finishTranslateWith extraAnimation: @escaping ((CGFloat) -> Void) -> Void) {
        extraAnimation({ percent in
//            self.backView?.backgroundColor = UIColor.black.withAlphaComponent(max(0.2, percent/100 * 0.8))
        })
    }
    
}

extension UIView{
    func roundCorners(corners: UIRectCorner, radius: CGFloat, rect: CGRect) {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
       }
}
