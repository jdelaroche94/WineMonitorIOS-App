//
//  homeViewController.swift
//  IOTApp-Assignment2
//
//  Created by Julian A De La Roche on 29/9/19.
//  Copyright © 2019 Julian A De La Roche. All rights reserved.
//

import UIKit


class homeViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, DatabaseListener {
    
    
        
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
    //let nightLightMaximum: Int = 1000
    //let dayLightMinimum: Int = 1001
    //var picture: UIImage?
    //var temperatureString: String?
    let ACTIVITY_CELL = "activityCell"
    var whetherRecList: [Whether_Recommendation] = []
    
    weak var databaseController: DatabaseProtocol?
    weak var userDefaultController: UserDefaultsProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        userDefaultController = appDelegate.userDefaultController
        //temperatureOutlet.isHidden = true
        // Do any additional setup after loading the view.
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
    func onTemperatureChange(change: DatabaseChange, temperatures: [Temperature]) {
        temps = temperatures
        
    }
    
    func onRGBChange(change: DatabaseChange, rgbs: [RGB]) {
        self.rgbs = rgbs
        whetherRecommendations()
    }
    
    func onWhetherRecChange(change: DatabaseChange, whetherRecs: [Whether_Recommendation]) {
        self.whetherRecs = whetherRecs
        whetherRecommendations()
        
    }
    
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
        //print("This is temp outlet text: " + temperatureOutlet.text!)
        //temperatureOutlet.isHidden = false
        //pictureOutlet.isHidden = true
    }
    
    
    func whetherRecommendations(){
        let numberOfRegs: Int = temps.count
        let user = userDefaultController?.retrieveUserId()
        if numberOfRegs != 0 {
            let numberOfRGBs: Int = rgbs.count
            let temporalTemp: Int = temps[numberOfRegs - 1].tempDegrees
            if numberOfRGBs != 0 {
                let tempRed: Int = rgbs[numberOfRGBs - 1].red
                let tempGreen: Int = rgbs[numberOfRGBs - 1].green
                let tempBlue: Int = rgbs[numberOfRGBs - 1].blue
                print("Temp: \(temporalTemp) and Light: \(tempRed)")
                //if tempRed != red || tempGreen != green || tempBlue != blue{
                    red = tempRed
                    green = tempGreen
                    blue = tempBlue
                    temperature = temporalTemp
                    changeImageOnScreen(temperature: temporalTemp, rgb: tempRed)
                    whetherRecList = []
                    for whetherRec in whetherRecs {
                        if temporalTemp >= whetherRec.temperature_min && temporalTemp <= whetherRec.temperature_max {
                            if red >= (whetherRec.light_min - 100) && red <= (whetherRec.light_max + 100) {
                                if whetherRec.user == "sudoActivities9873" {
                                    whetherRecList.append(whetherRec)
                                }
                                else if whetherRec.user == user {
                                    whetherRecList.append(whetherRec)
                                }
                                print(whetherRec.activity)
                                
                                /*
                                let temperatureString: String = String(temperature) + "ºC"
                                var picture: UIImage?
                                if red <= 1000 {
                                    picture = UIImage(named: "night.jpg")
                                    temperatureOutlet.textColor = UIColor.white
                                }
                                else if red >= 1001 {
                                    picture = UIImage(named: "day.jpg")
                                    temperatureOutlet.textColor = UIColor.black
                                    print("Aqui estoy 2")
                                }
                                pictureOutlet.image = picture
                                temperatureOutlet.text = temperatureString */
                                //temperatureOutlet.isHidden = false
                                    //pictureOutlet.
                            }
                        }
                    }
                    activityTableView.reloadData()
                //}
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
