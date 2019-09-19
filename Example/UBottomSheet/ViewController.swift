//
//  ViewController.swift
//  UBottomSheet
//
//  Created by OfTheWolf on 09/19/2019.
//  Copyright (c) 2019 OfTheWolf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        //Create a view controller that inherits BottomSheetController and attach to the current viewcontroller
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapsDemoBottomSheetController") as! MapsDemoBottomSheetController
        //Add bottom sheet to the current viewcontroller
        vc.attach(to: self)
        
//        //Remove sheet from the current viewcontroller
//        vc.detach()
        
    }


}

