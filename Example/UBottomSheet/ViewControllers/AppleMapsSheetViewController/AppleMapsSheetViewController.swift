//
//  AppleMapsSheetViewController.swift
//  UBottomSheet_Example
//
//  Created by ugur on 1.05.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import UBottomSheet

class AppleMapsSheetViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var sheetCoordinator: UBottomSheetCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "EmbeddedCell", bundle: nil), forCellReuseIdentifier: "EmbeddedCell")
        tableView.register(UINib(nibName: "MapItemCell", bundle: nil), forCellReuseIdentifier: "MapItemCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sheetCoordinator?.startTracking(item: self)
    }
}

extension AppleMapsSheetViewController: Draggable{
    func draggableView() -> UIScrollView? {
        return tableView
    }
}

extension AppleMapsSheetViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Favorites"
        default:
            return "Recently Viewed"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmbeddedCell", for: indexPath) as! EmbeddedCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MapItemCell", for: indexPath) as! MapItemCell
            let title: String
            let subtitle: String
            switch indexPath.row {
            case 0:
                title = "Click To Add New Sheet"
                subtitle = "Row \(indexPath.row) (Move independently)"
            case 1:
                title = "Click To Add Sheet Child"
                subtitle = "Row \(indexPath.row) (Move all sheets together)"
            default:
                title = "No Action"
                subtitle = "Row \(indexPath.row)"
            }
            let model = MapItemCellViewModel(image: nil, title: title, subtitle: subtitle)
            cell.configure(model: model)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = LabelViewController()

        switch indexPath.row {
        case 0:
            let sc = UBottomSheetCoordinator(parent: sheetCoordinator!.parent)
            vc.sheetCoordinator = sc
            sc.addSheet(vc, to: sheetCoordinator!.parent)
        case 1:
            vc.sheetCoordinator = sheetCoordinator
            sheetCoordinator?.addSheetChild(vc)
        default:
            title = "No Action"
        }
        
    }
}
