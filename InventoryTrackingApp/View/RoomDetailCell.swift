//
//  RoomDetailCell.swift
//  InventoryTrackingApp
//
//  Created by onur hüseyin çantay on 12.12.2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import UIKit

class RoomDetailCell: UITableViewCell {
    
    @IBOutlet weak var ResponsiblePerson : UILabel!
    @IBOutlet weak var ItemCode : UILabel!
    @IBOutlet weak var ItemName : UILabel!
    @IBOutlet weak var ItemCount : UILabel!
    @IBOutlet weak var Icon : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var item : Item!{
        didSet{
            ItemCode.text = item.Id
            ItemName.text = item.name
            ItemCount.text = item.count
            switch item.type{
            case ItemType.TEKNOLOJI.rawValue:
                self.Icon.image = UIImage(named: "computer-icon")
            case ItemType.TEKNOLOJIK_MOBILYA.rawValue :
                self.Icon.image = UIImage(named: "table-icon")
            case ItemType.MOBILYA.rawValue :
                self.Icon.image = UIImage(named:"desk-chair")
            default:
                self.Icon.image = UIImage(named:"cupboard")
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
