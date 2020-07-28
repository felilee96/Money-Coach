//
//  budgetOverviewViewController.swift
//  Money Coach
//
//  Created by Felicia on 12/06/2020.
//  Copyright © 2020 felicia. All rights reserved.
//

import UIKit
import RealmSwift
import Foundation


class budgetOverviewViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
   

    // declare UI labels for the main view
    @IBOutlet weak var expnseslbl: UILabel!
    @IBOutlet weak var balancelbl: UILabel!
    @IBOutlet weak var budgetlbl: UILabel!
    @IBOutlet weak var expensesSetlbl: UILabel!
    @IBOutlet weak var budgetSetlbl: UILabel!
    @IBOutlet weak var balanceLeftlbl: UILabel!
    @IBOutlet weak var fromDate: UITextField!
    @IBOutlet weak var toDate: UITextField!
    @IBOutlet weak var searchBtn: UIButton!

    
    //declare a date picker
       let datepicker = UIDatePicker()
       let datepicker2 = UIDatePicker()
       let editdatepicker = UIDatePicker()
    //declare and instantiate the amount value
    var amount: Int = 0
    var sumEXP: Double = 0.0
    var sumBudget: Double = 0.0
    //initialise From date & To date to be used for condition checking
    var fromDateData = Date()
    var toDateData = Date()
    var edittedDate = Date()
    
    var indexToEdit: Int?
    //declare table view
    @IBOutlet weak var tableView_new: UITableView!
    
    //declare and define data set in the picker view for  Transaction Type Text Field
    var pickerDataType = ["Budget","Savings", "Expenses", "Income"]
    //declare and define data set in the picker view for Transaction Category Text Field
    var pickerDataCat = ["Budget","Savings","Income","Food","Groceries", "Bills","Transportation","Entertainment","Rental","Shopping","Health","Sport","Education","Electronic", "Holidays","Others"]
    //declare and define an empty string for the selected row
    var itemSelected = ""
    //declare picker view
    weak var pickerView: UIPickerView?

   //declare for database
    var realm: Realm!
    //store the data get from database as array
    var results: Results <Transaction>{
        get{
            return realm.objects(Transaction.self).sorted(byKeyPath: "date" , ascending: true)
        }
    }
    //connect ui view (subview) for update transaction to code
    @IBOutlet var popOverEdit: UIView!
    //declare the text field for subview
    
    
    @IBOutlet weak var edit_Amount: UITextField!

    @IBOutlet weak var edit_Type: UITextField!
    
    @IBOutlet weak var edit_category: UITextField!
    
    @IBOutlet weak var edit_date: UITextField!

    var objectArray: Array<Transaction> = []
    
    override func viewDidLoad() {
        tableView_new.reloadData()
        super.viewDidLoad()
        navigationController?.delegate = self
        //set amount Text Field as delegate
        edit_Amount.delegate = self

        // trigger the database
        realm = try! Realm()
       createDatePicker()
        createDatePickerforPopUp()
        
        objectArray = Array(results);
        
        //register customised table view cell for the table view
        let nib = UINib (nibName: "budgetTableViewCell", bundle: nil)
        tableView_new.register(nib, forCellReuseIdentifier: "budgetTableViewCell")
        
        //add a gesture recognizer for the pickerview
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        //set table view as delegate
        tableView_new.delegate = self
        tableView_new.dataSource = self
        calculateBudget()
        calculateExpenses()
        calculateBalance()
        // when this view is loaded, get current month & year for filter the data
        let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                           let dateString =  dateFormatter.string(from: Date().getThisMonthStart()!)
                                     let dateString2 = dateFormatter.string(from: Date().getThisMonthEnd()!)
    
                       let dateFromString1 = dateFormatter.date(from: dateString)
                             let dateFromString2 = dateFormatter.date(from: dateString2)
        objectArray.removeAll()

        var dataForMonth = results.filter("date BETWEEN %@", [dateFromString1, dateFromString2]).sorted(byKeyPath: "date", ascending: true)
        
        if dataForMonth.count > 0{
                                  for currentData in dataForMonth{
                                   objectArray.append(currentData)
            }
        
        }
        //declare picker view
               let pickerView = UIPickerView()
               //set the picker view as delegate
               pickerView.delegate = self
               pickerView.dataSource = self
               //set the Transaction Type Text Field & Transaction Category Text Field as delegate
               edit_Type.delegate=self
               edit_category.delegate=self
               //set the input view as picker view for Transaction Type Text Field & Transaction Category Text Field
               edit_Type.inputView = pickerView
               edit_category.inputView = pickerView
               //It is important that goes after de inputView assignation
               self.pickerView = pickerView
               
               //call the function to create a done button at picker view
               createPicker()
        
    }
   
  override func viewDidLayoutSubviews() {
    if let index =  indexToEdit {
        if objectArray.count>0{
          let editItem = objectArray[index]
            }
          
    }
    }
