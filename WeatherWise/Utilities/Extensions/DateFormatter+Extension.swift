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
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter
    }()
}
