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
        
        tableView.dataSource = self
    }

}

extension MapsDemoBottomSheetController: Draggable{
    
    func draggableView() -> UIScrollView? {
        return tableView
    }
}


extension MapsDemoBottomSheetController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTableCell", for: indexPath) as! SimpleTableCell
        let model = SimpleTableCellViewModel(image: nil, title: "Title \(indexPath.row)", subtitle: "Subtitle \(indexPath.row)")
        cell.configure(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
