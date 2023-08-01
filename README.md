# WeatherWise

## Introduction
WeatherWise is a plain weather forecast iOS application which displays weather data and 5 day forecasts for selected regions. 

## App Overview
WeatherWise consists of two screens:
### 1. Weather list screen
![IMG_4071](https://github.com/ho-ku/WeatherWise/assets/43676501/3d501863-d700-43a8-bee4-2e96e9dd9652)
![IMG_4073](https://github.com/ho-ku/WeatherWise/assets/43676501/10aed2f8-f890-40e6-a1c7-2f4aa683276b)
### Key Features
A list of all locations selected by user with a brief info: weather condition, temperature, time in that region and region name;
A 5-day forecast with 3h interval for the specified region.
### 2. Location search screen
![IMG_4072](https://github.com/ho-ku/WeatherWise/assets/43676501/a3019462-0b2b-4225-84f5-a4b75abd3b15)
### Key Features
A list of all found locations using entered search term.

## Architecture
App architecture is MVVM. WeatherWise is built 100% in SwiftUI. 
Model layer is split into repositories. Each of them has its own functionality and purpose.
Each object is constructed and injected inside the `ModuleFactory` class which acts like a Dependency Injection tool.

External packages:
WeatherWiseCore (https://github.com/ho-ku/WeatherWiseCore)
Purpose: To provide weather forecast for the specified region
Connected via SPM.
