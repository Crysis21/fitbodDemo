//
//  WorkoutSet.swift
//  fitbodDemo
//
//  Created by Cristian Holdunu on 13/12/2017.
//  Copyright © 2017 Hold1. All rights reserved.
//

import Foundation

public class WorkoutData {
    var id: Int
    var date: Date
    var name: String
    var enties = [WorkoutSet]()
    
    init(id: Int, date: Date, name: String) {
        self.id = id
        self.date = date
        self.name = name
    }
    
    func addWorkout(data: WorkoutSet) {
        self.enties.append(data)
    }
    
    var averageOneMaxRep: Double? {
        get {
            return enties.reduce(0.0, {result, data in
                return result + data.oneMaxRep!
            }) / Double(enties.count)
        }
    }
    
    var debugDescription: String {
        get {
            return "\(date) \(name) entries=\(enties.count)"
        }
    }
}

