//
//  ChartViewController.swift
//  fitbodDemo
//
//  Created by Cristian Holdunu on 14/12/2017.
//  Copyright © 2017 Hold1. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController {
    
    var workout: Workout? {
        didSet {
            print("workout set")
        }
    }
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var lineChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.text=workout?.name
        
        //render numbers chart
        var chartEntries = [ChartDataEntry] ()
        for i in 0 ..< (workout?.data?.count)! {
            let stat = workout?.data?[i]
            chartEntries.append(ChartDataEntry(x: Double(i), y: (stat?.averageOneMaxRep)!))
        }
        let dataSet = LineChartDataSet(values: chartEntries, label: "numbers")
        let lineData = LineChartData(dataSet: dataSet)
        lineChartView.data = lineData
        
    }
    
//    func setChart(dataPoints: [String], values: [Double]) {
//
//        var dataEntries: [ChartDataEntry] = []
//
//        for i in 0..<dataPoints.count {
//            let dataEntry = ChartDataEntry(x: values[i], y: Double(i))
//            dataEntries.append(dataEntry)
//        }
//
//
//        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Units Sold")
//        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
//        lineChartView.data = lineChartData
//
//    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
