//
//  RPDate.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/18.
//

import UIKit

extension Date {
    //计算月有多少天
    func calculateOneMonthDays() -> Int {
        let result = NSCalendar.current.range(of: .day, in: .month, for: self)
        let final = Int(Float(result?.upperBound ?? 0)-Float(result?.lowerBound ?? 0))
        return final
    }
    
    //计算当前月的第一天是周几
    func calculateMonthFirstDayIsWeekDay() -> Int {
        var components = NSCalendar.current.dateComponents([.year,.month,.day], from: self)
        components.day = 1
        guard let date = NSCalendar.current.date(from: components) else {
            log.debug("计算错误")
            return 8
        }
        guard var result = NSCalendar.current.ordinality(of: .weekday, in: .weekOfMonth, for: date) else {
            log.debug("计算错误")
            return 8
        }
        result -= 1
        return result
    }
    
    //获取当前年月日
    func calculateYear() -> Int {
        return NSCalendar.current.component(.year, from: self)
    }
    
    func calculateMonth() -> Int {
        return NSCalendar.current.component(.month, from: self)
    }
    
    func calculateDay() -> Int {
        return NSCalendar.current.component(.day, from: self)
    }
    
    //是否是今天
    func isToday() -> Bool {
        var now = Date.init()
        if #available(iOS 15, *) {
            now = Date.now
        }
        return self.calculateDay()==now.calculateDay() && self.calculateMonth()==now.calculateMonth() && self.calculateYear()==now.calculateYear()
    }
    
    //是否是同一个月
    func isSameMonth(_ other:Date) -> Bool {
        return self.calculateMonth()==other.calculateMonth() && self.calculateYear()==other.calculateYear()
    }
    
    //是否是同一天
    func isSameDay(_ other:Date) -> Bool {
        return self.calculateMonth()==other.calculateMonth() && self.calculateYear()==other.calculateYear() && self.calculateDay()==other.calculateDay()
    }
    
    //获取下一个月
    func calculateNextMonth() -> Date {
        guard let next = NSCalendar.current.date(byAdding: .month, value: 1, to: self) else {
            log.debug("计算错误")
            return Date.init()
        }
        return next
    }
    
    //获取上一个月
    func calculatePreMonth() -> Date {
        guard let pre = NSCalendar.current.date(byAdding: .month, value: -1, to: self) else {
            log.debug("计算错误")
            return Date.init()
        }
        return pre
    }
    
    //date转字符串
    func toString(_ dateFormat:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }
}
