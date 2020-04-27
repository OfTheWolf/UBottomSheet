//
//  SimpleCollectionCell.swift
//  UBottomSheet_Example
//
//  Created by ugur on 27.04.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

struct CollectionModel {
    let image: UIImage?
    let title: String
}

class SimpleCollectionCell: UICollectionViewCell {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var lbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        button.layer.cornerRadius = button.frame.height/2
        button.layer.masksToBounds = true
    }
    
    func configure(with model: CollectionModel){
        button.setImage(model.image, for: .normal)
        lbl.text = model.title
    }
}
