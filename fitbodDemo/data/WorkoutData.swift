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
    var entries = [WorkoutSet]()
    
    init(id: Int, date: Date, name: String) {
        self.id = id
        self.date = date
        self.name = name
    }
    
    func addWorkout(data: WorkoutSet) {
        self.entries.append(data)
    }
    
    var averageOneMaxRep: Double? {
        get {
            return entries.reduce(0.0, {result, data in
                return result + data.oneMaxRep!
            }) / Double(entries.count)
        }
    }
    
    var debugDescription: String {
        get {
            return "\(date) \(name) entries=\(entries.count)"
        }
    }
}

