//
//  WorkoutsTableViewController.swift
//  fitbodDemo
//
//  Created by Cristian Holdunu on 13/12/2017.
//  Copyright © 2017 Hold1. All rights reserved.
//

import UIKit

class WorkoutsTableViewController: UITableViewController {
    var workouts: [Workout]?
    var loadingView: UIActivityIndicatorView?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        self.tableView.backgroundView = loadingView
        loadingView?.startAnimating()
        DataManager.sharedInstance.loadWorkouts { (workouts) in
            self.workouts = workouts
            self.tableView.reloadData()
            self.loadingView?.stopAnimating()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
