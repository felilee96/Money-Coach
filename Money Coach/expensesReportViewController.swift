//
//  ExpensesReportViewController.swift
//  Money Coach
//
//  Created by Felicia on 20/06/2020.
//  Copyright © 2020 felicia. All rights reserved.
//

import UIKit
import Charts
import RealmSwift

class ExpensesReportViewController: UIViewController {
    
    @IBOutlet var noDataInfo: UIView!
    
  //define and initialise the sum for the expenses of each category
     var sumCATFood: Double = 0.0
     var sumCATGroceries: Double = 0.0
     var sumCATBills: Double = 0.0
     var sumCATTransportation: Double = 0.0
     var sumCATEntertainment: Double = 0.0
     var sumCATRental: Double = 0.0
     var sumCATShopping: Double = 0.0
     var sumCATHealth: Double = 0.0
     var sumCATSport: Double = 0.0
     var sumCATEducation: Double = 0.0
     var sumCATElectronic: Double = 0.0
     var sumCATHolidays: Double = 0.0
     var sumCATOthers: Double = 0.0

    
    //define data for pie chart data entry
    var Data1 = PieChartDataEntry(value: 0)
    var Data2 = PieChartDataEntry(value: 0)
    var Data3 = PieChartDataEntry(value: 0)
    var Data4 = PieChartDataEntry(value: 0)
    var Data5 = PieChartDataEntry(value: 0)
    var Data6 = PieChartDataEntry(value: 0)
    var Data7 = PieChartDataEntry(value: 0)
    var Data8 = PieChartDataEntry(value: 0)
    var Data9 = PieChartDataEntry(value: 0)
    var Data10 = PieChartDataEntry(value: 0)
    var Data11 = PieChartDataEntry(value: 0)
    var Data12 = PieChartDataEntry(value: 0)
    var Data13 = PieChartDataEntry(value: 0)
    

     var numberofEntry = [PieChartDataEntry]()
     
    //dummy
//    var formattedDate: String = ""
  var dateString1: String = ""
    var dateString2: String = ""
    var dateFromString1 = Date()
    var dateFromString2 = Date()
    
    
     //connect pie chart view to the code
     @IBOutlet weak var pieChart: PieChartView!
     @IBOutlet weak var fromDate: UITextField!
     @IBOutlet weak var toDate: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    //declare a date picker
    let datepicker = UIDatePicker()
    let datepicker2 = UIDatePicker()
    
    //initialise From date & To date to be used for condition checking
     var fromDateData = Date()
     var toDateData = Date()
    
    
@IBAction func Dismiss(_ sender: UIButton) {
        self.noDataInfo.removeFromSuperview()
performSegue(withIdentifier: "goToAddTransaction", sender: nil)

    }
    
