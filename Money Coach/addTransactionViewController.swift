//
//  addTransactionViewController.swift
//  Money Coach
//
//  Created by Felicia on 05/06/2020.
//  Copyright © 2020 felicia. All rights reserved.
//

import UIKit
import RealmSwift
import Foundation // required for String(format: _, _)


class addTransactionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate, UINavigationControllerDelegate{
    
    
    //connecting textLabel: RM to code
    @IBOutlet weak var currencySymbolLabel: UILabel!
    //connecting textField: Amount  to code
    @IBOutlet weak var amountTextField: UITextField!
    //declare and instantiate the amount value
    var amount: Int = 0
    
    
    @IBOutlet weak var backReload: UINavigationItem!
    //connecting textLabel: Transaction Type to code
    @IBOutlet weak var transxTypeLabel: UILabel!
    //connecting textLabel: Transaction Category to code
    @IBOutlet weak var transxCategoryLabel: UILabel!
    //connecting textLabel: Date to code
    @IBOutlet weak var dateLabel: UILabel!
    
    //connecting Text Field: Transaction Type to code
    @IBOutlet weak var transxTypeTxtField: UITextField!
    //connecting Text Field: Transaction Category to code
    @IBOutlet weak var categoryTxtField: UITextField!
    //declare and define data set in the picker view for  Transaction Type Text Field
    var pickerDataType = ["Budget","Savings", "Expenses", "Income"]
    //declare and define data set in the picker view for Transaction Category Text Field
    var pickerDataCat = ["Budget","Savings","Income","Food","Groceries", "Bills","Transportation","Entertainment","Rental","Shopping","Health","Sport","Education","Electronic", "Holidays","Others"]
    //declare and define an empty string for the selected row
    var itemSelected = ""
    //declare picker view
    weak var pickerView: UIPickerView?
    
    //connecting Text Field: Date to code
    @IBOutlet weak var dateTextField: UITextField!
    
    //declare a date picker
    let datepicker = UIDatePicker()
    
    //when the view is loaded
    override func viewDidLoad() {
        navigationController?.delegate = self

        super.viewDidLoad()
        let realm = try! Realm ()
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        //set amount Text Field as delegate
        amountTextField.delegate = self
        //set the placeholder for the amount Text Field
        amountTextField.placeholder = "0.00"
        
        //create a Save Button on Navigation Bar
        let save = UIBarButtonItem (barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        navigationItem.rightBarButtonItems = [save]
        //add a gesture recognizer for the pickerview
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        //declare picker view
        let pickerView = UIPickerView()
        //set the picker view as delegate
        pickerView.delegate = self
        pickerView.dataSource = self
        //set the Transaction Type Text Field & Transaction Category Text Field as delegate
        transxTypeTxtField.delegate=self
        categoryTxtField.delegate=self
        //set the input view as picker view for Transaction Type Text Field & Transaction Category Text Field
        transxTypeTxtField.inputView = pickerView
        categoryTxtField.inputView = pickerView
        //It is important that goes after de inputView assignation
        self.pickerView = pickerView
        
        //call the function to create a done button at picker view
        createPicker()
        
        //call the function to create date picker
        createDatePicker()
    }
    
    override func didReceiveMemoryWarning() {
        // Dispose of any resources that can be recreated.
        super.didReceiveMemoryWarning()
    }
    
    //reload the components when the textfield is clicked
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerView?.reloadAllComponents()
    }
    
