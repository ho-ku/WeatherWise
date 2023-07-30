//
//  WeatherCell.swift
//  WeatherWise
//
//  Created by Денис Андриевский on 28.07.2023.
//

import SwiftUI

struct WeatherCell: View {
    
    private struct Const {
        static let padding = 24.0
        static let spacing = 10.0
        static let cornerRadius = 16.0
    }
    
    // MARK: - Properties
    
    let location: WeatherLocation
    let metadata: WeatherLocation.Metadata
    let timeAction: () async -> String
    
    @State private var time: String?
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: Const.spacing) {
                HStack {
                    Text(metadata.weatherCondition ?? "")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                        .bold()
                    
                    Spacer()
                    
                    if let time {
                        Text(time)
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                            .bold()
                    }
                }
                
                if let temperature = metadata.temperature {
                    Text("\(temperature)°")
                        .font(.system(size: 40))
                        .bold()
                } else {
                    Text("")
                        .font(.system(size: 40))
                        .bold()
                }
                
                
                Text(location.title)
                    .font(.system(size: 20))
                    .bold()
            }
            
            Spacer()
        }
        .padding(Const.padding)
        .background(
            Color.white
                .cornerRadius(Const.cornerRadius)
                .shadow(color: .gray.opacity(0.2), radius: 12)
        )
        .onAppear {
            Task {
                let currentTime = await timeAction()
                await MainActor.run {
                    time = currentTime
                }
            }
        }
    }
}
