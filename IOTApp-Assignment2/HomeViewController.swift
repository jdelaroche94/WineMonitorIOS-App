//
//  homeViewController.swift
//  IOTApp-Assignment2
//
//  Created by Julian A De La Roche on 29/9/19.
//  Copyright © 2019 Julian A De La Roche. All rights reserved.
//

import UIKit

//This class allows to show a picture and temperature using sensor readings and shows the activities recommended to users according to this.
class HomeViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, DatabaseListener {
    
    @IBOutlet var pictureOutlet: UIImageView!
    @IBOutlet var activityTableView: UITableView!
    @IBOutlet var temperatureOutlet: UILabel!
    
    var temps: [Temperature] = []
    var rgbs: [RGB] = []
    var whetherRecs: [Whether_Recommendation] = []
    var temperature: Int = -24
    var red: Int = 0
    var green: Int = 0
    var blue: Int = 0
    let ACTIVITY_CELL = "activityCell"
    var whetherRecList: [Whether_Recommendation] = []
    
    weak var databaseController: DatabaseProtocol?
    weak var userDefaultController: UserDefaultsProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        userDefaultController = appDelegate.userDefaultController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    
    var listenerType: ListenerType = ListenerType.all
    //This method activates the listeners of Temperature when it changes.
    func onTemperatureChange(change: DatabaseChange, temperatures: [Temperature]) {
        temps = temperatures
    }
    
    //This method activates the listeners of RGB when it changes.
    func onRGBChange(change: DatabaseChange, rgbs: [RGB]) {
        self.rgbs = rgbs
        whetherRecommendations()
    }
    
    //This method activates the listeners of Whether_recommendations when it changes.
    func onWhetherRecChange(change: DatabaseChange, whetherRecs: [Whether_Recommendation]) {
        self.whetherRecs = whetherRecs
        whetherRecommendations()
        
    }
    
    //This method adjust the image (Using RGB parameters) and the label temperature (Using Temperature) with the last values receiving from Firebase.
    func changeImageOnScreen(temperature: Int, rgb: Int){
        var picture: UIImage?
        let temperatureString: String? = String(temperature) + "ºC"
        if red <= 1000 { //Dark
            picture = UIImage(named: "night.jpg")
            temperatureOutlet.textColor = UIColor.white
        }
        else if red >= 1001 && red < 8000 { // Cloudy
            picture = UIImage(named: "sunset.jpg") 
            temperatureOutlet.textColor = UIColor.white
        }
        else if red >= 8001 { //Sunny
            picture = UIImage(named: "day.jpg")
            temperatureOutlet.textColor = UIColor.black
        }
        pictureOutlet.image = picture
        temperatureOutlet.text = temperatureString
    }
    
    //This method shows activities or recommendations which accomplishes with Temperature and RGB parameters red from Firebase. It will show all the recommendations created by default (They are not allowed to remove these) and the personal activities or recommendations (These can be updated or removed from users)
    func whetherRecommendations(){
        let numberOfRegs: Int = temps.count
        let user = userDefaultController?.retrieveUserId()
        if numberOfRegs != 0 {
            let numberOfRGBs: Int = rgbs.count
            temperature = temps[numberOfRegs - 1].tempDegrees
            if numberOfRGBs != 0 {
                red = rgbs[numberOfRGBs - 1].red
                green = rgbs[numberOfRGBs - 1].green
                blue = rgbs[numberOfRGBs - 1].blue
                changeImageOnScreen(temperature: temperature, rgb: red)
                whetherRecList = []
                for whetherRec in whetherRecs {
                    if temperature >= whetherRec.temperature_min && temperature <= whetherRec.temperature_max {
                        if red >= (whetherRec.light_min - 100) && red <= (whetherRec.light_max + 100) {
                            if whetherRec.user == "sudoActivities9873" {
                                whetherRecList.append(whetherRec)
                            }
                            else if whetherRec.user == user {
                                whetherRecList.append(whetherRec)
                            }
                        }
                    }
                }
                activityTableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return whetherRecList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activityCell = tableView.dequeueReusableCell(withIdentifier: ACTIVITY_CELL, for: indexPath) as! ActivityTableViewCell
        let activity = whetherRecList[indexPath.row]
        activityCell.activityLabel.text = activity.activity
        activityCell.categoryLabel.text = activity.category
        return activityCell
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
