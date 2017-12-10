//
//  SetItemVC.swift
//  InventoryTrackingApp
//
//  Created by onur hüseyin çantay on 9.12.2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import UIKit

class SetItemVC: BaseVC {
    @IBOutlet weak var stackType : UIStackView!
    @IBOutlet weak var stackName : UIStackView!
    @IBOutlet weak var stackCount : UIStackView!
    @IBOutlet weak var stackRoom : UIStackView!
    @IBOutlet weak var atamaButton : UIButton!
    @IBOutlet weak var gestureType : UIGestureRecognizer!
    @IBOutlet weak var gestureName : UIGestureRecognizer!
    @IBOutlet weak var gestureCount : UIGestureRecognizer!
    @IBOutlet weak var gestureRoom : UIGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        setGesturSelectors()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setGesturSelectors()
        HideStackVisibilty()
        print("SetItemVC")
    }

    func setGesturSelectors()  {
        self.gestureType.addTarget(self, action: #selector(turPressed))
        self.gestureName.addTarget(self, action: #selector(namePressed))
        self.gestureCount.addTarget(self, action: #selector(countPressed))
        self.gestureRoom.addTarget(self, action: #selector(RoomPressed))
    }
    func HideStackVisibilty()  {
        self.stackType.isHidden = true
        self.stackName.isHidden = true
        self.stackCount.isHidden = true
        self.atamaButton.isHidden = true
    }
    func RoomPressed()  {
        self.stackType.isHidden = false
    }
    func turPressed()  {
        self.stackName.isHidden = false
    }
    func namePressed()  {
        self.stackCount.isHidden = false
    }
    func countPressed()  {
        self.atamaButton.isHidden = false
    }
    

}
