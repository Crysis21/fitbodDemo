//
//  Workout.swift
//  fitbodDemo
//
//  Created by Cristian Holdunu on 13/12/2017.
//  Copyright © 2017 Hold1. All rights reserved.
//

import Foundation

class Workout {
    var name: String?
    var data: [WorkoutData]?
    
    init(name: String, data: [WorkoutData]) {
        self.name=name
        self.data=data.sorted {
            return $0.date < $1.date
        }
    }
    
    init() {
        
    }
    
    var workoutOneRepMax: Int {
        get {
            return Int((data?.last?.averageOneMaxRep)!) / 5 * 5 
        }
    }
}

