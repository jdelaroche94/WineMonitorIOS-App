//
//  PersonaliseViewController.swift
//  IOTApp-Assignment2
//
//  Created by Julian A De La Roche on 2/10/19.
//  Copyright © 2019 Julian A De La Roche. All rights reserved.
//

import UIKit

class PersonaliseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddActivityDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let SECTION_ACTIVITY = 0;
    let SECTION_COUNT = 1;
    let CELL_COUNT = "CellCounter"
    let CELL_ACTIVITY = "Cell"
    
    var personalisedRecommendations: [Whether_Recommendation] = []
    
    var checkDetailsPage = false
    var selectedRow = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == SECTION_ACTIVITY {
            return (personalisedRecommendations.count)
        }
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle:
        UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == SECTION_ACTIVITY {
            self.personalisedRecommendations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            let indexPath = NSIndexPath(row: 0, section: SECTION_COUNT)
            tableView.reloadRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.top)
            // TODO - remove from the firebase
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        if section == SECTION_ACTIVITY{
            label.text = "Personal Activities"
            label.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        } else {
//            label.text = ""
//            label.backgroundColor = UIColor.gray
        }
        
        return label
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_ACTIVITY {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ACTIVITY, for: indexPath)
        cell.textLabel?.text = personalisedRecommendations[indexPath.row].activity
        //TODO - get details of the activity
        //cell.detailTextLabel?.text = personalisedRecommendations[indexPath.row].details
        return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_COUNT, for: indexPath)
        cell.textLabel?.text = "\(personalisedRecommendations.count) Personalised Activities in the list"
        cell.selectionStyle = .none
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        personalisedRecommendations = [Whether_Recommendation]()
//        let pr = Whether_Recommendation()
//        pr.activity = "Fun"
//        personalisedRecommendations.append(pr)
    }
    
    func addActivityToList(newActivity: Whether_Recommendation) -> Bool {
        personalisedRecommendations.append(newActivity)
        
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: personalisedRecommendations.count - 1, section: SECTION_ACTIVITY)], with: .automatic)
        //tableView.insertRows(at: [IndexPath(row: 0, section: SECTION_COUNT)], with: .automatic)
        let indexPath = NSIndexPath(row: 0, section: SECTION_COUNT)
        tableView.reloadRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.top)
        tableView.endUpdates()
        tableView.reloadSections([SECTION_ACTIVITY], with: .automatic)
        // TODO - Add this tofirebase
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SECTION_ACTIVITY{
            checkDetailsPage = true
            selectedRow = indexPath.row
            tableView.deselectRow(at: indexPath, animated: true)
            self.performSegue(withIdentifier: "personalisedActivitySegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
            let destination = segue.destination as! AddActivityViewController
            destination.addActivityDelegate = self
            if checkDetailsPage {
                checkDetailsPage = false
                destination.checkDetailsPage = true
                destination.detailActivity = personalisedRecommendations[selectedRow]
            }
        
       
    }
 
}
