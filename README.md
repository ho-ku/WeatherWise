# WeatherWise

## Introduction
WeatherWise is a plain weather forecast iOS application which displays weather data and 5 day forecasts for selected regions. 

## App Overview
WeatherWise consists of two screens:
### 1. Weather list screen
![IMG_4073](https://github.com/ho-ku/WeatherWise/assets/43676501/42379362-47e4-4651-8152-1711da81e8ad)
![IMG_4071](https://github.com/ho-ku/WeatherWise/assets/43676501/8c9c6497-ea21-4076-b9cd-a7bdb573f067)
### Key Features
A list of all locations selected by user with a brief info: weather condition, temperature, time in that region and region name;
A 5-day forecast with 3h interval for the specified region.
### 2. Location search screen
![IMG_4072](https://github.com/ho-ku/WeatherWise/assets/43676501/f334ac50-18e5-4e21-bc02-bf0d4dfe4b62)
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

## Contact Information
Email: hoku.dev01@gmail.com<br>
[Telegram](https://t.me/justHoku)
