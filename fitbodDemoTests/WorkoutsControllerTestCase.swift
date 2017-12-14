//
//  WorkoutsControllerTestCase.swift
//  fitbodDemoTests
//
//  Created by Cristian Holdunu on 15/12/2017.
//  Copyright © 2017 Hold1. All rights reserved.
//

import XCTest
import Foundation
import UIKit
@testable import fitbodDemo

class WorkoutsControllerTestCase: XCTestCase {
    
    var workoutController: WorkoutsViewController?
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let navController = storyboard.instantiateInitialViewController() as! UINavigationController
        workoutController = navController.viewControllers.first as? WorkoutsViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWorkoutRendering() {
        let _ = workoutController?.view
        XCTAssert(workoutController?.tableView != nil)
        let promise = expectation(description: "Workout Data Loaded")
        DataManager.sharedInstance.loadWorkoutData(file: "workoutData.txt")
        DataManager.sharedInstance.loadWorkouts(consumer: {workouts in
            XCTAssert(self.workoutController?.workouts != nil)
            let cell = self.workoutController?.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! WorkoutCell
            XCTAssert(cell.name.text == workouts?.first?.name)
            promise.fulfill()
        }, error: { er in
            
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testInvalidFile() {
        let _ = workoutController?.view
        XCTAssert(workoutController?.tableView != nil)
        let promise = expectation(description: "Workout Data Loaded")
        DataManager.sharedInstance.loadWorkoutData(file: "no_file")
        DataManager.sharedInstance.loadWorkouts(consumer: {workouts in
            
        }, error: {error in
            let tableView = (self.workoutController?.tableView)!
            let sections = (tableView.dataSource?.numberOfSections!(in: tableView))!
            var cellCount = 0
            for i in 0 ... sections {
                cellCount += (tableView.dataSource?.tableView(tableView, numberOfRowsInSection: sections))!
            }
            XCTAssert(cellCount == 0)
            promise.fulfill()
            
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
}
