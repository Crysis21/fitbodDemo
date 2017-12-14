//
//  WorkoutsTableViewController.swift
//  fitbodDemo
//
//  Created by Cristian Holdunu on 13/12/2017.
//  Copyright © 2017 Hold1. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class WorkoutsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var workouts: [Workout]?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        activityIndicator.startAnimating()
        DataManager.sharedInstance.loadWorkouts { (workouts) in
            self.workouts = workouts
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts?.count ?? 0
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let workout = workouts![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath) as! WorkoutCell
        cell.workout = workout
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ChartViewController, let cell = sender as? WorkoutCell {
            vc.workout = cell.workout
        }
    }
}
