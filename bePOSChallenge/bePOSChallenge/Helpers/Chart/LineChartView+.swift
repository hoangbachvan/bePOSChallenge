//
//  LineChartView+.swift
//  BaseProduct
//
//  Created by admin on 9/6/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import Charts

extension LineChartView {
    func setupData(stockData: [BPHistoryStock]) {
        let values = (0..<stockData.count).map { (i) -> ChartDataEntry in
            let val = stockData[i].close
            return ChartDataEntry(x: Double(i), y: val, icon: nil)
        }
        
        let set1 = LineChartDataSet(entries: values, label: "")
        set1.drawIconsEnabled = false
        
        set1.lineDashLengths = [5, 2.5]
        set1.highlightLineDashLengths = [5, 2.5]
        set1.setColor(ThemeWrapper.instance.currentTheme.chartColor)
        set1.setCircleColor(ThemeWrapper.instance.currentTheme.chartColor)
        set1.lineWidth = 0.5
        set1.circleRadius = 1
        set1.drawCircleHoleEnabled = false
        set1.valueFont = .systemFont(ofSize: 9)
        set1.formLineDashLengths = [5, 2.5]
        set1.formLineWidth = 1
        set1.formSize = 15
        
        let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
                              ChartColorTemplates.colorFromString("#ffff0000").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        set1.fillAlpha = 1
        set1.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
        set1.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: set1)
        
        self.data = data
        self.animate(xAxisDuration: 1)
    }
    
    func configChartView() {
        self.chartDescription?.enabled = false
        self.dragEnabled = true
        self.setScaleEnabled(true)
        self.pinchZoomEnabled = true
        
        self.xAxis.gridLineDashLengths = [10, 10]
        self.xAxis.gridLineDashPhase = 0
        self.xAxis.drawGridLinesEnabled = false
        
        let leftAxis = self.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.axisMinimum = -50
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = true
        
        self.rightAxis.enabled = false

        self.legend.form = .line
    }
    
    func updateXAsixValue(listDate: [Date]) {
        self.xAxis.valueFormatter = DayAxisValueFormatter(chart: self, listDate: listDate)
    }
}
