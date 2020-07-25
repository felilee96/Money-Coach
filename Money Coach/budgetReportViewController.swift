//
//  budgetReportViewController.swift
//  Money Coach
//
//  Created by Felicia on 21/06/2020.
//  Copyright © 2020 felicia. All rights reserved.
//

import UIKit
import SwiftCharts
import RealmSwift

class budgetReportViewController: UIViewController {

    var transactionArray: Array<Transaction> = []

    var sumBudgetTransx : Double = 0.0
    var sumExpensesTransx : Double = 0.0
    var sumIncomeTransx : Double = 0.0
    var sumSavings: Double = 0.0
    //connect savings icon to the code
        @IBOutlet weak var savingIcon: UIImageView!
        //connect savings text label to the code
        @IBOutlet weak var savingLbl: UILabel!
        //connect savings label (total amouunt) to the code
        @IBOutlet weak var savingAmountlbl: UILabel!
     @IBOutlet weak var fromDate: UITextField!
     @IBOutlet weak var toDate: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    //declare a date picker
    let datepicker = UIDatePicker()
    let datepicker2 = UIDatePicker()
    
    //initialise From date & To date to be used for condition checking
     var fromDateData = Date()
     var toDateData = Date()
    
 var budgetBarChart: BarsChart!
    override func viewDidLoad() {
        createDatePicker()

        super.viewDidLoad()
        
        getBudget()
        getExpenses()
        getIncome()
        
    let chartConfig = BarsChartConfig(
        //set the minimum & maximum value,and ratio for the chart
        valsAxisConfig: ChartAxisConfig(from: 0, to: 1000, by: 100)
    )

    let frame = CGRect(x: 0, y: 120, width: 400, height: 475)
            
    let chart = BarsChart(
        frame: frame,
        chartConfig: chartConfig,
        xTitle: "Transaction Type",
        yTitle: "Amount (RM)",
        bars: [
            ("Budget", sumBudgetTransx),
            ("Expenses", sumExpensesTransx),
            ("Income", sumIncomeTransx)],
        color:  UIColor(named: "Color-8")!,
        barWidth: 50
    )

    self.view.addSubview(chart.view)
    self.budgetBarChart = chart

    }
    
      func getBudget(){
                let realm = try! Realm()
                let budgetTypeData: String = "Budget"
                var allDataBudget = realm.objects(Transaction.self).filter("type = '\(budgetTypeData)'")
                if allDataBudget.count>0{
                    for dataBudget in allDataBudget{
                        sumBudgetTransx += dataBudget.amount
                }
            }
       
    }
    func getExpenses(){
                let realm = try! Realm()
                let ExpTypeData: String = "Expenses"
                var allDataExp = realm.objects(Transaction.self).filter("type = '\(ExpTypeData)'")
                if allDataExp.count>0{
                    for dataExp in allDataExp{
                        sumExpensesTransx += dataExp.amount
                }
            }
       
    }
    func getIncome(){
                   let realm = try! Realm()
                   let IncomeTypeData: String = "Income"
                   var allDataIncome = realm.objects(Transaction.self).filter("type = '\(IncomeTypeData)'")
                   if allDataIncome.count>0{
                       for dataInc in allDataIncome{
                           sumIncomeTransx += dataInc.amount
                   }
               }
          
       }
    
    func getMonthlySavinhgs() {
        let date = Date()
        let calendar = Calendar.current

        var beginningOfMonth: Date?
        var endOfMonth: Date?

        beginningOfMonth = calendar.dateInterval(of: .month, for: date)?.start
            endOfMonth = calendar.dateInterval(of: .month, for: date)?.end
        
        let realm = try! Realm()
                   let allDataSavings = realm.objects(Transaction.self).filter("type = 'Savings'")
                   let suballDataSavings = allDataSavings.filter("date BETWEEN %@", [beginningOfMonth, endOfMonth])
                   
                              if suballDataSavings.count>0{
                                  
                                 for savings in suballDataSavings{
                                      sumSavings += savings.amount
                            savingAmountlbl.text = String(sumSavings)

                            }
                                }
        }
    
    //Function to create a date picker
        func createDatePicker(){
            
            fromDate.textAlignment = .center
            toDate.textAlignment = .center

            //toolbar
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            
            //declare and set a done button on bar
            let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneTapped))
            toolbar.setItems([doneBtn], animated: true)
            
            //assign toolbar
            fromDate.inputAccessoryView = toolbar
            toDate.inputAccessoryView = toolbar

            //assign date picker to text field
            fromDate.inputView = datepicker
            toDate.inputView = datepicker2
            
            //date picker format
            datepicker.datePickerMode = .date
            datepicker2.datePickerMode = .date
            
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
             // else,return data selected from the date picker to the Remind me on Textfield
             else{
                 toDate.text = formatter.string(from: datepicker2.date)
             }
             self.view.endEditing(true)
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
                        sumBudgetTransx = 0

                           let realm = try! Realm()
                        let allData = realm.objects(Transaction.self).filter("type = 'Budget'")
                                
                               let dateFormatter = DateFormatter()
                               dateFormatter.dateFormat = "dd/MM/yyyy"

                               let dateString =  dateFormatter.string(from: fromDateData)
                               let dateString2 = dateFormatter.string(from: toDateData)
                        
                        let dateFromString1 = dateFormatter.date(from: dateString)
                              let dateFromString2 = dateFormatter.date(from: dateString2)
                       // transactionArray.removeAll()

                        let selectedMonth = allData.filter("date BETWEEN %@", [dateFromString1, dateFromString2])

                                   for selectedData in selectedMonth{
//                                    var  sum = 0.0
                                    sumBudgetTransx += selectedData.amount
                                    //print("data here", sum)
                                    
                                     self.viewDidLoad()
                       }
            }
    
}

}
