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
    
    public var workouts: [Workout]?
    private var workoutsSubject: Subject<[Workout]>
    public var workoutHistory = [WorkoutData]()
    private var dateFormatter = DateFormatter()
    
    private init() {
        dateFormatter.dateFormat = "MMM d yyyy"
        workoutsSubject = Subject()
    }
    
    public func loadWorkouts(consumer: @escaping ([Workout]) -> Void, error: @escaping (Error)->Void) -> Disposable<[Workout]> {
        return workoutsSubject.subscribe(consumer, error)
    }
    
    public func loadWorkoutData(file: String) {
        DispatchQueue.global().async {
            let name = file.contains(".") ? String(file.split(separator: ".").first!) : file
            let type = file.contains(".") ? String(file.split(separator: ".").last!) : ""
            self.loadWorkoutDataFromFile(fileName: name, fileType: type)
        }
    }
    
    private func loadWorkoutDataFromFile(fileName: String, fileType: String) {
        self.workouts = nil
        self.workoutHistory.removeAll()
        if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
            let fileManager = FileManager()
            if fileManager.fileExists(atPath: path) {
                do {
                    let lines = try String(contentsOfFile: path).split(separator: "\n")
                    var currentWorkout: WorkoutData?
                    lines.forEach({ line in
                        if let workoutSet = parseWorkoutSet(textData: String(line)) {
                            if currentWorkout?.id == workoutSet.workoutId {
                                currentWorkout?.addWorkout(data: workoutSet)
                            } else {
                                currentWorkout = WorkoutData(id: workoutSet.workoutId, date: workoutSet.date, name: workoutSet.name)
                                workoutHistory.append(currentWorkout!)
                                currentWorkout?.addWorkout(data: workoutSet)
                            }
                        }
                    })
                    print("created \(workoutHistory.count) workouts data")
                    
                    
                    workouts = Dictionary(grouping: workoutHistory, by: {(element: WorkoutData) in
                        return element.name
                    }).map({(key, value) in
                        return Workout(name: key, data: value)
                    })
                    workoutsSubject.publish(workouts!)
                    print("created \(workouts?.count ?? 0) workouts")
                    
                } catch  {
                    workoutsSubject.error(DataError("Error while reading data"))
                }
            } else {
                workoutsSubject.error((DataError("Workout asset missing")))
                print("WorkoutData asset missing")
            }
        } else {
            workoutsSubject.error(DataError("Workout asset missing"))
            print("WorkoutData asset missing")
        }
    }
    
    public func parseWorkoutSet(textData: String) -> WorkoutSet? {
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
    
    class DataError: Error {
        var message: String
        init(_ message : String) {
            self.message = message
        }
    }
}

