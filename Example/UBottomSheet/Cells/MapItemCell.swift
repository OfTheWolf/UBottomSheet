//
//  MapItemCell.swift
//  UBottomSheet_Example
//
//  Created by ugur on 1.05.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

struct MapItemCellViewModel {
    let image: UIImage?
    let title: String
    let subtitle: String
}

class MapItemCell: UITableViewCell {

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        leftImageView.tintColor = UIColor.red
    }
    
    func configure(model: MapItemCellViewModel){
        nameLabel.text = model.title
        descriptionLabel.text = model.subtitle
//        leftImageView.image = model.image
    }


}
