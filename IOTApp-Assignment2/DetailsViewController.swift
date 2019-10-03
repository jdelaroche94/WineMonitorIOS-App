//
//  DetailsViewController.swift
//  IOTApp-Assignment2
//
//  Created by Julian A De La Roche on 2/10/19.
//  Copyright © 2019 Julian A De La Roche. All rights reserved.
//

import UIKit

//This class allows users to add your personal details such as name , age, weight, gender
class DetailsViewController: UIViewController {
    
    weak var userDefaultController: UserDefaultsProtocol?
    
    @IBOutlet var userNameField: UITextField!
    @IBOutlet var userAgeField: UITextField!
    @IBOutlet var userWeightField: UITextField!
    @IBOutlet var genderSegmentController: UISegmentedControl!
  
    override func viewDidLoad() {
        super.viewDidLoad()
     
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        userDefaultController = appDelegate.userDefaultController
        
        // start reading the userDefaults
        userNameField.text = userDefaultController?.retrieveName()
        let age = userDefaultController?.retrieveAge()
        if  age != 0 {
            userAgeField.text = String(age!)
        }
        let weight = userDefaultController?.retrieveWeight()
        if  weight != 0 {
            userWeightField.text = String(weight!)
        }
        let gender = userDefaultController?.retrieveGender()
        if gender?.caseInsensitiveCompare("Female") == .orderedSame {
            genderSegmentController.selectedSegmentIndex = 1
        } else if gender?.caseInsensitiveCompare("Other") == .orderedSame {
            genderSegmentController.selectedSegmentIndex = 2
        } else if gender?.caseInsensitiveCompare("Male") == .orderedSame {
            genderSegmentController.selectedSegmentIndex = 0
        } else {
            genderSegmentController.selectedSegmentIndex = UISegmentedControl.noSegment
        }
        self.hideKeyboardWhenTappedAround()
    }
    
    // This method saves the user details in the userDefaults
    @IBAction func confirmDetailsButton(_ sender: Any) {
        if validateAllFields() {
            userDefaultController?.assignName(name: userNameField.text!)
            userDefaultController?.assignAge(age: getInt(userAgeField.text!))
            userDefaultController?.assignWeight(weight: getInt(userWeightField.text!))
            
            switch genderSegmentController.selectedSegmentIndex {
            case 0:
                 userDefaultController?.assignGender(gender: "Male")
            case 1:
                userDefaultController?.assignGender(gender: "Female")
            default:
                userDefaultController?.assignGender(gender: "Other")
            }
            
            showMessage(tittle: "Details changed succesfully", message: "Details changed succesfully")
        }
    }
    
    //This method validates the values in the user fields
    func validateAllFields() -> Bool {
        if (userNameField.text?.isEmpty)! {
            showMessage(tittle: "Information required", message: "Invalid Name. Please complete the field")
            return false
        }else if !validNumInRange(min: 10, max: 150, value: userAgeField.text!) {
            showMessage(tittle: "Information required", message: "Invalid Age. Please complete the field")
            return false
        }else if !validNumInRange(min: 30, max: 250, value: userWeightField.text!) {
            showMessage(tittle: "Information required", message: "Invalid Weight. Please complete the field")
            return false
        }else if genderSegmentController.selectedSegmentIndex == UISegmentedControl.noSegment {
            showMessage(tittle: "Information required", message: "Select Gender")
            return false
        }
        return true
    }
    
    //This method checks the value if it's in the given range
    func validNumInRange(min: Int, max: Int, value: String) -> Bool {
        let num = getInt(value)
        
        if num>min && num<max {
            return true
        }
        return false
    }
    
    func getInt(_ data:String) -> Int
    {
        return Int(data) ?? -1
    }
    
    //This method shows a pop up informing changes in the information
    func showMessage(tittle: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
