//
//  SimpleTableCell.swift
//  UBottomSheet
//
//  Created by ugur on 9.09.2018.
//  Copyright © 2018 otw. All rights reserved.
//

import UIKit

struct SimpleTableCellViewModel {
    let image: UIImage?
    let title: String
    let subtitle: String
}

class SimpleTableCell: UITableViewCell {

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        leftImageView.tintColor = UIColor.red
    }
    
    func configure(model: SimpleTableCellViewModel){
        nameLabel.text = model.title
        descriptionLabel.text = model.subtitle
//        leftImageView.image = model.image
    }


}
