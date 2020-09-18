//
//  DetailWeatherPresnter.swift
//  weatherApp
//
//  Created by Dario Nikolic on 11/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import RxSwift
import RxCocoa

class DetailWeatherPresenter {
    

    //MARK: - Properties
    
    private let weatherRepository: WeatherRepository
    
    var currentWeather: CurrentWeatherViewModel
    var weatherConditionList: BehaviorRelay<[SectionOfConditionInformation]>
    var isReachable: Observable<Bool> {
        weatherRepository.isReachable
    }
    
    //MARK: - Initialization

    init(currentWeather: CurrentWeatherViewModel, weatherRepository: WeatherRepository) {
        self.currentWeather = currentWeather
        self.weatherRepository = weatherRepository
        
        weatherConditionList = BehaviorRelay<[SectionOfConditionInformation]>(value: [])
        setConditionList(currentWeather: currentWeather)
    }
    
    func fetchCurrentWeather() -> Observable<CurrentWeatherViewModel?> {
        return weatherRepository
            .fetchCurrentWeather(coord: currentWeather.coord)
            .flatMap { currentWeather -> Observable<CurrentWeatherViewModel?> in
                guard let currentWeather = currentWeather else { return .just(nil) }
                return .just(CurrentWeatherViewModel(currentWeather: currentWeather))
            }
            .do(onNext: { [weak self] currentWeather in
                guard
                    let self = self,
                    let currentWeather = currentWeather
                else {
                    return
                }
                self.currentWeather = currentWeather
                self.setConditionList(currentWeather: currentWeather)
            })
    }
    
    func fetchFiveDaysList() -> Observable<[SectionOfSingleWeatherInformation]> {
        fetchDailyForecast()
            .flatMap { sevenDayForecast -> Observable<[SingleWeatherInformationViewModel]> in
                guard sevenDayForecast.count >= 6 else { return .just([]) }
                var fiveDaysList: [SingleWeatherInformationViewModel] = []
                
                for forecast in sevenDayForecast[1...5] {
                    let minTempValue = String(format: LocalizedStrings.degreeValueFormat, forecast.minTemperature)
                    let maxTempValue = String(format: LocalizedStrings.degreeValueFormat, forecast.maxTemperature)
                    let temperature = "\(maxTempValue)\n\(minTempValue)"
                    let day = forecast.forecastTime.dayOfWeek().uppercased()
                    
                    fiveDaysList.append(SingleWeatherInformationViewModel(header: day, body: temperature, iconUrlString: forecast.weatherIconUrlString))
                }
                
                return .just(fiveDaysList)
            }
            .flatMap { singleWeatherInformationViewModels -> Observable<[SectionOfSingleWeatherInformation]> in
                .just([SectionOfSingleWeatherInformation(items: singleWeatherInformationViewModels)])
            }
    }
    
    private func fetchDailyForecast() -> Observable<[DailyForecastViewModel]> {
        return weatherRepository
            .fetchForcastWeather(coord: currentWeather.coord)
            .flatMap { [weak self] forecastedWeather -> Observable<[DailyForecastViewModel]> in
                guard
                    let self = self,
                    let forecastedWeather = forecastedWeather
                else {
                    return .just([])
                }
                let sevenDayForecast = self.createSevenDayForecastViewModels(forecastedWeather: forecastedWeather)
                return .just(sevenDayForecast)
            }
    }
    
    private func setConditionList(currentWeather: CurrentWeatherViewModel) {
        let conditionInformation = self.createWeatherConditionList(currentWeather: currentWeather)
        self.weatherConditionList.accept([SectionOfConditionInformation(items: conditionInformation)])
    }
    
    //MARK: - Helpers
    
    private func createSevenDayForecastViewModels(forecastedWeather: ForecastedWeatherCoreData) -> [DailyForecastViewModel] {
        do {
            return try forecastedWeather.forecastedWeather
                .map { dailyWeather in
                    guard let dailyWeather = dailyWeather as? DailyWeatherCoreData else { throw CoreDataErrors.incompatibleCast }
                    return DailyForecastViewModel(currentWeather: self.currentWeather, dailyWeather: dailyWeather)
                }
                .sorted { $0.forecastTime < $1.forecastTime }
        } catch {
            return []
        }
    }
    
    private func createWeatherConditionList(currentWeather: CurrentWeatherViewModel?) -> [ConditionInformationViewModel] {
        guard let current = currentWeather else { return [] }
        
        var weatherConditionList: [ConditionInformationViewModel] = []
        
        let feelsLikeTemperatureValue = String(format: LocalizedStrings.temperatureValueFormat, current.feelsLikeTemperature)
        let humidityValue = String(format: LocalizedStrings.percentageValueFormat, current.humidity)
        let pressureValue = String(format: LocalizedStrings.pressureValueFormat, current.pressure)
        let windSpeedValue = String(format: LocalizedStrings.speedValueFormat, current.windSpeed)

        let feelsLikeTemperature = ConditionInformationViewModel(title: LocalizedStrings.feelsLike, value: feelsLikeTemperatureValue)
        let humidity =  ConditionInformationViewModel(title: LocalizedStrings.humidity, value: humidityValue)
        let pressure = ConditionInformationViewModel(title: LocalizedStrings.pressure, value: pressureValue)
        let windSpeed = ConditionInformationViewModel(title: LocalizedStrings.wind, value: windSpeedValue)
        
        weatherConditionList.append(feelsLikeTemperature)
        weatherConditionList.append(humidity)
        weatherConditionList.append(pressure)
        weatherConditionList.append(windSpeed)
        
        return weatherConditionList
    }
    
}
