//
//  RoomTableViewCell.swift
//  InventoryTrackingApp
//
//  Created by Bertuğ YILMAZ on 10/12/2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import UIKit

class RoomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    var room : Room!{
        didSet{
//            if(room.roomType.isEqualToString(find: RoomType.Laboratory.rawValue) ){
//                imgView.image = UIImage(named:RoomType.Laboratory.rawValue)
//                typeLabel.text = RoomType.Laboratory.rawValue
//            }else{
//                imgView.image = UIImage(named:RoomType.Class.rawValue)
//                typeLabel.text = RoomType.Class.rawValue
//            }
            idLabel.text = room.Id
            typeLabel.text = room.roomType
            countLabel.text = room.roomName
        }
    }
}
