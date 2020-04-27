//
//  MapsDemoBottomSheetController.swift
//  UBottomSheet
//
//  Created by ugur on 19.09.2019.
//  Copyright © 2019 otw. All rights reserved.
//

import UIKit
import UBottomSheet

class MapsDemoBottomSheetController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    
    var sheetCoordinator: UBottomSheetCoordinator?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        sheetCoordinator?.startTracking(item: self)
        
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension MapsDemoBottomSheetController: Draggable{
    
    func draggableView() -> UIScrollView? {
        return tableView
    }
}


extension MapsDemoBottomSheetController: UITableViewDelegate, UITableViewDataSource{
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTableCell", for: indexPath) as! SimpleTableCell
            let model = SimpleTableCellViewModel(image: nil, title: "Title \(indexPath.row)", subtitle: "Subtitle \(indexPath.row)")
            cell.configure(model: model)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sc = UBottomSheetCoordinator(parent: sheetCoordinator!.parent)
        let vc = LabelViewController()
        vc.sheetCoordinator = sc
        sc.addSheet(vc, to: sheetCoordinator!.parent)
    }
}
