//
//  Date+.swift
//  BaseProduct
//
//  Created by admin on 9/6/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit
extension Date {
    func getPreviousMonth(month: Int) -> Date {
        let previousMonths = Calendar.current.date(byAdding: .month, value: month, to: Date())
        return previousMonths ?? Date()
    }
    
    func getPreviousDays(day: Int) -> Date {
        let previousMonths = Calendar.current.date(byAdding: .day, value: -day, to: Date())
        return previousMonths ?? Date()
    }
    
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func get(_ components: Calendar.Component..., calendar: Calendar = .current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = .current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func getDayBetween(date: Date, calendar: Calendar = .current) -> Int {
        return abs(calendar.dateComponents([.day], from: calendar.startOfDay(for: self), to: calendar.startOfDay(for: date)).day ?? 0)
    }
}
