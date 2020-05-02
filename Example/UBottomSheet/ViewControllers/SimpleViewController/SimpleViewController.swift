//
//  SimpleViewController.swift
//  UBottomSheet_Example
//
//  Created by ugur on 1.05.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import UBottomSheet

class SimpleViewController: UIViewController {
    var sheetCoordinator: UBottomSheetCoordinator!
    
    var sheetVC: DraggableItem!
    var useNavController = false
    var didLayoutOnce: Bool = false
    var dataSource: UBottomSheetCoordinatorDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard !didLayoutOnce else {return}
        didLayoutOnce = true
        sheetCoordinator = UBottomSheetCoordinator(parent: self)
        if dataSource != nil{
            sheetCoordinator.dataSource = dataSource!
        }
        
        let vc: UIViewController
        if useNavController{
            vc = UINavigationController(rootViewController: sheetVC)
            sheetVC.title = "Navigation Bar Title"
        }else{
            vc = sheetVC
        }
        sheetVC.sheetCoordinator = sheetCoordinator
        sheetCoordinator.addSheet(vc, to: self, didContainerCreate: { container in
            let f = self.view.frame
            let rect = CGRect(x: f.minX, y: f.minY, width: f.width, height: f.height)
            container.roundCorners(corners: [.topLeft, .topRight], radius: 10, rect: rect)
        })
    }    

}
