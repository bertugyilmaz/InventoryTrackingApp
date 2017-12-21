//
//  AddItemVC.swift
//  InventoryTrackingApp
//
//  Created by onur hüseyin çantay on 9.12.2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import UIKit

class AddItemVC: BaseVC {
 
    @IBOutlet weak var saveButton: itemSetAddButton!
    @IBOutlet weak var tableView: UITableView!
    var alertView: UIAlertController!
    var attentionAlert = Helper.showAlertView(title: "", message: "İşleminiz Başarılı")
    var cellArr: [[String]]!
    var itemData: Item!
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
        self.saveButton.alpha = 0
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.setRightBarButtonItem()
    }
    
    func setRightBarButtonItem(){
        let rightButton : UIBarButtonItem = UIBarButtonItem(title: "Tür Ekle", style: .plain, target: self, action: #selector(turEkle))
        self.navItem.setRightBarButton(rightButton, animated: true)
    }
    
    func turEkle()  {
        self.createAlertView(index: -1)
        self.present(alertView, animated: true, completion: nil)
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
    
    @IBAction func savePressed(_ sender: Any) {
        self.itemData = Item(ItemId: "", ItemCount: selectedCount, ItemName: selectedName, ItemPrice: selectedPrice, ItemType: selectedType, isavailable: 1)
        DataServices.ds.addItem(itemData: self.itemData.exportDictionary())
        self.present(self.attentionAlert, animated: true, completion: nil)
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

