//
//  SetItemVC.swift
//  InventoryTrackingApp
//
//  Created by onur hüseyin çantay on 9.12.2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import UIKit
import Firebase
class SetItemVC: BaseVC {
    
    @IBOutlet weak var saveButton: itemSetAddButton!
    @IBOutlet weak var tableView: UITableView!
    var alertView: UIAlertController!
    var attentionAlert = Helper.showAlertView(title: "", message: "İşleminiz Başarılı")
    var cellArr: [[String]]!
    var items = [Item]()
    var pickerView = UIPickerView()
    var rooms = [Room]()
    var selectedRow = -2
    var selectedItem : Item!
    var categorieTypes = [String]()
    var filteredItems = [Item]()
    var selectedType = ""
    var selectedName = ""
    var selectedCount = ""
    var selectedRoom = ""
    var selectedItemCountForContainer = ""
    var getRoomsCompleted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("AddItemVC")
        self.clearAllAttr()
        self.rooms.removeAll()
        self.items.removeAll()
        self.categorieTypes.removeAll()
        self.getRooms()
        self.getItems()
        self.getItemType()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    func getItemType()  {
        DataServices.ds.REF_CATEGORIES.observeSingleEvent(of: .value, with: { (snapshot) in
            if let categories = snapshot.value as? Dictionary<String,AnyObject>{
                for item in categories.keys{
                    self.categorieTypes.append(item)
                }
            }
            self.pickerView.reloadComponent(0)
        })
    }
    func filterBySelectedCategorie()  {
        for item in self.items {
            if( item.type == self.selectedType){
               self.filteredItems.append(item)
            }
        }
        self.pickerView.reloadComponent(0)
    }
    
