//
//  MapsDemoBottomSheetController.swift
//  UBottomSheet
//
//  Created by ugur on 19.09.2019.
//  Copyright © 2019 otw. All rights reserved.
//

import UIKit
import UBottomSheet

class MapsDemoBottomSheetController: BottomSheetController{
    
    //MARK: BottomSheetController configurations
//    override var initialPosition: SheetPosition {
//        return .middle
//    }
        
//    override var topYPercentage: CGFloat
    
//    override var bottomYPercentage: CGFloat
    
//    override var middleYPercentage: CGFloat
    
//    override var bottomInset: CGFloat
    
//    override var topInset: CGFloat
    
//    Don't override if not necessary as it is auto-detected
//    override var scrollView: UIScrollView?{
//        return put_your_tableView, collectionView, etc.
//    }
    
//    //Override this to apply custom animations
//    override func animate(animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
//        UIView.animate(withDuration: 0.3, animations: animations)
//    }
    
//    To change sheet position manually
//    call ´changePosition(to: .top)´ anywhere in the code

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
