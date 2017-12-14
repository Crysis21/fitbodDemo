//
//  WorkoutCell.swift
//  fitbodDemo
//
//  Created by Cristian Holdunu on 13/12/2017.
//  Copyright © 2017 Hold1. All rights reserved.
//

import UIKit

class WorkoutCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var maxWeight: UILabel!
    
    var workout: Workout? {
        didSet {
            self.name.text = workout?.name
            self.maxWeight.text = "\(workout?.workoutOneRepMax ?? 0)"
        }
    }
}
