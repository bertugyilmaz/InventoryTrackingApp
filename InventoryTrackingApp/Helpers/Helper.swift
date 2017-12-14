//
//  Helper.swift
//  InventoryTrackingApp
//
//  Created by Bertuğ YILMAZ on 13/12/2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    
    static func showAlertView(title: String, message: String) -> UIAlertController{
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertView.addAction(okButton)
        return alertView
    }
}
