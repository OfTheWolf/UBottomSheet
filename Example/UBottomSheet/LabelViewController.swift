//
//  LabelViewController.swift
//  UBottomSheet_Example
//
//  Created by ugur on 27.04.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import UBottomSheet

class LabelViewController: UIViewController, Draggable {
    var sheetCoordinator: UBottomSheetCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sheetCoordinator?.startTracking(item: self)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissAction(){
        sheetCoordinator?.removeSheetChild(item: self)
    }

}