//
//        if let index =  indexToEdit {
//          if objectArray.count>0{
//            let editItem = objectArray[index]
////            edit_Amount.text = String(editItem.amount)
////            edit_Type.text = editItem.type
////            edit_category.text = editItem.category
//////            let dateFormatter = DateFormatter()
//////            dateFormatter.dateFormat = "dd/MM/yyyy"
//////            let date_edit =  dateFormatter.string(from:editItem.date )
//////            edit_date.text = String(date_edit)
//          }
//
//       }
//
//  }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if objectArray.count == 0{
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView_new.bounds.size.width, height: tableView_new.bounds.size.height))
                                      noDataLabel.text = " You have not input any transactions within this month. 😅 Please click the '+' icon to add your transactions. 😄"
                                      noDataLabel.textColor     = UIColor.black
                               noDataLabel.numberOfLines = 0
                                      noDataLabel.textAlignment = .center
                                      tableView_new.backgroundView  = noDataLabel
                                      tableView_new.separatorStyle  = .none
        }
        else{
            tableView_new.backgroundView  = .none
        }
        return objectArray.count
        
    }
   
    override func didReceiveMemoryWarning() {
           // Dispose of any resources that can be recreated.
           super.didReceiveMemoryWarning()
       }
       
       //reload the components when the textfield is clicked
       func textFieldDidBeginEditing(_ textField: UITextField) {
           self.pickerView?.reloadAllComponents()
       }
    @objc func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool{
        if let digit = Int (string){
            
            amount = amount * 10 + digit
            if amount > 100_000_000{
                //declare an alert when user enter more than 1 Million
                let amountAlert = UIAlertController(title: "Please Input amount less than 1 Million", message: nil, preferredStyle:.alert)
                //add action to trigger the alert
                amountAlert.addAction(UIAlertAction(title: "Dismiss",style: .default,handler: nil))
                present(amountAlert,animated: true,completion: nil)
                //reset the amount to 0
                edit_Amount.text = ""
                amount = 0
            }
            //if the amount is less than 1 Million, proceed to update the amount
            else{
                edit_Amount.text = updateAmount()
            }
        }
        
        // if user click the backspace
        if string == "" {
            amount = amount/10
            edit_Amount.text = amount == 0 ? "": updateAmount()
        }
        return false
    }
    

    //create amount text field function
    @objc func updateAmount() -> String?{
        // to start the amount at 0.00
        let amt = Double (amount/100) + Double (amount%100)/100
        return String(format: "%.2f", amt)
    }
    //when user click outside the keyboards area, stop editting the textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if edit_Type.isFirstResponder {
            return pickerDataType.count
        } else {
            return pickerDataCat.count
        }
    }
    
    // Do any additional setup after loading the view.
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if edit_Type.isFirstResponder{
            return pickerDataType[row]
        }
        else {
            return pickerDataCat[row]
        }
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if edit_Type.isFirstResponder{
            let itemselected = pickerDataType[row]
            edit_Type.text = itemselected
        }
        else{
            let itemselected = pickerDataCat[row]
            edit_category.text = itemselected
        }
        
    }
    //create done toolbar on picker
    func createPicker(){
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //declare and set a done button on bar
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTappedforPicker))
        toolbar.setItems([doneBtn], animated: true)
        
        //assign toolbar
        edit_Type.inputAccessoryView = toolbar
        edit_category.inputAccessoryView = toolbar
    }
    //function when the Done button is tapped
    @objc func doneTappedforPicker(){
        if edit_Type.isFirstResponder{
            
        edit_Type.resignFirstResponder()

                // get first index value of array if goal type text field is empty
                if (edit_Type.text?.isEmpty)! {
                    edit_Type.text = self.pickerDataType.first
                }
        }
        else{
                            
            edit_category.resignFirstResponder()

                    // get first index value of array if goal type text field is empty
                    if (edit_category.text?.isEmpty)! {
                       edit_category.text = self.pickerDataCat.first
                    }
            
        }

        self.popOverEdit.endEditing(true)
    }
    


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "budgetTableViewCell", for: indexPath) as! budgetTableViewCell

        let transaction = objectArray[indexPath.row]
        
        // return each data from database into respective labels on the customised tabel view cell
        cell.typelbl.text = transaction.type
        cell.categoylbl.text = transaction.category
        cell.amountlbl.text = "RM " + String (transaction.amount)
        //create date formatter to format the date shows
        let date = Date()
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "dd/MM/yyyy"
        //print(formatter1.string(from: today))
        cell.datelbl.text = formatter1.string(from: transaction.date)
        
        //check the transaction type and set the color for the amount label & icon
        // set the amount lbl to red if the transaction type is expenses & icon to expenses icon
        if cell.typelbl.text == "Expenses"{
            cell.amountlbl.textColor = .red
            cell.myimage.image = UIImage(named: "expenses_icon")!
        }
        // set the amount lbl to green if the transaction type is income & icon to income icon
        else if cell.typelbl.text == "Income"{
            cell.amountlbl.textColor = UIColor(named:"Color-0")
            cell.myimage.image = UIImage(named: "income_icon")!
        }
        // set the amount lbl to brown if the transaction type is budget & icon to budget icon
        else if cell.typelbl.text == "Budget"{
            cell.amountlbl.textColor = .brown
            cell.myimage.image = UIImage(named: "budget_icon")!
        }
        // set the amount lbl to yellow if the transaction type is savings & icon to savings icon
        else{
            //declare a customised color
            let swiftColor = UIColor(red: 1, green: 165/255, blue: 0, alpha: 1)
            cell.amountlbl.textColor = swiftColor
            cell.myimage.image = UIImage(named: "savings x")!
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //when user click on delete
        if editingStyle == UITableViewCell.EditingStyle.delete {
            //when row is selected
            let item = objectArray[indexPath.row]
            //declare an alert when user try to delete a transaction
            let deleteAlert = UIAlertController(title: " Are you sure you want to delete this transaction?", message: nil, preferredStyle:.alert)
            //add action to trigger the alert
            //when user click on "Cancel"
            deleteAlert.addAction(UIAlertAction(title: "Cancel",style: .default,handler: nil))
            //when user click on "Yes"
            deleteAlert.addAction(UIAlertAction(title: "Yes",style: .default,handler: { (action: UIAlertAction!) in
            
                //delete the transaction from database
                try! self.realm.write {
                    self.realm.delete(item)
                }
                //remove the transaction from the array
                self.objectArray.remove(at: indexPath.row)
                            
                //delete the row in table view
                self.tableView_new.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            }))
            //show the alert
            present(deleteAlert,animated: true,completion: nil)
          
    }
    }
   
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView (_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) ->UISwipeActionsConfiguration? {
     
     let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler: (Bool) -> ()) in
        self.indexToEdit = indexPath.row
        self.view.addSubview(self.popOverEdit)
        self.popOverEdit.center = self.view.center
     }
     edit.image = UIImage(named: "edit-icon")
     edit.backgroundColor = .blue
    return UISwipeActionsConfiguration(actions: [edit])
    }
    
    //when click on the update button

    @IBAction func updateBtn(_ sender: UIButton) {
        //check the user input
        //when input in amountTextField is equal to 0 or empty
        
        print("inside update")
        
        if edit_Amount.text == "0.00" || edit_Amount.text == ""{
            //declare an alert when amount is empty
            let emptyamountAlert = UIAlertController(title: "Please input any transaction amount greater than 0", message: nil, preferredStyle:.alert)
            //add action to trigger the alert
            emptyamountAlert.addAction(UIAlertAction(title: "Dismiss",style: .default, handler: nil))
            present(emptyamountAlert,animated: true,completion: nil)
        }
            //when input in Transaction Type Text Field is empty
        else if edit_Type.text == ""{
            //declare an alert when transaction Type is empty
            let emptyTypeAlert = UIAlertController(title: "Please input your transaction type.", message: nil, preferredStyle:.alert)
            //add action to trigger the alert
            emptyTypeAlert.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
            present(emptyTypeAlert,animated: true,completion: nil)
        }
            
            //when input in Transaction Type Text Field is empty
        else if edit_category.text == ""{
            //declare an alert when transaction category is empty
            let emptyCatAlert = UIAlertController(title: "Please input your transaction category.", message: nil, preferredStyle:.alert)
            //add action to trigger the alert
        emptyCatAlert.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
            present(emptyCatAlert,animated: true,completion: nil)
        }
            
            //when input in dateTextField is empty
        else if edit_date.text == ""{
            //declare an alert when date is empty
            let emptyDateAlert = UIAlertController(title: "Please input your transaction date.", message: nil, preferredStyle:.alert)
            //add action to trigger the alert
        emptyDateAlert.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
            present(emptyDateAlert,animated: true,completion: nil)
        }
           
        //if all field are filled in with valid user input
        else{
        //to format the Date data to be saved into database
        let formatter3   = DateFormatter()
        formatter3.dateStyle = .medium
        formatter3.timeStyle = .none
        edittedDate = formatter3.date(from: edit_date.text!)!
        
           try! realm.write {
            realm.create(Transaction.self, value: ["amount":Double(edit_Amount.text!)! , "type":edit_Type.text!, "category":edit_category.text!,"date": edittedDate], update: .modified)
            }
        //declare an alert when goal title txtfield is empty
               let updateAlert = UIAlertController(title: "Your transaction details is succesfully updated.", message: nil, preferredStyle:.alert)
               //add action to trigger the alert
        updateAlert.addAction(UIAlertAction(title: "Dismiss",style: .default,handler: nil))
               present(updateAlert,animated: true,completion: nil)
        //reset the text fields after update any transaction.
        self.edit_Amount.text = ""
        self.edit_Type.text = ""
        self.edit_category.text = ""
        self.edit_date.text = ""

        self.popOverEdit.removeFromSuperview()
        self.tableView_new?.reloadData()
    }
    }
    //when click on the cancel button
    @IBAction func cancelEdit(_ sender: UIButton) {
        self.popOverEdit.removeFromSuperview()

    }
    
    func calculateBudget(){
            let realm = try! Realm()
            let budgetTypeData: String = "Budget"
        let allData = realm.objects(Transaction.self).filter("type = '\(budgetTypeData)'")
            let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "dd/MM/yyyy"
                    
               let dateString =  dateFormatter.string(from: Date().getThisMonthStart()!)
               let dateString2 = dateFormatter.string(from: Date().getThisMonthEnd()!)

               let dateFromString1 = dateFormatter.date(from: dateString)
               let dateFromString2 = dateFormatter.date(from: dateString2)

               var dataForMonth = allData.filter("date BETWEEN %@", [dateFromString1, dateFromString2])
            if dataForMonth.count>0{
                for data in dataForMonth{
                    sumBudget += data.amount
                budgetSetlbl.text = "RM" + String(sumBudget)
            }
        }
   
}
    func calculateExpenses(){
        let realm = try! Realm()
        
        let ExpensesTypeDa: String = "Expenses"
        var allEXPData = realm.objects(Transaction.self).filter("type = '\(ExpensesTypeDa)'")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
             
        let dateString =  dateFormatter.string(from: Date().getThisMonthStart()!)
        let dateString2 = dateFormatter.string(from: Date().getThisMonthEnd()!)

        let dateFromString1 = dateFormatter.date(from: dateString)
        let dateFromString2 = dateFormatter.date(from: dateString2)

        var dataForMonthEXP = allEXPData.filter("date BETWEEN %@", [dateFromString1, dateFromString2])
        if dataForMonthEXP.count>0{
            for expdata in dataForMonthEXP{
                sumEXP += expdata.amount
                expensesSetlbl.text = "RM" + String(sumEXP)
            }
        }
    }
        
        func calculateBalance(){
            
            let totalbudget = Double(budgetSetlbl.text!)
            let totalExpenses = Double(expensesSetlbl.text!)
            var calBalance: Double = 0.0
            calBalance = sumBudget - sumEXP
            balanceLeftlbl.text = "RM" + String (calBalance)
        }
    
    //Function to create a date picker
    func createDatePicker(){
        
        fromDate.textAlignment = .center
        toDate.textAlignment = .center

        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //declare and set a done button on bar
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        toolbar.setItems([doneBtn], animated: true)
        
        //assign toolbar
        fromDate.inputAccessoryView = toolbar
        toDate.inputAccessoryView = toolbar
        edit_date.inputAccessoryView = toolbar

        //assign date picker to text field
        fromDate.inputView = datepicker
        toDate.inputView = datepicker2
        edit_date.inputView = editdatepicker
        
        //date picker format
        datepicker.datePickerMode = .date
        datepicker2.datePickerMode = .date
        editdatepicker.datePickerMode = .date
        
    }

    func createDatePickerforPopUp(){
        
        edit_date.textAlignment = .center

        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //declare and set a done button on bar
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped2))
        toolbar.setItems([doneBtn], animated: true)
        
        //assign toolbar
        edit_date.inputAccessoryView = toolbar

        //assign date picker to text field
        edit_date.inputView = editdatepicker
        
        //date picker format
        editdatepicker.datePickerMode = .date
        
    }

    //function when the Done button is tapped
     @objc func doneTapped(){
         //formatter for Goal Due Date
         let formatter = DateFormatter()
         formatter.dateStyle = .medium
         formatter.timeStyle = .none
         
        //if user clicking on the Goal Due Date Text Field, return data selected from the date picker to the Goal Due Date Textfield
         if  fromDate.isFirstResponder{
             fromDate.text = formatter.string(from: datepicker.date)
         }
         else{
            toDate.text = formatter.string(from: datepicker2.date)
        }
         self.view.endEditing(true)
     }
    
    //function when the Done button is tapped
    @objc func doneTapped2(){
        //formatter for Goal Due Date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
       //if user clicking on the Goal Due Date Text Field, return data selected from the date picker to the Goal Due Date Textfield
        if edit_date.isFirstResponder{
           edit_date.text = formatter.string(from: editdatepicker.date)
       }
        self.popOverEdit.endEditing(true)
    }
    //function when the Search button is tapped
  
    @IBAction func searchTapped(_ sender: UIButton) {
         
               //assign the value from date picker to to Date & From Date variable
               fromDateData = datepicker.date
               toDateData = datepicker2.date
               
               //check the user input
               //when input in fromDate is empty
               if fromDate.text == ""{
                   //declare an alert when goal title txtfield is empty
                   let emotyFromDateAlert = UIAlertController(title: "Please select your From Date.", message: nil, preferredStyle:.alert)
                   //add action to trigger the alert
            emotyFromDateAlert.addAction(UIAlertAction(
                       title: "Dismiss",
                       style: .default,
                       handler: nil))
                   present(emotyFromDateAlert,animated: true,completion: nil)
               }
               else if toDate.text == ""{
                          //declare an alert when goal title txtfield is empty
                          let emotyToDateAlert = UIAlertController(title: "Please select your To Date.", message: nil, preferredStyle:.alert)
                          //add action to trigger the alert
                  emotyToDateAlert.addAction(UIAlertAction(
                              title: "Dismiss",
                              style: .default,
                              handler: nil))
                          present(emotyToDateAlert,animated: true,completion: nil)
                      }
               // when input From Date greater than To Date
               else if fromDateData > toDateData {
                   //declare an alert when To Date greater than From Date
                   let invaliDateAlert = UIAlertController(title: "Invalid Date range. Please select a From Date that is earlier than/equal to your To Date.", message: nil, preferredStyle:.alert)
                   //add action to trigger the alert
                   invaliDateAlert.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
                   present(invaliDateAlert,animated: true,completion: nil)
               }
                   
                //if all field are filled in with valid user input
               else{
                   let realm = try! Realm()
                   let allData = realm.objects(Transaction.self)
                        
                       let dateFormatter = DateFormatter()
                       dateFormatter.dateFormat = "dd/MM/yyyy"

                       let dateString =  dateFormatter.string(from: fromDateData)
                       let dateString2 = dateFormatter.string(from: toDateData)
                
                let dateFromString1 = dateFormatter.date(from: dateString)
                      let dateFromString2 = dateFormatter.date(from: dateString2)
                  
                objectArray.removeAll()

                let selectedMonth = allData.filter("date BETWEEN %@", [dateFromString1, dateFromString2]).sorted(byKeyPath: "date", ascending: true)
                if selectedMonth.count > 0{
                           for selectedData in selectedMonth{
                            objectArray.append(selectedData)
                    }
                    }
                else{
                    let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView_new.bounds.size.width, height: tableView_new.bounds.size.height))
                           noDataLabel.text = " You have not input any transactions within this period. 😅 Please click the '+' icon to add your transactions. 😄"
                           noDataLabel.textColor     = UIColor.black
                    noDataLabel.numberOfLines = 0
                           noDataLabel.textAlignment = .center
                           tableView_new.backgroundView  = noDataLabel
                           tableView_new.separatorStyle  = .none
                       }
                            tableView_new.reloadData()
                }
               }
    }


extension Date {
 
// This Month Start
func getThisMonthStart() -> Date? {
    let components = Calendar.current.dateComponents([.year, .month], from: self)
    return Calendar.current.date(from: components)!
}


    func getThisMonthEnd() -> Date? {
        let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month += 1
        components.day = 1
        components.day -= 1
        return Calendar.current.date(from: components as DateComponents)!
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? budgetOverviewViewController {
            controller.tableView_new.reloadData()
        }
    }
   
    }


  