    func clearAllAttr(){
        self.cellArr = [["Oda Seçimi", "Demirbaş Türü", "Demirbaş Adı", "Demirbaş Adedi"],
                        ["roomSelection","roomType","itemName","itemCount"],
                        ["extended","","",""]]
        self.saveButton.alpha = 0
        self.selectedItem = nil
//        self.categorieTypes = [String]()
        self.filteredItems = [Item]()
        self.selectedType = ""
        self.selectedName = ""
        self.selectedCount = ""
        self.selectedItemCountForContainer = ""
        self.selectedRoom = ""
        self.tableView.reloadData()
        self.pickerView.reloadComponent(0)
    }
    func createAlertView(index: Int){
        
        self.alertView = UIAlertController(title: "Tür Ekle", message: "Satın alacağınız demirbaş için tür ekleyiniz.", preferredStyle: .alert)
        if self.getRoomsCompleted {
            alertView.addTextField { (textfield) in
                textfield.inputView = self.pickerView
                if !self.rooms.isEmpty{
                    if (index == 0){
                        textfield.text = self.rooms[self.pickerView.selectedRow(inComponent: 0)].roomName
                    }else if (index == 1){
                        if !self.categorieTypes.isEmpty{
                            self.pickerView.selectRow(0, inComponent: 0, animated: false)
                            textfield.text = self.categorieTypes[self.pickerView.selectedRow(inComponent: 0)]
                        }else{
                            self.present(Helper.showAlertView(title: "Bu tipte eşya yoktur!", message: ""), animated: true, completion: nil)
                        }
                    }else if(index == 2){
                        if !self.filteredItems.isEmpty{
                            self.pickerView.selectRow(0, inComponent: 0, animated: true)
                            textfield.text = self.filteredItems[self.pickerView.selectedRow(inComponent: 0)].name
                        }else{
                            self.present(Helper.showAlertView(title: "Bu tipte eşya yoktur!", message: ""), animated: true, completion: nil)
                        }
                    }else if index == 3 {
                        if !self.items.isEmpty{
                            self.pickerView.selectRow(0, inComponent: 0, animated: true)
                            textfield.text = String(self.pickerView.selectedRow(inComponent: 0) + 1)
                        }else{
                            self.present(Helper.showAlertView(title: "Bu tipte eşya yoktur!", message: ""), animated: true, completion: nil)
                        }
                    }
                }else {
                    self.present(Helper.showAlertView(title: "Önce oda eklemelisiiz!", message: ""), animated: true, completion: nil)
                }
            }
        
        alertView.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        
        let okButtonAction = UIAlertAction(title: "Seç", style: .default) { (alertAction) in
            switch index{
            case 0: self.selectedRoom =  self.alertView.textFields![0].text!
            case 1: self.selectedType = self.alertView.textFields![0].text!
                    self.filterBySelectedCategorie()
            case 2: self.selectedName = self.alertView.textFields![0].text!
                    for item in self.items{
                        if(item.name == self.selectedName ){
                            self.selectedItem = item
                        }
                    }
            DataServices.ds.REF_CONTAINER.child(self.selectedRoom).child(self.selectedItem.Id).observeSingleEvent(of: .value, with: { (snapshot) in
                if let itemDict = snapshot.value as? Dictionary<String,AnyObject>{
                    self.selectedItemCountForContainer = itemDict["ItemCount"] as! String
                }else{
                    self.selectedItemCountForContainer = "0"
                }
            })
            case 3: self.selectedCount = self.alertView.textFields![0].text!
                    self.saveButton.alpha = 1
            default:
             break
            }
            
            if self.cellArr[0].count > index && index != -1 {
                if index != 3{
                    self.cellArr[2][index + 1] = "extended"
//                    self.cellArr[2][index] = ""
                }
                
                self.tableView.reloadData()
            }
            
        }
        alertView.addAction(okButtonAction)
    }
    }
    func getItems()  {
        DataServices.ds.REF_ITEMS.observeSingleEvent(of: .value, with: { (snapshots) in
            if let snapshot = snapshots.children.allObjects as? [DataSnapshot]{
                var item : Item!
                for snap in snapshot{
                    if let itemDict = snap.value as? Dictionary<String,AnyObject>{
                        let availability = itemDict["IsAvailable"] as! Bool
                        if(availability){
                            let availabilityNumber = NSNumber(value: availability)
                            item = Item(ItemId: snap.key, ItemCount: itemDict["ItemCount"] as! String, ItemName: itemDict["ItemName"] as! String, ItemPrice:itemDict["ItemPrice"] as! String, ItemType: itemDict["ItemType"] as! String, isavailable: Int(availabilityNumber))
                            self.items.append(item) 
                        }else{
                            continue
                        }
                        
                    }
                }
            }
            
        })
    }
    func getRooms()  {
        DataServices.ds.REF_ROOMS.observeSingleEvent(of: .value, with: { (snapshots) in
            if let snapshot = snapshots.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    if let roomDict = snap.value as? Dictionary<String,AnyObject>{
                        self.rooms.append(Room(roomId: snap.key, roomType: roomDict["RoomType"] as! String, itemKeys: [], itemCount: "", name: roomDict["RoomName"] as! String))
                    }
                }
            }
            self.getRoomsCompleted = true
        })
    }
    
    @IBAction func savePressed(_ sender: Any) {
        if self.selectedCount == selectedItem.count {
            DataServices.ds.REF_ITEMS.child(self.selectedItem.Id).updateChildValues(["ItemCount": "0","IsAvailable": false])
        }else{
            let setCount: Int = Int(self.selectedCount)!
            let getCount = Int(self.selectedItem.count)!
            let avarage = getCount - setCount
            
            DataServices.ds.REF_ITEMS.child(self.selectedItem.Id).updateChildValues(["ItemCount": "\(avarage)"])
        }
        let updatedCount : String = String(Int(self.selectedCount)! + Int(self.selectedItemCountForContainer)!)
        let dummyItem = Item(ItemId: self.selectedItem.Id, ItemCount: updatedCount, ItemName: self.selectedItem.name, ItemPrice: self.selectedItem.price, ItemType: self.selectedItem.type, isavailable: 1)
        DataServices.ds.addRoomsInContainer(roomId: self.selectedRoom, itemData: dummyItem.exportDictionary())
        self.clearAllAttr()
        self.present(self.attentionAlert, animated: true, completion: nil)
    }
    
}

