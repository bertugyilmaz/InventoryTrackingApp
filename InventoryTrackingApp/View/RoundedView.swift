//
//  RoundedView.swift
//  InventoryTrackingApp
//
//  Created by Bertuğ YILMAZ on 10/12/2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import UIKit

class RoundedView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
}
