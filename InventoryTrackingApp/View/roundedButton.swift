//
//  roundedButton.swift
//  InventoryTrackingApp
//
//  Created by onur hüseyin çantay on 8.12.2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import UIKit

class roundedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
}
