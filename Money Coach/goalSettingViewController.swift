//
//  goalSettingViewController.swift
//  Money Coach
//
//  Created by Felicia on 14/06/2020.
//  Copyright © 2020 felicia. All rights reserved.
//

import UIKit
import RealmSwift
import Foundation


class goalSettingViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    var targetSavings: Double = 0.0
    var updatedVal: Double = 0.0
    var currentVal: Double = 0.0
    var amount: Int = 0

    var currentDate = Date()
    //declare and instantiate value for current savings = 0
    var currentSavings: Double = 0.0
    var goalIndexEdit: Int?

    //declare and define data set in the picker view for  Goal Type Text Field
    var pickerDataType = ["Weekly", "Monthly", "Yearly"]
    //declare and define an empty string for the selected row
    var itemSelected = ""
    //declare picker view
    weak var pickerView: UIPickerView?
    
    @IBOutlet weak var addButton: UIButton!
    //declare table view
    @IBOutlet var popupEditGoal: UIView!
    
    @IBOutlet weak var tableViewGoal: UITableView!
    //declare for database
    var realm: Realm!
    //store the data get from database as array
    var Weekly: Results <Goal>{
        get{
            return realm.objects(Goal.self).filter("goaltype == 'Weekly'").sorted(byKeyPath: "goalDueDate" , ascending: true)
        }
    }
    var Monthly: Results <Goal>{
        get{
            return realm.objects(Goal.self).filter("goaltype == 'Monthly'").sorted(byKeyPath: "goalDueDate" , ascending: true)
        }
    }
    var Yearly: Results <Goal>{
        get{
            return realm.objects(Goal.self).filter("goaltype == 'Yearly'").sorted(byKeyPath: "goalDueDate" , ascending: true)
        }
    }
    
    lazy var listToDisplay = Weekly
    //declare a date picker
    let datepicker1 = UIDatePicker()
    let datepicker2 = UIDatePicker()
    var edittedDueDate = Date()
    var edittedRemindDate = Date()

    
    //declare for the textfields and button for editgoal subview
    
    @IBOutlet weak var edit_GoalTitle: UITextField!
    @IBOutlet weak var edit_type: UITextField!
    @IBOutlet weak var edit_targetSavings: UITextField!
  
    @IBOutlet weak var edit_duedate: UITextField!
    @IBOutlet weak var edit_remindMe: UITextField!
    

    
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.popupEditGoal.removeFromSuperview()
    }
    @IBAction func updateGoalBtn(_ sender: UIButton) {
        //assign the value from date picker to due date & remind date variable
               edittedDueDate = datepicker1.date
               edittedRemindDate = datepicker2.date
               
               //check the user input
               //when input in amountTextField is equal to 0 or empty
               if edit_GoalTitle.text == ""{
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
               else if  edit_type.text == "" {
                   //declare an alert when Target Savings txtField is empty
                   let emptyGoalTypesAlert = UIAlertController(title: "Please input your Goal Type.", message: nil, preferredStyle:.alert)
                   //add action to trigger the alert
                   emptyGoalTypesAlert.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
                   present(emptyGoalTypesAlert,animated: true,completion: nil)
               }
                   //when input in Transaction Type Text Field is empty or 0
               else if  edit_targetSavings.text == "0.00" || edit_targetSavings.text == ""{
                   //declare an alert when Target Savings txtField is empty
                   let emptyTargetSavingsAlert = UIAlertController(title: "Please input target savings amount greater than 0.", message: nil, preferredStyle:.alert)
                   //add action to trigger the alert
                   emptyTargetSavingsAlert.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
                   present(emptyTargetSavingsAlert,animated: true,completion: nil)
               }
                   
                   //when input in Goal Due Date Type Text Field is empty
               else if edit_duedate.text == ""{
                   //declare an alert when Goal Due Date  is empty
                   let emptyGoalDuetAlert = UIAlertController(title: "Please input your Goal Due Date.", message: nil, preferredStyle:.alert)
                   //add action to trigger the alert
                   emptyGoalDuetAlert.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
                   present(emptyGoalDuetAlert,animated: true,completion: nil)
               }
               // when input an Remind Me On Date greater than Goal Due Date
               else if edittedRemindDate > edittedDueDate {
                   //declare an alert when Goal Remind Date  is greater than Goal Due date
                   let invalidGoalRemindAlert = UIAlertController(title: "Please select a Remind Me On Date that is earlier than/equal to your Goal Due Date.", message: nil, preferredStyle:.alert)
                   //add action to trigger the alert
                   invalidGoalRemindAlert.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
                   present(invalidGoalRemindAlert,animated: true,completion: nil)
               }
                   
                //if all field are filled in with valid user input
            //to format the Date data to be saved into database
            let formatter3   = DateFormatter()
            formatter3.dateStyle = .medium
            formatter3.timeStyle = .none
            edittedDueDate = formatter3.date(from: edit_duedate.text!)!
        //edittedRemindDate = formatter3.date(from: edit_remindMe.text!)!
            
               try! realm.write {
                realm.create(Goal.self, value: ["title":edit_GoalTitle.text!, "goaltype":edit_type.text!,"targetSavings":Double(edit_targetSavings.text!)!,"goalDueDate": edittedDueDate], update: .modified)
                //"remindDate": edittedRemindDate
                }
            //declare an alert when goal title txtfield is empty
                   let updateAlert = UIAlertController(title: "Your goal details is succesfully updated.", message: nil, preferredStyle:.alert)
                   //add action to trigger the alert
            updateAlert.addAction(UIAlertAction(title: "Dismiss",style: .default,handler: nil))
                   present(updateAlert,animated: true,completion: nil)
           
        //reset the text fields after update any goal.
            self.edit_GoalTitle.text = ""
            self.edit_type.text = ""
            self.edit_targetSavings.text = ""
            self.edit_duedate.text = ""
            self.edit_remindMe.text = ""


            self.popupEditGoal.removeFromSuperview()
            self.tableViewGoal?.reloadData()
        }
        
    
    //perform action according to the selected segment (weekly, monthly,yearly)
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        //when user click on first segment (index 0), show the
        case 0:
              listToDisplay = Weekly
        case 1:
              listToDisplay = Monthly
        default:
              listToDisplay = Yearly
        }
        tableViewGoal.reloadData()
        }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //getTargetSavings()
        
        //trigger the database
        realm = try! Realm()
        //register customised table view cell for the table view
        let nib = UINib (nibName: "goalListTableViewCell", bundle: nil)
        tableViewGoal.register(nib, forCellReuseIdentifier: "goalListTableViewCell")
        //set table view as delegate
        tableViewGoal.delegate = self
        tableViewGoal.dataSource = self
        tableViewGoal.reloadData()
        //set delegate for edit text field
        edit_targetSavings.delegate = self
        //add target to Goal Title Text Field
        edit_GoalTitle.addTarget(self, action: #selector(editingChanged(sender:)), for: .editingChanged)

        //add a gesture recognizer for the pickerview
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        //declare picker view
               let pickerView = UIPickerView()
               //set the picker view as delegate
               pickerView.delegate = self
               pickerView.dataSource = self
               //set the Goal Type Text Field as delegate
               edit_type.delegate=self
        //set the input view as picker view for Goal Type Text Field
        edit_type.inputView = pickerView
        //It is important that goes after de inputView assignation
        self.pickerView = pickerView
        //call the function to create a done button at picker view
        createPicker()
        
        //call the function to create date picker
        createDatePicker()

    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "editGoal"{
//            let popup = segue.destination as! editGoalViewController
//            popup.goalIndexEdit = self.goalIndexEdit
//            popup.doneSaving = {[weak self] in
//                self?.tableViewGoal.reloadData()
//
//            }
//        }
//
//    }
    override func viewDidLayoutSubviews() {
    if let index =  goalIndexEdit {
        if listToDisplay.count>0{
          let editGoal = listToDisplay[index]
            }
          
    }
    }
     //function to set the input target savings amount into currency type input
     @objc func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool{
         if let digit = Int (string){
             
             amount = amount * 10 + digit
             if amount > 100_000_000{
                 //declare an alert when user enter more than 1 Million
                 let targetOverAlert = UIAlertController(title: "Please Input amount less than 1 Million", message: nil, preferredStyle:.alert)
                 //add action to trigger the alert
                 targetOverAlert.addAction(UIAlertAction(title: "Dismiss",style: .default,handler: nil))
                 present(targetOverAlert,animated: true,completion: nil)
                 //reset the amount to 0
                 edit_targetSavings.text = ""
                 amount = 0
             }
                 //if the amount is less than 1 Million, proceed to update the amount
             else{
                edit_targetSavings.text = updateAmount()
             }
         }
         
         // if user click the backspace
         if string == "" {
             amount = amount/10
             edit_targetSavings.text = amount == 0 ? "": updateAmount()
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

    //function to validate the input length for the Goal Title field
    @objc private func editingChanged(sender: UITextField) {
        //set the max length to 100 chars
        let maxLength = 100
        if let text = sender.text, text.count >= maxLength {
            sender.text = String(text.dropLast(text.count - maxLength))
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
               edit_type.text = itemselected
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
           edit_type.inputAccessoryView = toolbar
       }
       //function when the Done button is tapped
       @objc func doneTappedforPicker(){
           
           edit_type.resignFirstResponder()

             // get first index value of array if goal type text field is empty
             if (edit_type.text?.isEmpty)! {
                edit_type.text = self.pickerDataType.first
             }

             view.endEditing(true)
       }
       
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if listToDisplay.count == 0{
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableViewGoal.bounds.size.width, height: tableViewGoal.bounds.size.height))
                                      noDataLabel.text = " You have not set any financial goal yet. 😅 Please click the '+' icon to add your goals. 😄"
                                      noDataLabel.textColor     = UIColor.black
                                      noDataLabel.numberOfLines = 0
                                      noDataLabel.textAlignment = .center
                                      tableViewGoal.backgroundView  = noDataLabel
                                      tableViewGoal.separatorStyle  = .none
        }
        else{
            tableViewGoal.backgroundView  = .none
        }
            return listToDisplay.count
    }
    override func didReceiveMemoryWarning() {
             // Dispose of any resources that can be recreated.
             super.didReceiveMemoryWarning()
         }
    //reload the components when the textfield is clicked
          func textFieldDidBeginEditing(_ textField: UITextField) {
              self.pickerView?.reloadAllComponents()
          }
    func createDatePicker(){
        
        edit_duedate.textAlignment = .center
        edit_remindMe.textAlignment = .center

        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //declare and set a done button on bar
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneTapped))
        toolbar.setItems([doneBtn], animated: true)
        
        //assign toolbar
        edit_duedate.inputAccessoryView = toolbar
        edit_remindMe.inputAccessoryView = toolbar

        //assign date picker to text field
        edit_duedate.inputView = datepicker1
        edit_remindMe.inputView = datepicker2
        
        //date picker format
        datepicker1.datePickerMode = .date
        
        // minimum date is today
        datepicker1.minimumDate = Date()
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
        if  edit_duedate.isFirstResponder{
            edit_duedate.text = formatter.string(from: datepicker1.date)
        }
        // else,return data selected from the date picker to the Remind me on Textfield
        else{
            edit_remindMe.text = Remindformatter.string(from: datepicker2.date)
        }
        self.view.endEditing(true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalListTableViewCell", for: indexPath) as! goalListTableViewCell
        let goal = listToDisplay[indexPath.row]
        getSavings(goal: goal)
        // return each data from database into respective labels on the customised table view cell
        cell.goalTitlelbl.text = goal.title
        cell.goalTargetlbl.text = "RM " + String (goal.targetSavings)
        cell.goalStatuslbl.text = "Status: " + goal.status
        //create date formatter to format the date shows
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        cell.goalDuelbl.text = formatter.string(from: goal.goalDueDate)
        
        var percent: Float = Float(currentVal/goal.targetSavings*100)
        
    //if the calculated percentage>100, set the percentage to 100
       if percent > 100{
        percent = 100
        cell.goalStatuslbl.text = "Status:Completed"
        cell.backgroundColor = .gray
       }
       else if percent>0 && percent<100{
        cell.goalStatuslbl.text = "Status:On-Going"
        cell.backgroundColor = .white

        }
        else if percent == 0{
        cell.goalStatuslbl.text = "Status:New"
        cell.backgroundColor = .white

        }

        cell.progressLBL.text = String (Int(percent)) + "%"
        cell.progressControl.progress = (percent/100)
        
        
        if cell.goalStatuslbl.text == "Status:Completed"{
            cell.backgroundColor = .gray
        }
        return cell
    }
    
  
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //when user click on delete
        if editingStyle == UITableViewCell.EditingStyle.delete {
            //when row is selected
            let goal1 = listToDisplay[indexPath.row]
                //declare an alert when user try to delete a goal
                let deleteAlert = UIAlertController(title: " Are you sure you want to delete this goal?", message: nil, preferredStyle:.alert)
                //add action to trigger the alert
                //when user click on "Cancel"
                deleteAlert.addAction(UIAlertAction(title: "Cancel",style: .default,handler: nil))
                //when user click on "Yes"
                deleteAlert.addAction(UIAlertAction(title: "Yes",style: .default,handler: { (action: UIAlertAction!) in
                
                    //delete the goal from database
                    try! self.realm.write {
                        self.realm.delete(goal1)
                    }
                    //delete the row in table view
                    self.tableViewGoal.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            }))
            //show the alert
            present(deleteAlert,animated: true,completion: nil)

            
    }
    
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if listToDisplay[indexPath.row].status == "New"{
        return false
        }
        else{
        return true
        }
    }
    
  //show edit function when swipe to left
    func tableView (_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) ->UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler: (Bool) -> ()) in
              self.goalIndexEdit = indexPath.row
              self.view.addSubview(self.popupEditGoal)
              self.popupEditGoal.center = self.view.center
           }
           edit.image = UIImage(named: "edit-icon")
           edit.backgroundColor = .blue
          return UISwipeActionsConfiguration(actions: [edit])
          }
    
    
    

    func getSavings(goal: Goal){
        let realm = try! Realm()
        currentVal = 0

        let dateFormatter = DateFormatter()
        let goal_date =  dateFormatter.string(from:goal.createdDate)
        
        print("dataSavings. goal", goal.targetSavings ,  goal.createdDate)
        let allSavingsData = realm.objects(Transaction.self).filter("type = 'Savings' AND date >= %@", goal.createdDate)

        if allSavingsData.count>0{
            for dataSavings in allSavingsData{
                print("dataSavings.date",dataSavings.amount, dataSavings.date)
                currentVal += dataSavings.amount
                                }
        }
    }
    
}