     //when the view is loaded
    override func viewDidLoad() {
        
        super.viewDidLoad()
        createDatePicker()
        //call the functions to get ths sum of expenses of each category
         getCATFood()
         getCATGroceries()
         getCATBills()
         getCATTransportation()
         getCATEntertainment()
         getCATRental()
         getCATShopping()
         getCATHealth()
         getCATSport()
         getCATEducation()
         getCATElectronic()
         getCATHolidays()
         getCATOthers()
        
        if sumCATFood == 0.0 && sumCATGroceries == 0 && sumCATBills == 0.0 && sumCATTransportation == 0.0 && sumCATEntertainment == 0.0 && sumCATRental == 0.0 && sumCATShopping == 0.0 && sumCATHealth == 0.0 && sumCATSport == 0.0 && sumCATEducation == 0.0 && sumCATElectronic == 0.0 && sumCATHolidays == 0.0 && sumCATOthers == 0.0{
            self.view.addSubview(self.noDataInfo)
            self.noDataInfo.center = self.view.center
            
        }
                
        // when this view is loaded, get current month & year for filter the data
        let dateFormatter = DateFormatter()
                              dateFormatter.dateFormat = "dd/MM/yyyy"
                            dateString1 =  dateFormatter.string(from: Date().getThisMonthStart()!)
        
                            dateString2 = dateFormatter.string(from: Date().getThisMonthEnd()!)
        
      let   dateFromString1 = dateFormatter.date(from: dateString1)
      let    dateFromString2 = dateFormatter.date(from: dateString2)
         //assign the sum of each category to Data, as pie chart data entry
         //label the data to be shown in pie chart
         //only add the data set into pie chart data entry if the values of sum > 0
         
         if sumCATFood > 0 {
             Data1.value = sumCATFood
             Data1.label = "Food"
             numberofEntry.append(Data1)
         }
         
         if sumCATGroceries > 0 {
             Data2.value = sumCATGroceries
             Data2.label = "Groceries"
             numberofEntry.append(Data2)
         }
        
         if sumCATBills > 0 {
             Data3.value = sumCATBills
             Data3.label = "Bills"
             numberofEntry.append(Data3)
         }
         
         if sumCATTransportation > 0{
             Data4.value = sumCATTransportation
             Data4.label = "Transportation"
             numberofEntry.append(Data4)
         }
         
         if sumCATEntertainment > 0{
             Data5.value = sumCATEntertainment
             Data5.label = "Entertainment"
             numberofEntry.append(Data5)
         }
         if sumCATRental > 0{
             Data6.value = sumCATRental
             Data6.label = "Rental"
             numberofEntry.append(Data6)
         }
         if sumCATShopping > 0{
             Data7.value = sumCATShopping
             Data7.label = "Shopping"
             numberofEntry.append(Data7)
         }
         if sumCATHealth > 0{
             Data8.value = sumCATHealth
             Data8.label = "Health"
             numberofEntry.append(Data8)
         }
         if sumCATSport > 0{
            Data9.value = sumCATSport
            Data9.label = "Sport"
            numberofEntry.append(Data9)
         }
         if sumCATEducation > 0{
            Data10.value = sumCATEducation
            Data10.label = "Education"
            numberofEntry.append(Data10)
         }
         if sumCATElectronic > 0{
          Data11.value = sumCATElectronic
          Data11.label = "Electronic"
          numberofEntry.append(Data11)
         }
         if sumCATHolidays > 0{
          Data12.value = sumCATHolidays
          Data12.label = "Holidays"
          numberofEntry.append(Data12)
         }
         if sumCATOthers > 0{
          Data13.value = sumCATOthers
          Data13.label = "Others"
          numberofEntry.append(Data13)
         }
         
         //call the function to update the Chart Data
         updateChartData()
        
    }
    
    //function to update chart appearance & data
       func updateChartData(){
           
           //assign array that store data for each category to the chart data set
           let chartDataSet = PieChartDataSet(entries: numberofEntry,label: nil)
           let chartData = PieChartData(dataSet: chartDataSet)
           
           //set the color for each category to show in pie chart
           let colors = [UIColor(named:"Color-1"), UIColor(named:"Color-2"),UIColor(named:"Color-3"),UIColor(named:"Color-4"),UIColor(named:"Color-5"),UIColor(named:"Color-6"),UIColor(named:"Color-7"),UIColor(named:"Color-8"),UIColor(named:"Color-9"),UIColor(named:"Color-10"),UIColor(named:"Color-11"),UIColor(named:"Color-12"),UIColor(named:"Color-13")]
           
           chartDataSet.colors = colors as! [NSUIColor]
           pieChart.data = chartData
       }
       
       //to get the sum of expenses for Food category from database
       func getCATFood(){
         let realm = try! Realm()
           let allDataFood = realm.objects(Transaction.self).filter("type = \"Expenses\" AND category = \"Food\"")
                    if allDataFood.count>0{
                        for dataFood in allDataFood{
                            sumCATFood += dataFood.amount
                       }
           }
       }
       
       //to get the sum of expenses for Groceries category from database
       func getCATGroceries(){
         let realm = try! Realm()
           let allDataGroceries = realm.objects(Transaction.self).filter("type = \"Expenses\" AND category = \"Groceries\"")
          if allDataGroceries.count>0{
           
          for dataGrocer in allDataGroceries{
               sumCATGroceries += dataGrocer.amount
          }
                  
        }
        
    }
                    
           

      //to get the sum of expenses for Bills category from database
       func getCATBills(){
           let realm = try! Realm()
             let allDataBills = realm.objects(Transaction.self).filter("type = \"Expenses\" AND category = \"Bills\"")
                      if allDataBills.count>0{
                          
                         for dataBills in allDataBills{
                              sumCATBills += dataBills.amount
                         }
             }
         }
       //to get the sum of expenses for Transportation category from database
       func getCATTransportation(){
           let realm = try! Realm()
             let allDataTransportation = realm.objects(Transaction.self).filter("type = \"Expenses\" AND category = \"Transportation\"")
                      if allDataTransportation.count>0{
                          
                         for dataTransportation in allDataTransportation{
                              sumCATTransportation += dataTransportation.amount
                         }
             }
         }
       
       
       //to get the sum of expenses for Entertainment category from database
          func getCATEntertainment(){
              let realm = try! Realm()
                let allDataEntertainment = realm.objects(Transaction.self).filter("type = \"Expenses\" AND category = \"Entertainment\"")
                         if allDataEntertainment.count>0{
                             
                            for dataEnt in allDataEntertainment{
                                 sumCATEntertainment += dataEnt.amount
                            }
                }
            }
      
