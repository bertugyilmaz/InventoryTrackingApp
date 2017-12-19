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
    var cellArr: [[String]]!
    var itemData: Item!
    var items = [Item]()
    var pickerView = UIPickerView()
    var rooms = [String]()
    var selectedRow = -2
    var selectedItem : Item!
    var categorieTypes = [String]()
    var filteredItems = [Item]()
    var selectedType = ""
    var selectedName = ""
    var selectedCount = ""
    var selectedRoom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("AddItemVC")
        self.cellArr = [["Oda Seçimi", "Demirbaş Türü", "Demirbaş Adı", "Demirbaş Adedi"],
                        ["roomSelection","roomType","itemName","itemCount"],
                        ["extended","","",""]]
        self.saveButton.alpha = 0
        self.selectedItem = nil
        self.categorieTypes = [String]()
        self.filteredItems = [Item]()
        self.selectedType = ""
        self.selectedName = ""
        self.selectedCount = ""
        self.selectedRoom = ""
        self.alertView = nil
        self.itemData = nil
        self.items = [Item]()
        self.pickerView = UIPickerView()
        self.rooms = [String]()
        self.getRooms()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.saveButton.isHidden = true
        
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
    
    
    func createAlertView(index: Int){
        
        self.alertView = UIAlertController(title: "Tür Ekle", message: "Satın alacağınız demirbaş için tür ekleyiniz.", preferredStyle: .alert)
        alertView.addTextField { (textfield) in
            textfield.inputView = self.pickerView
            if (index == 0){
                textfield.text = self.rooms[self.pickerView.selectedRow(inComponent: 0)]
                self.getItemType()
            }else if (index == 1){
                self.getItems()
                if !self.categorieTypes.isEmpty{
                    self.pickerView.selectRow(0, inComponent: 0, animated: false)
                    textfield.text = self.categorieTypes[self.pickerView.selectedRow(inComponent: 0)]
                }
            }else if(index == 2){
                if !self.items.isEmpty{
                    self.pickerView.selectRow(0, inComponent: 0, animated: true)
                      textfield.text = self.items[self.pickerView.selectedRow(inComponent: 0)].name
                }
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
            case 3: self.selectedCount = self.alertView.textFields![0].text!
            default:
                self.saveButton.isHidden = false
            }
            
            if self.cellArr[0].count > index && index != -1 {
                if index != 3{
                    self.cellArr[2][index + 1] = "extended"
                }
                
                self.tableView.reloadData()
            }
            
        }
        alertView.addAction(okButtonAction)
    }
    func getItems()  {
        DataServices.ds.REF_ITEMS.observeSingleEvent(of: .value, with: { (snapshots) in
            if let snapshot = snapshots.children.allObjects as? [DataSnapshot]{
                var item : Item!
                for snap in snapshot{
                    if let itemDict = snap.value as? Dictionary<String,AnyObject>{
                        let availability = itemDict["IsAvailable"] as! Int
                        if(availability == 1){
                            item = Item(ItemId: snap.key, ItemCount: itemDict["ItemCount"] as! String, ItemName: itemDict["ItemName"] as! String, ItemPrice:itemDict["ItemPrice"] as! String, ItemType: itemDict["ItemType"] as! String, isavailable: availability)
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
        DataServices.ds.REF_ROOMS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let categories = snapshot.value as? Dictionary<String,AnyObject>{
                for item in categories.keys{
                    self.rooms.append(item)
                }
            }
        })
    }
    
    @IBAction func savePressed(_ sender: Any) {
        DataServices.ds.addRoomsInContainer(roomId: self.selectedRoom, itemData: self.itemData.exportDictionary())
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
//        if self.selectedRoom != "" && indexPath.row == 0{
//            self.saveButton.alpha = 0
//            self.selectedItem = nil
//            self.categorieTypes = [String]()
//            self.filteredItems = [Item]()
//            self.selectedType = ""
//            self.selectedName = ""
//            self.selectedCount = ""
//            self.selectedRoom = ""
//            self.items = [Item]()
//
//            self.pickerView.reloadComponent(0)
//            self.tableView.reloadData()
//        }else if self.selectedType != "" && indexPath.row == 1{
//            self.saveButton.alpha = 0
//            self.selectedItem = nil
//            self.categorieTypes = [String]()
//            self.filteredItems = [Item]()
//            self.selectedType = ""
//            self.selectedName = ""
//            self.selectedCount = ""
//            self.items = [Item]()
//
//            self.pickerView.reloadComponent(0)
//            self.tableView.reloadData()
//        }else if self.selectedName != "" && indexPath.row == 2{
//            self.saveButton.alpha = 0
//            self.selectedItem = nil
//            self.selectedName = ""
//            self.selectedCount = ""
//
//            self.pickerView.reloadComponent(0)
//            self.tableView.reloadData()
//        }else if self.selectedCount != "" && indexPath.row == 3{
//            self.saveButton.alpha = 0
//            self.selectedCount = ""
//
//            self.pickerView.reloadComponent(0)
//            self.tableView.reloadData()
//        }
        if cellArr[2][indexPath.row] != "" {
            self.createAlertView(index: indexPath.row)
            
            self.alertView.title = self.cellArr[0][indexPath.row]
            self.alertView.message = "Seçim Gerçekleştirin"
            
            self.present(self.alertView, animated: true, completion: nil)
            self.selectedRow = indexPath.row
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
            return self.rooms[row]
        }else if (self.selectedType == "") {
            return self.categorieTypes[row]
        }else if (self.selectedName == ""){
            return self.filteredItems[row].name
        }else{
            return "\(row + 1)"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        if self.selectedRoom == "" {
            self.alertView.textFields![0].text = self.rooms[row]
            
        }else if (self.selectedType == "") {
            self.alertView.textFields![0].text = self.categorieTypes[row]
            
        }else if (self.selectedName == ""){
            self.alertView.textFields![0].text = self.filteredItems[row].name
        }else{
            self.alertView.textFields![0].text = "\(row + 1)"
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
}
