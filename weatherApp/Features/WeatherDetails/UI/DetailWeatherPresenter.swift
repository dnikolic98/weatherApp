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
    
    private var currentWeatherDisposeBag: DisposeBag = DisposeBag()
    private var fiveDaysDisposeBag: DisposeBag = DisposeBag()
    private let weatherRepository: WeatherRepository
    private var weatherConditionList: [ConditionInformationViewModel] = []
    
    var currentWeather: BehaviorRelay<CurrentWeatherViewModel?>
    var fiveDaysList: BehaviorRelay<[SectionOfSingleWeatherInformation]>
    var weatherData: Observable<(CurrentWeatherViewModel?, [SectionOfSingleWeatherInformation])> {
        Observable.combineLatest(currentWeather.asObservable(),
                           fiveDaysList.asObservable())
        
    }
    var numberOfConditions: Int {
        weatherConditionList.count
    }
    var numberOfConditionRows: Int {
        (numberOfConditions / 2 + numberOfConditions % 2)
    }
    
    init(currentWeather: CurrentWeatherViewModel, weatherRepository: WeatherRepository) {
        self.currentWeather = BehaviorRelay<CurrentWeatherViewModel?>(value: currentWeather)
        self.fiveDaysList = BehaviorRelay<[SectionOfSingleWeatherInformation]>(value: [])
        self.weatherRepository = weatherRepository

        setWeatherConditionList()
    }
    
    func weatherCondition(atIndex index: Int) -> ConditionInformationViewModel? {
        return weatherConditionList.at(index)
    }
    
    func bindCurrentWeather() -> BehaviorRelay<CurrentWeatherViewModel?> {
        fetchCurrentWeather()
        return currentWeather
    }
    
    func bindFiveDaysList() -> BehaviorRelay<[SectionOfSingleWeatherInformation]>{
        fetchFiveDaysList()
        return fiveDaysList
    }
    
    func fetchCurrentWeather() {
        currentWeatherDisposeBag = DisposeBag()
        guard let coord = currentWeather.value?.coord else { return }
        
        return weatherRepository
            .fetchCurrentWeather(coord: coord)
            .flatMap { currentWeather -> Observable<CurrentWeatherViewModel?> in
                guard let currentWeather = currentWeather else { return .just(nil) }
                return .just(CurrentWeatherViewModel(currentWeather: currentWeather))
            }
            .bind(to: currentWeather)
            .disposed(by: currentWeatherDisposeBag)
    }
    
    func fetchFiveDaysList() {
        fiveDaysDisposeBag = DisposeBag()
        
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
            .map { singleWeatherInformationViewModels in
                [SectionOfSingleWeatherInformation(items: singleWeatherInformationViewModels)]
            }
            .bind(to: fiveDaysList)
            .disposed(by: fiveDaysDisposeBag)
    }
    
    private func fetchDailyForecast() -> Observable<[DailyForecastViewModel]> {
        guard let current = currentWeather.value else { return .just([]) }
        
        return weatherRepository
            .fetchForcastWeather(coord: current.coord)
            .flatMap { forecastedWeather -> Observable<[DailyForecastViewModel]> in
                guard let forecastedWeather = forecastedWeather else { return .just([]) }
                var sevenDayForecast: [DailyForecastViewModel]
                
                do {
                    sevenDayForecast = try forecastedWeather.forecastedWeather
                        .map { dailyWeather in
                            guard let dailyWeather = dailyWeather as? DailyWeatherCoreData else { throw CoreDataErrors.incompatibleCast }
                            return DailyForecastViewModel(currentWeather: current, dailyWeather: dailyWeather)
                        }
                        .sorted { $0.forecastTime < $1.forecastTime }
                } catch {
                    sevenDayForecast = []
                }
                return .just(sevenDayForecast)
            }
    }
    
    
    private func setWeatherConditionList() {
        guard let current = currentWeather.value else { return }
        
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
    }
    
}
