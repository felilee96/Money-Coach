//
//  addGoalViewController.swift
//  Money Coach
//
//  Created by Felicia on 08/06/2020.
//  Copyright © 2020 felicia. All rights reserved.
//

import UIKit
import RealmSwift

class addGoalViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
    
    //connecting textLabel: Goal Title to code
    @IBOutlet weak var goalTitlelbl: UILabel!
    //connecting text field: Goal Title to code
    @IBOutlet weak var goalTitleTxtField: UITextField!
    //connecting text label: count to code
    @IBOutlet weak var textCountlbl: UILabel!
    
    //connecting text label: Goal Type to code
    @IBOutlet weak var goalTypelbl: UILabel!
//connecting text field: Goal Type to code
    @IBOutlet weak var goalTypeTxtField: UITextField!
    //declare and define data set in the picker view for  Goal Type Text Field
    var pickerDataType = ["Weekly", "Monthly", "Yearly"]
    //declare and define an empty string for the selected row
    var itemSelected = ""
    //declare picker view
    weak var pickerView: UIPickerView?
    
    //connecting text label: Target Savings to code
    @IBOutlet weak var targetSavingslbl: UILabel!
    //connecting text label: Target Savings to code
    @IBOutlet weak var RMlbl: UILabel!
    //connecting text field: Target Savings to code
    @IBOutlet weak var targetSavingsTxtField: UITextField!
    //declare & instantiate target savings
    var targetSavings: Int = 0
    
    //initialise goal due date & reminder date to be used for condition checking
    var dueDate = Date()
    var remindDate = Date()
    
    //connecting text label: Goal Due Date to code
    @IBOutlet weak var goalDueDatelbl: UILabel!
    //connecting text field: Goal Due Date to code
      @IBOutlet weak var goalDueDateTxtField: UITextField!
    //connecting text label: Remind me on to code
    @IBOutlet weak var remindDatelbl: UILabel!
    //connecting text field: Remind me on to code
    @IBOutlet weak var remindDatetxtField: UITextField!
    
    //declare a date picker
    let datepicker = UIDatePicker()
    let datepicker2 = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm ()
        print(Realm.Configuration.defaultConfiguration.fileURL)
        //set amount Text Field as delegate
        //add target to Goal Title Text Field
        goalTitleTxtField.addTarget(self, action: #selector(editingChanged(sender:)), for: .editingChanged)
        
        //set Target Savings Text Field as delegate
        targetSavingsTxtField.delegate = self
        //set the placeholder for the Target Savings Text Field
        targetSavingsTxtField.placeholder = "0.00"

        //create a Save Button on Navigation Bar
        let save = UIBarButtonItem (barButtonSystemItem: .save, target: self, action: #selector(saveGoalTapped))
        navigationItem.rightBarButtonItems = [save]

        //add a gesture recognizer for the pickerview
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        //declare picker view
        let pickerView = UIPickerView()
        //set the picker view as delegate
        pickerView.delegate = self
        pickerView.dataSource = self
        //set the Goal Type Text Field as delegate
        goalTypeTxtField.delegate=self
        //set the input view as picker view for Goal Type Text Field
        goalTypeTxtField.inputView = pickerView
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
    
    //function to validate the input length for the Goal Title field
    @objc private func editingChanged(sender: UITextField) {
        //set the max length to 100 chars
        let maxLength = 100
        if let text = sender.text, text.count >= maxLength {
            sender.text = String(text.dropLast(text.count - maxLength))
        }
    }

    
    //function to set the input target savings amount into currency type input
    @objc func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool{
        if let digit = Int (string){
            
            targetSavings = targetSavings * 10 + digit
            if targetSavings > 100_000_000{
                //declare an alert when user enter more than 1 Million
                let targetOverAlert = UIAlertController(title: "Please Input amount less than 1 Million", message: nil, preferredStyle:.alert)
                //add action to trigger the alert
                targetOverAlert.addAction(UIAlertAction(title: "Dismiss",style: .default,handler: nil))
                present(targetOverAlert,animated: true,completion: nil)
                //reset the amount to 0
                targetSavingsTxtField.text = ""
                targetSavings = 0
            }
                //if the amount is less than 1 Million, proceed to update the amount
            else{
                targetSavingsTxtField.text = updateAmount()
            }
        }
        
        // if user click the backspace
        if string == "" {
            targetSavings = targetSavings/10
            targetSavingsTxtField.text = targetSavings == 0 ? "": updateAmount()
        }
        return false
    }
    
   
    //create amount text field function
    @objc func updateAmount() -> String?{
        // to start the amount at 0.00
        let amt = Double (targetSavings/100) + Double (targetSavings%100)/100
        return String(format: "%.2f", amt)

    }
    //when user click outside the keyboards area, stop editting the textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }


    //function when the Save button is tapped
    @IBAction func saveGoalTapped(sender: AnyObject) {
        //assign the value from date picker to due date & remind date variable
        dueDate = datepicker.date
        remindDate = datepicker2.date
        
        //check the user input
        //when input in amountTextField is equal to 0 or empty
        if goalTitleTxtField.text == ""{
            //declare an alert when goal title txtfield is empty
            let emptyGoalTitleAlert = UIAlertController(title: "Please input your Goal Title.", message: nil, preferredStyle:.alert)
            //add action to trigger the alert
    emptyGoalTitleAlert.addAction(UIAlertAction(
                title: "Dismiss",
                style: .default,
                handler: nil))
            present(emptyGoalTitleAlert,animated: true,completion: nil)
        }
            //when input in Goal Type Text Field is empty
        else if  goalTypeTxtField.text == "" {
            //declare an alert when Target Savings txtField is empty
            let emptyGoalTypesAlert = UIAlertController(title: "Please input your Goal Type.", message: nil, preferredStyle:.alert)
            //add action to trigger the alert
            emptyGoalTypesAlert.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
            present(emptyGoalTypesAlert,animated: true,completion: nil)
        }
            //when input in Transaction Type Text Field is empty or 0
        else if  targetSavingsTxtField.text == "0.00" || targetSavingsTxtField.text == ""{
            //declare an alert when Target Savings txtField is empty
            let emptyTargetSavingsAlert = UIAlertController(title: "Please input target savings amount greater than 0.", message: nil, preferredStyle:.alert)
            //add action to trigger the alert
            emptyTargetSavingsAlert.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
            present(emptyTargetSavingsAlert,animated: true,completion: nil)
        }
            
            //when input in Goal Due Date Type Text Field is empty
        else if goalDueDateTxtField.text == ""{
            //declare an alert when Goal Due Date  is empty
            let emptyGoalDuetAlert = UIAlertController(title: "Please input your Goal Due Date.", message: nil, preferredStyle:.alert)
            //add action to trigger the alert
            emptyGoalDuetAlert.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
            present(emptyGoalDuetAlert,animated: true,completion: nil)
        }
        // when input an Remind Me On Date greater than Goal Due Date
        else if remindDate > dueDate {
            //declare an alert when Goal Remind Date  is greater than Goal Due date
            let invalidGoalRemindAlert = UIAlertController(title: "Please select a Remind Me On Date that is earlier than/equal to your Goal Due Date.", message: nil, preferredStyle:.alert)
            //add action to trigger the alert
            invalidGoalRemindAlert.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
            present(invalidGoalRemindAlert,animated: true,completion: nil)
        }
            
         //if all field are filled in with valid user input
        else{
            //to format the Date data to be saved into database
            let formatter4   = DateFormatter()
            formatter4.dateStyle = .medium
            formatter4.timeStyle = .none
            
            
            //write all data into database
            let realm = try! Realm ()
            let goal = Goal()
            goal.title = goalTitleTxtField.text!
            goal.goaltype = goalTypeTxtField .text!
            goal.targetSavings = Double(targetSavingsTxtField.text!)!
            goal.goalDueDate = formatter4.date(from: goalDueDateTxtField.text!)!
            goal.status = "New"
            goal.createdDate = Date()
            //goal.remindDate = formatter4.date(from: remindDatetxtField.text!)!
            var myval = realm.objects(Goal.self).map{$0.goalid}.max() ?? 0
            myval = myval + 1
            goal.goalid = myval


            try! realm.write {
                
                realm.add (goal)
            }
            //reset all input field
            goalTitleTxtField.text = ""
            goalTypeTxtField.text = ""
            targetSavingsTxtField.text = ""
            goalDueDateTxtField.text = ""
            remindDatetxtField.text = ""
            
            //declare an alert when transaction is saved
            let successAddGoalAlert = UIAlertController(title: "Your goal is successfully saved!", message: nil, preferredStyle:.alert)
            //add action to trigger the alert
            successAddGoalAlert.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: { action in
                //when dismiss is cliced call the dismissTapped function
                self.dismissGoalSuccessTapped() }))
            present(successAddGoalAlert,animated: true,completion: nil)
        }
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return pickerDataType.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return pickerDataType[row]
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let itemselected = pickerDataType[row]
            goalTypeTxtField.text = itemselected
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
        goalTypeTxtField.inputAccessoryView = toolbar
    }
    //function when the Done button is tapped
    @objc func doneTappedforPicker(){
        
        goalTypeTxtField.resignFirstResponder()

          // get first index value of array if goal type text field is empty
          if (goalTypeTxtField.text?.isEmpty)! {
             goalTypeTxtField.text = self.pickerDataType.first
          }

          view.endEditing(true)
    }
    
    //Function to create a date picker
    func createDatePicker(){
        
        goalDueDateTxtField.textAlignment = .center
        remindDatetxtField.textAlignment = .center

        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //declare and set a done button on bar
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneTapped))
        toolbar.setItems([doneBtn], animated: true)
        
        //assign toolbar
        goalDueDateTxtField.inputAccessoryView = toolbar
        remindDatetxtField.inputAccessoryView = toolbar

        //assign date picker to text field
        goalDueDateTxtField.inputView = datepicker
        remindDatetxtField.inputView = datepicker2
        
        //date picker format
        datepicker.datePickerMode = .date
        
        // minimum date is today
        datepicker.minimumDate = Date()
        datepicker2.minimumDate = Date()

        

    }
    //function when the Done button is tapped
    @objc func doneTapped(){
        //formatter for Goal Due Date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        //formatter for Remind Me on Date & Time
        let Remindformatter = DateFormatter()
        Remindformatter.dateStyle = .medium
        Remindformatter.timeStyle = .short
        //if user clicking on the Goal Due Date Text Field, return data selected from the date picker to the Goal Due Date Textfield
        if  goalDueDateTxtField.isFirstResponder{
            goalDueDateTxtField.text = formatter.string(from: datepicker.date)
        }
        // else,return data selected from the date picker to the Remind me on Textfield
        else{
            remindDatetxtField.text = Remindformatter.string(from: datepicker2.date)
        }
        self.view.endEditing(true)
    }
   

    //To set the redirection to Goal Listing
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if (segue.identifier == "addGoalSuccessSegue") {
            let goalSegue = segue.destination
        }}
    
    //Redirect user back to Goal Listing when the Dismiss button is clicked
    func dismissGoalSuccessTapped(){
        self.performSegue(withIdentifier: "addGoalSuccessSegue", sender: self)
    }
}
