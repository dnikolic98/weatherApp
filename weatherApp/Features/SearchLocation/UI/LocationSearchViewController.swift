//
//  LocationSearchViewController.swift
//  weatherApp
//
//  Created by Dario Nikolic on 03/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LocationSearchViewController: UIViewController {
    
    private let citiesDisposeBage: DisposeBag = DisposeBag()
    private let searchBarDisposeBag: DisposeBag = DisposeBag()
    private var allCitiesDisposeBag: DisposeBag = DisposeBag()
    private let presenter: LocationSearchPresenter!
    private let allCities: BehaviorRelay<[CityViewModel]> = BehaviorRelay<[CityViewModel]>(value: [])
    private let citiesFiltered: BehaviorRelay<[CityViewModel]> = BehaviorRelay<[CityViewModel]>(value: [])
    private var locationSearchView: LocationSearchView {
        return self.view as! LocationSearchView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(with presenter: LocationSearchPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupKeyboardDismissGestureRecognizer()
        setupBackButton()
        setupTableView()
        bindAllCities()
        setupDataFiltering()
        setupTableViewDataReloading()
    }
    
    override func loadView() {
        self.view = LocationSearchView(frame: UIScreen.main.bounds)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
//        refreshTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupSearchBar() {
        setupSearchBarAnimation()
        setupSearchButtonInteractions()
        locationSearchView.searchBar.becomeFirstResponder()
    }
    
    private func setupSearchBarAnimation() {
        locationSearchView.searchBar.rx
            .textDidBeginEditing
            .subscribe({ [weak self] _ in
                self?.locationSearchView.searchBar.setShowsCancelButton(true, animated: true)
            })
            .disposed(by: searchBarDisposeBag)
        
        locationSearchView.searchBar.rx
            .textDidEndEditing
            .subscribe({ [weak self] _ in
                self?.locationSearchView.searchBar.setShowsCancelButton(false, animated: true)
            })
            .disposed(by: searchBarDisposeBag)
    }
    
    private func setupSearchButtonInteractions() {
        Observable.combineLatest(
            locationSearchView.searchBar.rx.cancelButtonClicked,
            locationSearchView.searchBar.rx.searchButtonClicked)
            .subscribe({ [weak self] _ in
                self?.endEditingSearchBar()
            })
            .disposed(by: searchBarDisposeBag)
    }
    
    @objc private func endEditingSearchBar() {
        locationSearchView.searchBar.endEditing(true)
    }
    
    private func setupKeyboardDismissGestureRecognizer() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(endEditingSearchBar))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func setupTableView() {
        locationSearchView.resultsTableView.dataSource = self
        locationSearchView.resultsTableView.delegate = self
        locationSearchView.resultsTableView.register(LocationNameTableViewCell.self, forCellReuseIdentifier: LocationNameTableViewCell.typeName)
    }
    
    private func setupBackButton() {
        locationSearchView.backButton.addTarget(presenter, action: #selector(presenter.handleBackButtonTapped), for: .touchUpInside)
    }
    
    private func bindAllCities() {
        allCitiesDisposeBag = DisposeBag()
        
        presenter
            .fetchCityList()
            .bind(to: allCities)
            .disposed(by: allCitiesDisposeBag)
    }
    
    private func setupDataFiltering() {
        Observable.combineLatest(
            locationSearchView.searchBar.rx.text,
            allCities.asObservable())
            .map({ filter, cities in
                if let filter = filter?.lowercased(), !filter.isEmpty {
                    return cities.filter { $0.name.lowercased().hasPrefix(filter) }
                }
                return []
            })
            .bind(to: citiesFiltered)
            .disposed(by: citiesDisposeBage)
    }
    
    private func setupTableViewDataReloading() {
        citiesFiltered
            .asObservable()
            .subscribe( { [weak self] _ in
                self?.locationSearchView.resultsTableView.reloadData()
            })
            .disposed(by: citiesDisposeBage)
    }
    
}

extension LocationSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesFiltered.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationNameTableViewCell.typeName, for: indexPath) as! LocationNameTableViewCell
        
        if let location = citiesFiltered.value.at(indexPath.row) {
            cell.set(with: location)
        }
        
        return cell
    }
    
}

extension LocationSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LocationNameTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
