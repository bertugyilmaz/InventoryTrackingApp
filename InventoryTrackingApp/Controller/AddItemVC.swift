//
//  AddItemVC.swift
//  InventoryTrackingApp
//
//  Created by onur hüseyin çantay on 9.12.2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import UIKit
import Firebase

class AddItemVC: BaseVC {
 
    @IBOutlet weak var saveButton: itemSetAddButton!
    @IBOutlet weak var tableView: UITableView!
    var alertView: UIAlertController!
    var attentionAlert = Helper.showAlertView(title: "", message: "İşleminiz Başarılı")
    var cellArr: [[String]]!
    var itemData: Item!
    var items = [Item]()
    var pickerView = UIPickerView()
    var categorieTypes = [String]()
    var selectedRow = -2
    var selectedType = ""
    var selectedName = ""
    var selectedCount = ""
    var selectedPrice = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getItemType()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("AddItemVC")
        self.cellArr = [["Demirbaş Türü", "Demirbaş Adı", "Demirbaş Adedi", "Demirbaş Fiyatı"],
                        ["roomType","itemName","itemCount","search"],
                        ["extended","","",""]]
        self.getItems()
        self.saveButton.alpha = 0
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.setRightBarButtonItem()
    }
    
    func setRightBarButtonItem(){
        let rightButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addType))
        self.navItem.setRightBarButton(rightButton, animated: false)
    }
    
    func addType() {
        if self.currentUser.IsAdmin {
            self.createAlertView(index: -1)
            self.present(alertView, animated: true, completion: nil)
        }else {
            self.present(Helper.showAlertView(title: "Admin girişi yapınız.", message: ""), animated: true, completion: nil)
        }       
    }
    
    func getItems(){
        DataServices.ds.REF_ITEMS.observeSingleEvent(of: .value, with: { (snapshots) in
            if let snapshot = snapshots.children.allObjects as? [DataSnapshot]{
                
                for snap in snapshot{
                    if let itemDict = snap.value as? Dictionary<String,AnyObject>{
                        
                        let item = Item(ItemId: snap.key, ItemCount: itemDict["ItemCount"] as! String, ItemName: itemDict["ItemName"] as! String, ItemPrice:itemDict["ItemPrice"] as! String, ItemType: itemDict["ItemType"] as! String, isavailable: 1)
                        self.items.append(item)
                    }
                }
            }
        })
    }
    
    func updateCountofExistingItem(sentItem: Item) -> Bool{
        for item in items {
            if item.name.lowercased() == sentItem.name.lowercased() {
                DataServices.ds.REF_ITEMS.child(item.Id).updateChildValues(["ItemCount": Helper.sumString(str1: item.count, str2: sentItem.count), "IsAvailable": true, "ItemPrice": Helper.sumString(str1: item.price, str2: sentItem.price)])
                return true
            }else{
//                print("Not me")
            }
        }
        return false
    }
    
    func createAlertView(index: Int){
        
        self.alertView = UIAlertController(title: "Tür Ekle", message: "Satın alacağınız demirbaş için tür ekleyiniz.", preferredStyle: .alert)
        alertView.addTextField { (textfield) in
            if index == 0{
                textfield.inputView = self.pickerView
            }else if index == 2 || index == 3 {
                textfield.keyboardType = .numberPad
            }
            
        }
        alertView.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        
        let okButtonAction = UIAlertAction(title: "Seç", style: .default) { (alertAction) in
            let textField = self.alertView.textFields?[0]
            if textField?.text == "" {
                self.present(Helper.showAlertView(title: "Boş değer bırakamazsınız.", message: ""), animated: true, completion: nil)
                return
            }
            if self.cellArr[0].count > index && index != -1 {
                if index != 3{
                    self.cellArr[2][index + 1] = "extended"
                }
                
                switch index {
                case 1:
                    self.selectedName = (textField?.text!)!
                    print((textField?.text!)!)
                    break
                case 2:
                    self.selectedCount = (textField?.text!)!
                    print((textField?.text!)!)
                    break
                case 3:
                    self.selectedPrice = (textField?.text!)!
                    self.saveButton.alpha = 1
                    print((textField?.text!)!)
                    break
                default:
                    break
                   
                }
                self.tableView.reloadData()
            }
            
            if index == -1 && !(textField?.text?.isEmpty)!{
                if let text = self.alertView.textFields![0].text {
                    DataServices.ds.addCategories(name: text)
                    self.categorieTypes.removeAll()
                    self.getItemType()
                    self.pickerView.reloadAllComponents()
                }
            }
        }
        alertView.addAction(okButtonAction)
    }
    
    func getItemType()  {
        DataServices.ds.REF_CATEGORIES.observeSingleEvent(of: .value, with: { (snapshot) in
            if let categories = snapshot.value as? Dictionary<String,AnyObject>{
                for item in categories.keys{
                    self.categorieTypes.append(item)
                }
            }
        })
    }
    
    func clearAllAttr(){
        self.cellArr.removeAll()
        self.cellArr = [["Demirbaş Türü", "Demirbaş Adı", "Demirbaş Adedi", "Demirbaş Fiyatı"],
                        ["roomType","itemName","itemCount","search"],
                        ["extended","","",""]]
        self.selectedRow = -2
        self.selectedType = ""
        self.selectedName = ""
        self.selectedCount = ""
        self.selectedPrice = ""
        self.saveButton.alpha = 0
        self.tableView.reloadData()
    }
    
    @IBAction func savePressed(_ sender: Any) {
        self.itemData = Item(ItemId: "", ItemCount: selectedCount, ItemName: selectedName, ItemPrice: selectedPrice, ItemType: selectedType, isavailable: 1)
        if !self.updateCountofExistingItem(sentItem: itemData) {
            DataServices.ds.addItem(itemData: self.itemData.exportDictionary())
        }
        self.present(self.attentionAlert, animated: true, completion: nil)
        self.clearAllAttr()
    }
}

extension AddItemVC: UITableViewDelegate, UITableViewDataSource{
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
        if self.currentUser.IsAdmin  {
            if cellArr[2][indexPath.row] != "" {
                self.createAlertView(index: indexPath.row)
                
                self.alertView.title = self.cellArr[0][indexPath.row]
                self.alertView.message = "Seçim Gerçekleştirin"
                
                self.present(self.alertView, animated: true, completion: nil)
                self.selectedRow = indexPath.row
            }
        }else {
            self.present(Helper.showAlertView(title: "Admin girişi yapınız.", message: ""), animated: true, completion: nil)
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

extension AddItemVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categorieTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.alertView.textFields?[0].text = categorieTypes[row]
        return categorieTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      self.selectedType = self.categorieTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
}

