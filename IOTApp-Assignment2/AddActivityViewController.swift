//
//  AddActivityViewController.swift
//  IOTApp-Assignment2
//
//  Created by Julian A De La Roche on 2/10/19.
//  Copyright © 2019 Julian A De La Roche. All rights reserved.
//

import UIKit

class AddActivityViewController: UIViewController {

        @IBOutlet weak var categoryNameField: UITextField!
        @IBOutlet weak var activityNameField: UITextField!
        @IBOutlet weak var temperatureSegment: UISegmentedControl!
        @IBOutlet weak var lightConditionSegment: UISegmentedControl!
      
        @IBOutlet weak var addActivityButton: UIButton!
        
        weak var addActivityDelegate: AddActivityDelegate?
        weak var databaseController: DatabaseProtocol?
        
        var checkDetailsPage: Bool?
        var detailActivity: Whether_Recommendation?

        weak var userDefaultController: UserDefaultsProtocol?
        
        let chillyMinTemp = 0
        let chillyMaxTemp = 8
        
        let coolMinTemp = 9
        let coolMaxTemp = 18
        
        let warmMinTemp = 19
        let warmMaxTemp = 24
        
        let hotMinTemp = 25
        let hotMaxTemp = 100
        
        let darkLightMin = 0
        let darkLightMax = 1000
        
        let cloudyLightMin = 1001
        let cloudyLightMax = 8000
        
        let sunnyLightMin  = 8001
        let sunnyLightMax = 70000

        override func viewDidLoad() {
            super.viewDidLoad()
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            userDefaultController = appDelegate.userDefaultController
            databaseController = appDelegate.databaseController
            
            temperatureSegment.selectedSegmentIndex = UISegmentedControl.noSegment
            lightConditionSegment.selectedSegmentIndex = UISegmentedControl.noSegment
            
            if checkDetailsPage == true  {
                makePageReadOnly()
            }
            
            self.hideKeyboardWhenTappedAround()
        }
        
    func makePageReadOnly() {
        if let categoryName = detailActivity?.category {
            categoryNameField.text = categoryName
            //categoryNameField.isUserInteractionEnabled = false
        }
        
        if let activityName = detailActivity?.activity {
            activityNameField.text = activityName
            //activityNameField.isUserInteractionEnabled = false
        }
        
        //TODO add content in message
        //categoryNameField.isUserInteractionEnabled = false
        
        if let minTemp = detailActivity?.temperature_min {
            
            switch minTemp{
            case chillyMinTemp:
                temperatureSegment.selectedSegmentIndex = 0
            case coolMinTemp:
                temperatureSegment.selectedSegmentIndex = 1
            case warmMinTemp:
                temperatureSegment.selectedSegmentIndex = 2
            default:
                temperatureSegment.selectedSegmentIndex = 3
            }
          
        }
        
        if let minLight = detailActivity?.light_min {
            
            switch minLight {
            case darkLightMin:
                lightConditionSegment.selectedSegmentIndex = 0
            case darkLightMin:
                lightConditionSegment.selectedSegmentIndex = 1
            default:
                lightConditionSegment.selectedSegmentIndex = 2
            }
           
        }
        
        addActivityButton.setTitle("Update Activity", for: .normal)
    }

        @IBAction func addActivityButton(_ sender: Any) {
            if validateAllFields() {
               // TODO - Call to add this activity to firebase
                
                // TODO - add the activity to current activities
                let activity = createObjectWhetherRecomendation()
                activity.user = (userDefaultController?.retrieveUserId())!
                if checkDetailsPage! {
                    print("This is detail activity:" + (detailActivity?.id ?? "No encontre nada"))
                    if detailActivity != nil {
                        activity.id = detailActivity!.id
                        databaseController!.updateActivity(whether_recommentation: activity)
                        //databaseController?.deleteActitivy(whether_recommentation: detailActivity!)
                        //databaseController!.addPersonalisedActivity(whether_recommentation: activity)
                    }
                }else{
                    let _ = databaseController!.addPersonalisedActivity(whether_recommentation: activity)
                }
                //addActivityDelegate!.addActivityToList(newActivity: activity)
                
                _ = navigationController?.popViewController(animated: true)
                
            }
        }
        
        func createObjectWhetherRecomendation() -> Whether_Recommendation {
            let activity = Whether_Recommendation()
            activity.activity = activityNameField.text!
            activity.category = categoryNameField.text!
            switch temperatureSegment.selectedSegmentIndex {
            case 0:
                activity.temperature_min = chillyMinTemp
                activity.temperature_max = chillyMaxTemp
            case 1:
                activity.temperature_min = coolMinTemp
                activity.temperature_max = coolMaxTemp
            case 2:
                activity.temperature_min = warmMinTemp
                activity.temperature_max = warmMaxTemp
            default:
                activity.temperature_min = hotMinTemp
                activity.temperature_max = hotMaxTemp
            }
            
            switch lightConditionSegment.selectedSegmentIndex {
            case 0:
                activity.light_min = darkLightMin
                activity.light_max = darkLightMax
            case 1:
                activity.light_min = cloudyLightMin
                activity.light_max = cloudyLightMax
            default:
                activity.light_min = sunnyLightMin
                activity.light_max = sunnyLightMax
            }
            
            activity.user = (userDefaultController?.retrieveUserId())!
            print("This is the user:" + activity.user)
            return activity
        }
        
        func showError(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        func validateAllFields() -> Bool {
            if (categoryNameField.text?.isEmpty)! {
                showError(title: "Empty Category Name", message: "Please complete the field")
                return false
            }else if (activityNameField.text?.isEmpty)! {
                showError(title: "Empty Activity Name", message: "Please complete the field")
                return false
            }else if temperatureSegment.selectedSegmentIndex == UISegmentedControl.noSegment {
                showError(title: "Choose Temperature", message: "Please select proper option")
                return false
            }else if lightConditionSegment.selectedSegmentIndex == UISegmentedControl.noSegment {
                showError(title: "Choose Light Condition", message: "Please select proper option")
                return false
            }
            return true
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

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
