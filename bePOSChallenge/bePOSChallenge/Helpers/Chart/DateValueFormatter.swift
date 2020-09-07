//
//  DateValueFormatter.swift
//  BaseProduct
//
//  Created by admin on 9/6/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import Foundation
import Charts

public class DayAxisValueFormatter: NSObject, IAxisValueFormatter {
    weak var chart: BarLineChartViewBase?
    var listDate = [Date]()
    let months = ["Jan", "Feb", "Mar",
                  "Apr", "May", "Jun",
                  "Jul", "Aug", "Sep",
                  "Oct", "Nov", "Dec"]
    
    init(chart: BarLineChartViewBase, listDate: [Date]) {
        self.chart = chart
        self.listDate = listDate
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        let index = Int(value)
        let currentDate = listDate[safe: index] ?? Date()
        let dayOfMonth = currentDate.get(.day)
        let year = currentDate.get(.year)
        let month = currentDate.get(.month)
        
        let monthName = months[month - 1]
        let yearName = "\(year)"
        if let chart = chart,
            chart.visibleXRange > 30 * 6 {
            return monthName + yearName
        } else {
            
            var appendix: String
            switch dayOfMonth {
            case 1, 21, 31: appendix = "st"
            case 2, 22: appendix = "nd"
            case 3, 23: appendix = "rd"
            default: appendix = "th"
            }
            
            return dayOfMonth == 0 ? "" : String(format: "%d\(appendix) \(monthName)", dayOfMonth)
        }
    }
}
