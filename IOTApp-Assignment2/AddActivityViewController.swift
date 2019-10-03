//
//  AddActivityViewController.swift
//  IOTApp-Assignment2
//
//  Created by Julian A De La Roche on 2/10/19.
//  Copyright © 2019 Julian A De La Roche. All rights reserved.
//

import UIKit

//This view controller will be used by user to add new activities in the database
class AddActivityViewController: UIViewController {

     // outlets for the text fields and segment controller
    @IBOutlet weak var categoryNameField: UITextField!
    @IBOutlet weak var activityNameField: UITextField!
    @IBOutlet weak var temperatureSegment: UISegmentedControl!
    @IBOutlet weak var lightConditionSegment: UISegmentedControl!
      
    //button for adding the activity or updating existing one
    @IBOutlet weak var addActivityButton: UIButton!
        
    weak var addActivityDelegate: AddActivityDelegate?
    weak var databaseController: DatabaseProtocol?
        
    //IMPORTANT - this variable used to identify if the new activity is being added or it is being updated. If true, means the activity is being updated, not being added
    var checkDetailsPage: Bool?
    var detailActivity: Whether_Recommendation?

    //Used to get the unique userId from the userDefaults
    weak var userDefaultController: UserDefaultsProtocol?
        
    // All the constant values are used to set the temperature and light condition for the activity
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
            
        //checks if the page is being updated. If true then calls the method that'll populate the fields and change the button title
        if checkDetailsPage == true  {
            makePageReadOnly()
        }
        self.hideKeyboardWhenTappedAround()
    }
        
    //the method populates the fields and change the button title
    func makePageReadOnly() {
        if let categoryName = detailActivity?.category {
            categoryNameField.text = categoryName
        }
        if let activityName = detailActivity?.activity {
            activityNameField.text = activityName
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
        //change the title of the button
        addActivityButton.setTitle("Update Activity", for: .normal)
    }
    //This method adds the new activity or update the existing one
    @IBAction func addActivityButton(_ sender: Any) {
        if validateAllFields() {
            let activity = createObjectWhetherRecomendation()
            activity.user = (userDefaultController?.retrieveUserId())!
            if let val = checkDetailsPage{
                if detailActivity != nil {
                    activity.id = detailActivity!.id
                    databaseController!.updateActivity(whether_recommentation: activity)
                }
            }else{
                let _ = databaseController!.addPersonalisedActivity(whether_recommentation: activity)
            }
            _ = navigationController?.popViewController(animated: true)
        }
    }
        
    //This method creates the object of Whether_Recommendation from the info provided by the user
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
        return activity
    }
    
    //This method displays and error when some information is missing on the screen
    func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
        
    //This validates the values for all the fields. For inaccurate error it shows the error message
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

// Hides the keyboard
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
