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
    
    static func sumString (str1: String, str2: String) -> String{
        let str1Int = Int(str1)!
        let str2Int = Int(str2)!
        let total = str1Int + str2Int
        return String(total)
    }
    
    static func screenShotofTableView(_ tableView: UITableView) -> UIImage{
        UIGraphicsBeginImageContext(tableView.contentSize);
        
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let row = tableView.numberOfRows(inSection: 0)
        let numberofRowthatShowinscreen = 4
        var scrollCount = row / numberofRowthatShowinscreen
        
        for i in 0 ..< scrollCount {
            tableView.scrollToRow(at: IndexPath(row: (i+1)*numberofRowthatShowinscreen , section: 0), at: .top, animated: false)
            tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
        }
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return image;
    }
    
    static func createPdfFromTableView(_ tableView: UITableView) -> URL{
        let priorBounds: CGRect = tableView.bounds
        let fittedSize: CGSize = tableView.sizeThatFits(CGSize(width: priorBounds.size.width, height: tableView.contentSize.height))
        
        let pdfPageBounds: CGRect = CGRect(x: 0, y: 0, width: fittedSize.width, height: (fittedSize.height))
        let pdfData: NSMutableData = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil)
        tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
        UIGraphicsEndPDFContext()
        
        let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let documentsFileName = documentDirectories! + "/" + "items.pdf"
        
        pdfData.write(toFile: documentsFileName, atomically: true)
        let url = URL(fileURLWithPath: documentsFileName)

//        print(documentsFileName)
        return url
    }
    
    
}
