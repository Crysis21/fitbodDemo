//
//  WorkoutData.swift
//  fitbodDemo
//
//  Created by Cristian Holdunu on 13/12/2017.
//  Copyright © 2017 Hold1. All rights reserved.
//

import Foundation

class WorkoutSet {
    var workoutId: Int
    var date: Date
    var name: String
    var sets: Int
    var reps: Int
    var weight: Int
    
    init(setId: Int, date: Date, name: String, sets: Int, reps: Int, weight: Int) {
        self.workoutId = setId
        self.date = date
        self.name = name
        self.sets = sets
        self.reps = reps
        self.weight = weight
    }
    
    var oneMaxRep: Double? {
        get {
            return Double(weight) / (1.0278 - 0.0278 * Double(reps))
        }
    }
}