       //to get the sum of expenses for Rental category from database
       func getCATRental(){
           let realm = try! Realm()
             let allDataRental = realm.objects(Transaction.self).filter("type = \"Expenses\" AND category = \"Rental\"")
                      if allDataRental.count>0{
                          
                         for dataRental in allDataRental{
                              sumCATRental += dataRental.amount
                         }
             }
         }
       //to get the sum of expenses for Shopping category from database
       func getCATShopping(){
           let realm = try! Realm()
             let allDataShopping = realm.objects(Transaction.self).filter("type = \"Expenses\" AND category = \"Shopping\"")
                      if allDataShopping.count>0{
                          
                         for dataShopping in allDataShopping{
                              sumCATShopping += dataShopping.amount
                         }
             }
         }
       //to get the sum of expenses for Health category from database
          func getCATHealth(){
              let realm = try! Realm()
                let allDataHealth = realm.objects(Transaction.self).filter("type = \"Expenses\" AND category = \"Health\"")
                         if allDataHealth.count>0{
                             
                            for dataHealth in allDataHealth{
                                 sumCATHealth += dataHealth.amount
                            }
                }
            }
       
          //to get the sum of expenses for Sport category from database
             func getCATSport(){
                 let realm = try! Realm()
                   let allDataSport = realm.objects(Transaction.self).filter("type = \"Expenses\" AND category = \"Sport\"")
                            if allDataSport.count>0{
                                
                               for dataSport in allDataSport{
                                    sumCATSport += dataSport.amount
                               }
                   }
               }
          
          //to get the sum of expenses for Education category from database
             func getCATEducation(){
                 let realm = try! Realm()
                   let allDataEducation = realm.objects(Transaction.self).filter("type = \"Expenses\" AND category = \"Education\"")
                            if allDataEducation.count>0{
                                
                               for dataEducation in allDataEducation{
                                    sumCATEducation += dataEducation.amount
                               }
                   }
               }
       //to get the sum of expenses for Electronic category from database
       func getCATElectronic(){
           let realm = try! Realm()
             let allDataElectronic = realm.objects(Transaction.self).filter("type = \"Expenses\" AND category = \"Electronic\"")
                      if allDataElectronic.count>0{
                          
                         for dataElectronic in allDataElectronic{
                              sumCATElectronic += dataElectronic.amount
                         }
             }
         }
       //to get the sum of expenses for Holidays category from database
          func getCATHolidays(){
              let realm = try! Realm()
                let allDataHolidays = realm.objects(Transaction.self).filter("type = \"Expenses\" AND category = \"Holidays\"")
                         if allDataHolidays.count>0{
                             
                            for dataHoliday in allDataHolidays{
                                 sumCATHolidays += dataHoliday.amount
                            }
                }
            }
       //to get the sum of expenses for Others category from database
             func getCATOthers(){
                 let realm = try! Realm()
                   let allDataOthers = realm.objects(Transaction.self).filter("type = \"Expenses\" AND category = \"Others\"")
                            if allDataOthers.count>0{
                               for dataOthers in allDataOthers{
                                    sumCATOthers += dataOthers.amount
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
                    self.view.setNeedsLayout()
                       let realm = try! Realm()
                       let allData = realm.objects(Transaction.self)
                            
                           let dateFormatter = DateFormatter()
                           dateFormatter.dateFormat = "dd/MM/yyyy"

                           let dateString =  dateFormatter.string(from: fromDateData)
                           let dateString2 = dateFormatter.string(from: toDateData)
                    
                    let dateFromString1 = dateFormatter.date(from: dateString)
                          let dateFromString2 = dateFormatter.date(from: dateString2)
                      
                    let selectedMonth = allData.filter("date BETWEEN %@", [dateFromString1, dateFromString2])
                               for selectedData in selectedMonth{
                               
                                   print("this is data2:" + selectedData.type, selectedData.amount)
  
                    }
                   }
        }

    }