extension SetItemVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArr[0].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cellArr[0][indexPath.row]
        cell.imageView?.image = UIImage(named: cellArr[1][indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // burayı seçerken geri gidip seçerse diye yaptım ama hatalı olmuyor çıldırıcam " Ç I L D I R D I "
        if self.getRoomsCompleted {
            if self.selectedRoom != "" && indexPath.row == 0{
                self.saveButton.alpha = 0
                self.selectedItem = nil
                self.filteredItems = [Item]()
                self.selectedType = ""
                self.selectedName = ""
                self.selectedCount = ""
                self.selectedRoom = ""
                self.cellArr = [["Oda Seçimi", "Demirbaş Türü", "Demirbaş Adı", "Demirbaş Adedi"],
                                ["roomSelection","roomType","itemName","itemCount"],
                                ["extended","","",""]]
                
                self.pickerView.reloadComponent(0)
                self.tableView.reloadData()
                self.alertView.textFields![0].text = ""
            }
            else if self.selectedType != "" && indexPath.row == 1{
                self.saveButton.alpha = 0
                self.selectedItem = nil
                self.filteredItems = [Item]()
                self.selectedName = ""
                self.selectedCount = ""
                self.selectedType = ""
                self.cellArr = [["Oda Seçimi", "Demirbaş Türü", "Demirbaş Adı", "Demirbaş Adedi"],
                                ["roomSelection","roomType","itemName","itemCount"],
                                ["extended","extended","",""]]
                self.pickerView.reloadComponent(0)
                self.tableView.reloadData()
                self.alertView.textFields![0].text = ""
            }else if self.selectedName != "" && indexPath.row == 2{
                self.saveButton.alpha = 0
                self.selectedItem = nil
                self.selectedCount = ""
                self.selectedName = ""
                self.cellArr = [["Oda Seçimi", "Demirbaş Türü", "Demirbaş Adı", "Demirbaş Adedi"],
                                ["roomSelection","roomType","itemName","itemCount"],
                                ["extended","extended","extended",""]]
                self.pickerView.reloadComponent(0)
                self.tableView.reloadData()
                self.alertView.textFields![0].text = ""
            }else if self.selectedCount != "" && indexPath.row == 3{
                self.saveButton.alpha = 0
                self.selectedCount = ""
                self.pickerView.reloadComponent(0)
                self.tableView.reloadData()
                self.alertView.textFields![0].text = ""
            }
            if cellArr[2][indexPath.row] != "" {
                self.createAlertView(index: indexPath.row)
                
                self.alertView.title = self.cellArr[0][indexPath.row]
                self.alertView.message = "Seçim Gerçekleştirin"
                
                self.present(self.alertView, animated: true, completion: nil)
                self.selectedRow = indexPath.row
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if cellArr[2][indexPath.row] == "" {
            return 0
        }else {
            return 60
        }
    }
}

extension SetItemVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.selectedRoom == "" {
           return rooms.count
        }else if (self.selectedType == "") {
            return categorieTypes.count
        }else if (self.selectedName == ""){
            return filteredItems.count
        }else{
            return Int(self.selectedItem.count)!
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.selectedRoom == "" {
            self.alertView.textFields![0].text = self.rooms[row].Id
            return self.rooms[row].roomName
        }else if (self.selectedType == "") {
            self.alertView.textFields![0].text = self.categorieTypes[row]
            return self.categorieTypes[row]
        }else if (self.selectedName == ""){
            self.alertView.textFields![0].text = self.filteredItems[row].name
            return self.filteredItems[row].name
        }else{
            self.alertView.textFields![0].text = "\(row + 1)"
            return "\(row + 1)"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.getRoomsCompleted {
            if self.selectedRoom == "" {
                self.alertView.textFields![0].text = self.rooms[row].Id
            }else if (self.selectedType == "") {
                self.alertView.textFields![0].text = self.categorieTypes[row]
            }else if (self.selectedName == ""){
                self.alertView.textFields![0].text = self.filteredItems[row].name
                self.selectedItem = self.filteredItems[row]
            }else{
                self.alertView.textFields![0].text = "\(row + 1)"
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
}
