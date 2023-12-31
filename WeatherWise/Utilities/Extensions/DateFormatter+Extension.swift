//
//  DateFormatter+Extension.swift
//  WeatherWise
//
//  Created by Денис Андриевский on 30.07.2023.
//

import Foundation

extension DateFormatter {
    static let hourMinute: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter
    }()
    
    static let dayMonthHourMinute: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM hh:mm"
        return dateFormatter
    }()
}
