//
//  homeViewController.swift
//  IOTApp-Assignment2
//
//  Created by Julian A De La Roche on 29/9/19.
//  Copyright © 2019 Julian A De La Roche. All rights reserved.
//

import UIKit


class homeViewController: UIViewController, DatabaseListener {
        
    @IBOutlet var pictureOutlet: UIImageView!
    @IBOutlet var temperatureOutlet: UILabel!
    
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
    let nightLightMaximum: Int = 1000
    let dayLightMinimum: Int = 1001
    
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
    
    func whetherRecommendations(){
        let numberOfRegs: Int = temps.count
        if numberOfRegs != 0 {
            let numberOfRGBs: Int = rgbs.count
            let temporalTemp: Int = temps[numberOfRegs - 1].tempDegrees
            if numberOfRGBs != 0{
                temperature = temporalTemp
                let tempRed: Int = rgbs[numberOfRGBs - 1].red
                let tempGreen: Int = rgbs[numberOfRGBs - 1].green
                let tempBlue: Int = rgbs[numberOfRGBs - 1].blue
                print("Temp: \(temporalTemp) and Light: \(tempRed)")
                if tempRed != red || tempGreen != green || tempBlue != blue{
                    red = tempRed
                    green = tempGreen
                    blue = tempBlue
                    for whetherRec in whetherRecs {
                        //if temperature >= whetherRec.temperature_min && temperature <= whetherRec.temperature_max {
                            if red >= (whetherRec.light_min - 100) && red <= (whetherRec.light_max + 100) {
                                print(whetherRec.activity)
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
                                temperatureOutlet.text = temperatureString
                                //temperatureOutlet.isHidden = false
                                    //pictureOutlet.
                            }
                        //}
                    }
                }
            }
        }
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