    func backreload(){
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
                amountTextField.text = ""
                amount = 0
            }
            //if the amount is less than 1 Million, proceed to update the amount
            else{
                amountTextField.text = updateAmount()
            }
        }
        
        // if user click the backspace
        if string == "" {
            amount = amount/10
            amountTextField.text = amount == 0 ? "": updateAmount()
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
        if transxTypeTxtField.isFirstResponder {
            return pickerDataType.count
        } else {
            return pickerDataCat.count
        }
    }
    
    // Do any additional setup after loading the view.
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if transxTypeTxtField.isFirstResponder{
            return pickerDataType[row]
        }
        else {
            return pickerDataCat[row]
        }
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if transxTypeTxtField.isFirstResponder{
            let itemselected = pickerDataType[row]
            transxTypeTxtField.text = itemselected
        }
        else{
            let itemselected = pickerDataCat[row]
            categoryTxtField.text = itemselected
        }
        
    }
    //create done toolbar on picker
    func createPicker(){
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //declare and set a done button on bar
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneTappedforPicker))
        toolbar.setItems([doneBtn], animated: true)
        
        //assign toolbar
        transxTypeTxtField.inputAccessoryView = toolbar
        categoryTxtField.inputAccessoryView = toolbar
    }
    
    //Function to create a date picker
    func createDatePicker(){
        
        dateTextField.textAlignment = .center
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //declare and set a done button on bar
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneTapped))
        toolbar.setItems([doneBtn], animated: true)
        
        //assign toolbar
        dateTextField.inputAccessoryView = toolbar
        
        //assign date picker to text field
        dateTextField.inputView = datepicker
        
        //date picker format
        datepicker.datePickerMode = .date
        
    }
    //function when the Save button is tapped
    @IBAction func saveTapped(sender: AnyObject) {
        
        //check the user input
        //when input in amountTextField is equal to 0 or empty
        if amountTextField.text == "0.00" || amountTextField.text == ""{
            //declare an alert when amount is empty
            let emptyamountAlert = UIAlertController(title: "Please input any transaction amount greater than 0", message: nil, preferredStyle:.alert)
            //add action to trigger the alert
            emptyamountAlert.addAction(UIAlertAction(title: "Dismiss",style: .default, handler: nil))
            present(emptyamountAlert,animated: true,completion: nil)
        }
            //when input in Transaction Type Text Field is empty
        else if transxTypeTxtField.text == ""{
            //declare an alert when transaction Type is empty
            let emptyTypeAlert = UIAlertController(title: "Please input your transaction type.", message: nil, preferredStyle:.alert)
            //add action to trigger the alert
            emptyTypeAlert.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
            present(emptyTypeAlert,animated: true,completion: nil)
        }
            
            //when input in Transaction Type Text Field is empty
        else if categoryTxtField.text == ""{
            //declare an alert when transaction category is empty
            let emptyCatAlert = UIAlertController(title: "Please input your transaction category.", message: nil, preferredStyle:.alert)
            //add action to trigger the alert
        emptyCatAlert.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
            present(emptyCatAlert,animated: true,completion: nil)
        }
            
            //when input in dateTextField is empty
        else if dateTextField.text == ""{
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
            
            
            //write all data into database
            let realm = try! Realm ()
            let transaction = Transaction()
            transaction.amount = Double(amountTextField.text!)!
            transaction.type = transxTypeTxtField .text!
            transaction.category = categoryTxtField.text!
            transaction.date = formatter3.date(from: dateTextField.text!)!
            var myvalue = realm.objects(Transaction.self).map{$0.id}.max() ?? 0
            myvalue = myvalue + 1
            transaction.id = myvalue
            try! realm.write {
                
                realm.add (transaction)
            }
            //reset all input field
            amountTextField.text = ""
            transxTypeTxtField.text = ""
            categoryTxtField.text = ""
            dateTextField.text = ""
            
            //declare an alert when transaction is saved
            let successAlert = UIAlertController(title: "Your transaction is successfully saved!", message: nil, preferredStyle:.alert)
            //add action to trigger the alert
        successAlert.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: { action in
                //when dismiss is cliced call the dismissTapped function
                self.dismissTapped() }))
            present(successAlert,animated: true,completion: nil)
            
        }
    }
    
    //function when the Done button is tapped
    @objc func doneTappedforPicker(){
        if transxTypeTxtField.isFirstResponder{
            
        transxTypeTxtField.resignFirstResponder()

                // get first index value of array if transaction type text field is empty
                if (transxTypeTxtField.text?.isEmpty)! {
                   transxTypeTxtField.text = self.pickerDataType.first
                }
        }
        else{
                            
            categoryTxtField.resignFirstResponder()

                    // get first index value of array if transaction category text field is empty
                    if (categoryTxtField.text?.isEmpty)! {
                       categoryTxtField.text = self.pickerDataCat.first
                    }
            
        }

        self.view.endEditing(true)
    }
    
    //function when the Done button is tapped
    @objc func doneTapped(){
        //formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        dateTextField.text = formatter.string(from: datepicker.date)
        self.view.endEditing(true)
    }
    //To set the redirection to Budget Overview
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
    if (segue.identifier == "FinishSaveTransxSegue") {
    let newSegue = segue.destination
    }}
    //Redirect user back to Budget Overview when the Dismiss button is clicked
    func dismissTapped(){
            self.performSegue(withIdentifier: "FinishSaveTransxSegue", sender: self)

        
    }
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? budgetOverviewViewController {
            controller.tableView_new.reloadData()
        }
    }
}

