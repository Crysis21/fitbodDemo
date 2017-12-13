//
//  AppDelegate.swift
//  fitbodDemo
//
//  Created by Cristian Holdunu on 13/12/2017.
//  Copyright © 2017 Hold1. All rights reserved.
//

import Foundation

class DataManager {
    static let sharedInstance: DataManager = DataManager()
    
    public var workouts = [Workout]()
    private var workoutHistory = [WorkoutData]()
    private var dateFormatter = DateFormatter()
    
    private init() {
        //load workout data from assets
        dateFormatter.dateFormat = "MMM DD YYYY"
    }
    
    public func loadWorkouts(onLoad:@escaping (([Workout])->Void)) {
        DispatchQueue.global().async {
            self.loadWorkoutData(onLoadComplete: {
                DispatchQueue.main.async(execute: {
                    onLoad(self.workouts)
                })
            })
        }
    }
    
    public func loadWorkoutData(onLoadComplete: () -> Void) {
        if let path = Bundle.main.path(forResource: "workoutData", ofType: "txt") {
            let fileManager = FileManager()
            if fileManager.fileExists(atPath: path) {
                do {
                    let lines = try String(contentsOfFile: path).split(separator: "\n")
                    var currentWorkout: WorkoutData?
                    lines.forEach({ line in
                        if let workoutSet = parseWorkoutSet(textData: String(line)) {
                            print("workout PR = \(workoutSet.oneMaxRep ?? 0) setId=\(workoutSet.workoutId)")
                            if currentWorkout?.id == workoutSet.workoutId {
                                currentWorkout?.addWorkout(data: workoutSet)
                            } else {
                                currentWorkout = WorkoutData(id: workoutSet.workoutId, date: workoutSet.date, name: workoutSet.name)
                                workoutHistory.append(currentWorkout!)
                                currentWorkout?.addWorkout(data: workoutSet)
                            }
                        }
                    })
                    
                    print("created \(workoutHistory.count) sets")
                    
                    workoutHistory.forEach({workout in
                        print(workout.debugDescription)
                    })
                    
                    workouts = Dictionary(grouping: workoutHistory, by: {(element: WorkoutData) in
                        return element.name
                    }).map({(key, value) in
                        return Workout(name: key, data: value)
                    })
                    
                    print("created \(workouts.count) workouts")
                    onLoadComplete()
                } catch  {
                    
                }
            } else {
                print("WorkoutData asset missing")
            }
        }
        
    }
    
    fileprivate func parseWorkoutSet(textData: String) -> WorkoutSet? {
        let data = textData.split(separator: ",")
        guard data.count == 5 else {
            print("workout entry incomplete or not parseable")
            return nil
        }
        let setId = String(data[0]+data[1]).hashValue
        let date = dateFormatter.date(from: String(data[0]))
        let name = String(data[1])
        let sets = Int(data[2])
        let reps = Int(data[3])
        let weight = Int(data[4])
        
        guard date != nil else {
            return nil
        }
        
        return WorkoutSet(setId: setId, date: date!, name: name, sets: sets!, reps: reps!, weight: weight!)
    }
    
}

