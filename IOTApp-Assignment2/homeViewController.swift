//
//  homeViewController.swift
//  IOTApp-Assignment2
//
//  Created by Julian A De La Roche on 29/9/19.
//  Copyright © 2019 Julian A De La Roche. All rights reserved.
//

import UIKit


class homeViewController: UIViewController, DatabaseListener {
        
    
    @IBOutlet var buttonOutlet: UIButton!
    @IBAction func buttonAction(_ sender: Any) {
        print(temps)
    }
    
    var temps: [Temperature] = []
    var rgbs: [RGB] = []
    var whetherRecs: [Whether_Recommendation] = []
    weak var databaseController: DatabaseProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
       
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
    }
    
    func onWhetherRecChange(change: DatabaseChange, whetherRecs: [Whether_Recommendation]) {
        self.whetherRecs = whetherRecs
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
