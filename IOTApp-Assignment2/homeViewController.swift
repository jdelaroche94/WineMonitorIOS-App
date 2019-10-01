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
    @IBOutlet var temperatureOutlet: UILabel!
    
    @IBOutlet var activityTableView: UITableView!
    @IBOutlet var buttonOutlet: UIButton!
    @IBAction func buttonAction(_ sender: Any) {
        whetherRecommendations()
    }
    
    var temps: [Temperature] = []
    var rgbs: [RGB] = []
    var whetherRecs: [Whether_Recommendation] = []
    var temperature: Int = -24
    var red: Int = 0
    var green: Int = 0
    var blue: Int = 0
    //let nightLightMaximum: Int = 1000
    //let dayLightMinimum: Int = 1001
    let ACTIVITY_CELL = "activityCell"
    var whetherRecList: [Whether_Recommendation] = []
    
    weak var databaseController: DatabaseProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
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
        print("Aqui estoy")
    }
    
    func onWhetherRecChange(change: DatabaseChange, whetherRecs: [Whether_Recommendation]) {
        self.whetherRecs = whetherRecs
    }
    
    func changeImageOnScreen(temperature: Int, rgb: Int){
        let temperatureString: String = String(temperature) + "ºC"
        var picture: UIImage?
        if red <= 1000 {
            picture = UIImage(named: "night.jpg")
            temperatureOutlet.textColor = UIColor.white
        }
        else if red >= 1001 && red < 8000 {
            picture = UIImage(named: "sunset.jpg")
            temperatureOutlet.textColor = UIColor.white
        }
        else if red >= 8001 {
            picture = UIImage(named: "day.jpg")
            temperatureOutlet.textColor = UIColor.black
        }
        pictureOutlet.image = picture
        temperatureOutlet.text = temperatureString
    }
    
    
    func whetherRecommendations(){
        let numberOfRegs: Int = temps.count
        if numberOfRegs != 0 {
            let numberOfRGBs: Int = rgbs.count
            let temporalTemp: Int = temps[numberOfRegs - 1].tempDegrees
            if numberOfRGBs != 0 {
                let tempRed: Int = rgbs[numberOfRGBs - 1].red
                let tempGreen: Int = rgbs[numberOfRGBs - 1].green
                let tempBlue: Int = rgbs[numberOfRGBs - 1].blue
                print("Temp: \(temporalTemp) and Light: \(tempRed)")
                if tempRed != red || tempGreen != green || tempBlue != blue{
                    red = tempRed
                    green = tempGreen
                    blue = tempBlue
                    temperature = temporalTemp
                    changeImageOnScreen(temperature: temporalTemp, rgb: tempRed)
                    whetherRecList = []
                    for whetherRec in whetherRecs {
                        if temporalTemp >= whetherRec.temperature_min && temporalTemp <= whetherRec.temperature_max {
                            if red >= (whetherRec.light_min - 100) && red <= (whetherRec.light_max + 100) {
                                whetherRecList.append(whetherRec)
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
                }
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
