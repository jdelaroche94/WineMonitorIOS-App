//
//  DetailsViewController.swift
//  IOTApp-Assignment2
//
//  Created by Julian A De La Roche on 2/10/19.
//  Copyright © 2019 Julian A De La Roche. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    weak var userDefaultController: UserDefaultsProtocol?
    
    @IBOutlet var userNameField: UITextField!
    @IBOutlet var userAgeField: UITextField!
    @IBOutlet var userWeightField: UITextField!
    @IBOutlet var genderSegmentController: UISegmentedControl!
    /*
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userAgeField: UITextField!
    @IBOutlet weak var userWeightField: UITextField!
    @IBOutlet weak var genderSegmentController: UISegmentedControl!
    */
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
        
    }
    
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
            //_ = navigationController?.popViewController(animated: true)
        }
    }
    
    func validateAllFields() -> Bool {
        if (userNameField.text?.isEmpty)! {
            showToast(message: "Invalid Name. Please complete the field")
            return false
        }else if !validNumInRange(min: 10, max: 150, value: userAgeField.text!) {
            showToast(message: "Invalid Age. Please complete the field")
            return false
        }else if !validNumInRange(min: 30, max: 250, value: userWeightField.text!) {
            showToast(message: "Invalid Weight. Please complete the field")
            return false
        }else if genderSegmentController.selectedSegmentIndex == UISegmentedControl.noSegment {
            showToast(message: "Select Gender")
            return false
        }
        return true
    }
    
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
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    //    func assignName(name: String) {
//        defaults.set(name, forKey: "userNameKey")
//    }
//
//    func assignGender(gender: String) {
//        defaults.set(gender, forKey: "userGenderKey")
//    }
//
//    func assignWeight(weight: Int) {
//        defaults.set(weight, forKey: "userWeightKey")
//    }
//
//    func retrieveName() -> String {
//        var name: String = ""
//        if let tempName = defaults.string(forKey: "userNameKey") {
//
//            name = tempName
//        }
//        return name
//    }
//
//    func retrieveGender() -> String {
//        var gender: String = ""
//        if let tempgender = defaults.string(forKey: "userGenderKey") {
//            print(gender)
//            gender = tempgender
//        }
//        return gender
//    }
//
//    func retrieveWeight() -> Int {
//        return defaults.integer(forKey: "userWeightKey")
//
//    }
//
//
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
