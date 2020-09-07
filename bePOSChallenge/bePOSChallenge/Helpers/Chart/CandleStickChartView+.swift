//
//  LineChartView+.swift
//  BaseProduct
//
//  Created by admin on 9/6/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import Charts

extension CandleStickChartView {
    func setData(stockData: [BPHistoryStock]) {
        
        let yVals1 = (0..<stockData.count).map { (i) -> CandleChartDataEntry in
            let currentHistorical = stockData[i]
            
            let val = Double(20)
            let high = currentHistorical.high
            let low = currentHistorical.low
            let open = currentHistorical.open
            let close = currentHistorical.close
            let even = i % 2 == 0
            
            return CandleChartDataEntry(x: Double(i),
                                        shadowH: val + high,
                                        shadowL: val - low,
                                        open: even ? val + open : val - open,
                                        close: even ? val - close : val + close,
                                        icon: UIImage(named: "icon") ?? nil)
            
        }
        
        let set1 = CandleChartDataSet(entries: yVals1, label: "Data Set")
        set1.axisDependency = .left
        set1.setColor(UIColor(white: 80/255, alpha: 1))
        set1.drawIconsEnabled = false
        set1.shadowColor = .darkGray
        set1.shadowWidth = 0.7
        set1.decreasingColor = .red
        set1.decreasingFilled = true
        set1.increasingColor = UIColor(red: 122/255, green: 242/255, blue: 84/255, alpha: 1)
        set1.increasingFilled = false
        set1.neutralColor = .blue
        
        let data = CandleChartData(dataSet: set1)
        self.data = data
    }
    
    func configChartView() {
        self.chartDescription?.enabled = false
        
        self.dragEnabled = false
        self.setScaleEnabled(true)
        self.maxVisibleCount = 200
        self.pinchZoomEnabled = true
        
        self.legend.horizontalAlignment = .right
        self.legend.verticalAlignment = .top
        self.legend.orientation = .vertical
        self.legend.drawInside = false
        self.legend.font = UIFont(name: "HelveticaNeue-Light", size: 10)!
        
        self.leftAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        self.leftAxis.spaceTop = 0.3
        self.leftAxis.spaceBottom = 0.3
        self.leftAxis.axisMinimum = 0
        
        self.rightAxis.enabled = false
        
        self.xAxis.labelPosition = .bottom
        self.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
    }
}
