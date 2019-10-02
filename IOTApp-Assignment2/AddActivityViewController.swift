//
//  AddActivityViewController.swift
//  IOTApp-Assignment2
//
//  Created by Julian A De La Roche on 2/10/19.
//  Copyright © 2019 Julian A De La Roche. All rights reserved.
//

import UIKit

class AddActivityViewController: UIViewController {

        @IBOutlet weak var activityNameField: UITextField!
        @IBOutlet weak var activityPersonalisedMessageField: UITextField!
        @IBOutlet weak var temperatureSegment: UISegmentedControl!
        @IBOutlet weak var lightConditionSegment: UISegmentedControl!
      
        @IBOutlet weak var addActivityButton: UIButton!
        
        weak var addActivityDelegate: AddActivityDelegate?
        
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
        
        let cloudyLightMin = 0
        let cloudyLightMax = 1000
        
        let clearLightMin = 1001
        let cleatLightMax = 5000
        
        let sunnyLightMin  = 5001
        let sunnyLightMax = 70000

        override func viewDidLoad() {
            super.viewDidLoad()
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            userDefaultController = appDelegate.userDefaultController

             temperatureSegment.selectedSegmentIndex = UISegmentedControl.noSegment
             lightConditionSegment.selectedSegmentIndex = UISegmentedControl.noSegment
            
            if let val = checkDetailsPage {
                makePageReadOnly()
            }
        }
        
        func makePageReadOnly() {
            if let name = detailActivity?.activity {
                activityNameField.text = name
                activityNameField.isUserInteractionEnabled = false
            }
            
            //TODO add content in message
            activityPersonalisedMessageField.isUserInteractionEnabled = false
            
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
                temperatureSegment.isUserInteractionEnabled = false
                
            }
            
            if let minLight = detailActivity?.light_min {
                
                switch minLight {
                case cloudyLightMin:
                    lightConditionSegment.selectedSegmentIndex = 0
                case clearLightMin:
                    lightConditionSegment.selectedSegmentIndex = 1
                default:
                    lightConditionSegment.selectedSegmentIndex = 2
                }
                
                lightConditionSegment.isUserInteractionEnabled = false
            }
            
            addActivityButton.isHidden = true
        }
        

        @IBAction func addActivityButton(_ sender: Any) {
            if validateAllFields() {
                
                //TODO - variable bellow cannot be added to current class of whether_recommendation
                let personalisedMessage = activityPersonalisedMessageField.text
                
                // TODO - Call to add this activity to firebase
                
                // TODO - add the activity to current activities
                let activity = createObjectWhetherRecomendation()
                print (activity.activity)
                addActivityDelegate!.addActivityToList(newActivity: activity)
                _ = navigationController?.popViewController(animated: true)
                
            }
        }
        
        func createObjectWhetherRecomendation() -> Whether_Recommendation {
            let activity = Whether_Recommendation()
            activity.activity = activityNameField.text!
            activity.category = "Personalised"
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
                activity.light_min = cloudyLightMin
                activity.light_max = cloudyLightMax
            case 1:
                activity.light_min = clearLightMin
                activity.light_max = cleatLightMax
            default:
                activity.light_min = sunnyLightMin
                activity.light_max = sunnyLightMax
            }
            
            activity.id = (userDefaultController?.retrieveUserId())!
            
            return activity
        }
        
        func showError(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        func validateAllFields() -> Bool {
            if (activityNameField.text?.isEmpty)! {
                showError(title: "Empty Activity Name", message: "Please complete the field")
                return false
            }else if (activityPersonalisedMessageField.text?.isEmpty)! {
                showError(title: "Empty Activity Message", message: "Please complete the field")
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
