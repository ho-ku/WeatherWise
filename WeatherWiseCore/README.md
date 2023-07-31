# WeatherWiseCore
The goal of this package is to provide a weather forecast for the specfied location within the next 5 days with 3 hours interval. 

For example of request will be done at 00:00 01.01 than weather forecast date list will be:
- 01.01 02:00
- 01.01 05:00
- 01.01 08:00
- 01.01 11:00
- 01.01 14:00
- 01.01 17:00
- 01.01 20:00
- 01.01 23:00
- 02.01 02:00
- 02.01 05:00
...
- 06.01 23:00

## Overview
Package consists of three files:
### APIConfig - file that stores configuration properties that need to be passed to API;
### ForecastUnit - file that stores a model object of the weather forecast;
### ForecastAPI - main file that does API call which retrieves forecast data;

## Usage
1. Create a `ForecastBuilder` instance and pass all needed properties
2. Call build method
3. Execute `forecast(coordinate: (lat: String, lon: String))`

Example:
``` swift
let api = ForecastBuilder(
                urlSession: {URLSession},
                decoder: {Decoder}
            )
            .withAPIKey("{YOUR_API_KEY}")
            .build()
            
do {
    let forecast = try await api.forecast(coordinate: (lat: String, lon: String))
} catch {
    // Handle errors
}
```
