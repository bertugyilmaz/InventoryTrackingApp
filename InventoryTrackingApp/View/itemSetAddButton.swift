//
//  itemSetAddButton.swift
//  InventoryTrackingApp
//
//  Created by onur hüseyin çantay on 10.12.2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import UIKit

class itemSetAddButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 8
        self.backgroundColor = Colors.BUTTON_BLUE
        self.titleLabel?.textColor = UIColor.white
    }

}
