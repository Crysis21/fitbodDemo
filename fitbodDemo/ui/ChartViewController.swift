//
//  ChartViewController.swift
//  fitbodDemo
//
//  Created by Cristian Holdunu on 14/12/2017.
//  Copyright © 2017 Hold1. All rights reserved.
//

import UIKit
import Charts
import NVActivityIndicatorView

class ChartViewController: UIViewController {
    
    var workout: Workout?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var oneMaxRep: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.name.text = workout?.name
        self.oneMaxRep.text = "\(workout?.workoutOneRepMax ?? 0)"
        
        //MARK: prepare chartview UI
        chartView.dragEnabled = false
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.highlightPerDragEnabled = false
        chartView.scaleYEnabled = false
        chartView.scaleXEnabled = false
        
        //xAxis
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.drawLimitLinesBehindDataEnabled = false
        xAxis.avoidFirstLastClippingEnabled = false
        xAxis.granularity = 1.0
        xAxis.spaceMin = xAxis.granularity / 2
        xAxis.spaceMax = xAxis.granularity / 2
        
        let rightAxis = chartView.rightAxis
        rightAxis.labelPosition = .outsideChart
        rightAxis.labelTextColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        rightAxis.drawGridLinesEnabled = false
        rightAxis.granularityEnabled = false
        rightAxis.drawAxisLineEnabled=false
        rightAxis.axisMinimum = 0
        chartView.leftAxis.enabled = false
        chartView.chartDescription?.enabled=false
        chartView.legend.enabled=false
        
        //render numbers chart
        var chartEntries = [ChartDataEntry] ()
        for i in 0 ..< (workout?.data?.count)! {
            let stat = workout?.data?[i]
            chartEntries.append(ChartDataEntry(x: Double(i), y: (stat?.averageOneMaxRep)!))
        }
        let dataSet = LineChartDataSet(values: chartEntries, label: "One Max Rep")
        let lineData = LineChartData(dataSet: dataSet)
        
        dataSet.circleRadius = 3
        dataSet.valueTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        dataSet.drawCircleHoleEnabled=true
        dataSet.drawValuesEnabled=false
        dataSet.circleColors = [UIColor.white]
        dataSet.circleHoleColor = UIColor.black
        dataSet.circleHoleRadius = 2
        dataSet.colors=[UIColor.white]
        
        chartView.data = lineData
        let dates = workout?.data?.flatMap({element in return element.date})
        chartView.xAxis.valueFormatter = DateValueFormatter(dates: dates!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //Special value formatter to draw dates on X axis
    open class DateValueFormatter : NSObject, IAxisValueFormatter {
        
        var dateFormatter : DateFormatter
        var dates: [Date]?
        public init(dates: [Date]) {
            self.dates = dates
            self.dateFormatter = DateFormatter()
            self.dateFormatter.dateFormat = "MMM d"
        }
        
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return self.dateFormatter.string(from: dates![Int(value)])
        }
    }
}
