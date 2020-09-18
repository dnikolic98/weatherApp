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
import RxDataSources

class LocationSearchViewController: UIViewController {
    
    //MARK: - Properties
    
    private var throttleTime: RxTimeInterval = .milliseconds(500)
    private let citiesDisposeBage: DisposeBag = DisposeBag()
    private let viewControllerDisposeBag: DisposeBag = DisposeBag()
    private var presenter: LocationSearchPresenter!
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionOfCityViewModels>!
    private var tableView: UITableView {
        locationSearchView.resultsTableView
    }
    
    var locationSearchView: LocationSearchView!
    
    //MARK: - Initialization
    
    convenience init(with presenter: LocationSearchPresenter) {
        self.init()
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
        setupDataSource()
        configureTableView()
        setupSearchBar()
        setupKeyboardDismissGestureRecognizer()
        setupBackButton()
        bindTableViewData()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: - SearchBar Setup
    
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
            .disposed(by: viewControllerDisposeBag)
        
        locationSearchView.searchBar.rx
            .textDidEndEditing
            .subscribe({ [weak self] _ in
                self?.locationSearchView.searchBar.setShowsCancelButton(false, animated: true)
            })
            .disposed(by: viewControllerDisposeBag)
    }
    
    private func setupSearchButtonInteractions() {
        Observable.combineLatest(
            locationSearchView.searchBar.rx.cancelButtonClicked,
            locationSearchView.searchBar.rx.searchButtonClicked)
            .subscribe({ [weak self] _ in
                self?.endEditingSearchBar()
            })
            .disposed(by: viewControllerDisposeBag)
    }
    
    @objc private func endEditingSearchBar() {
        locationSearchView.searchBar.endEditing(true)
    }
    
    //MARK: - Keyboard dismiss setup
    
    private func setupKeyboardDismissGestureRecognizer() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(endEditingSearchBar))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    //MARK: - Back button setup
    
    private func setupBackButton() {
        locationSearchView.backButton.addTarget(presenter, action: #selector(presenter.handleBackButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - TableView setup
    
    private func configureTableView() {
        tableView.rx.setDelegate(self).disposed(by: viewControllerDisposeBag)
        tableView.register(LocationNameTableViewCell.self, forCellReuseIdentifier: LocationNameTableViewCell.typeName)
        
        Observable.zip(
            tableView.rx.itemSelected,
            tableView.rx.modelSelected(CityViewModel.self))
            .subscribe(onNext: { [weak self] indexPath, location in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
                
                self.presenter.handleCellTap(city: location)
            })
            .disposed(by: viewControllerDisposeBag)
    }
    
    private func setupDataSource() {
        dataSource = RxTableViewSectionedReloadDataSource<SectionOfCityViewModels>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: LocationNameTableViewCell.typeName, for: indexPath) as! LocationNameTableViewCell
                cell.set(with: item)
                return cell
        })
    }
    
    private func bindTableViewData() {
        locationSearchView.searchBar.rx.text.orEmpty
            .throttle(throttleTime, scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] query -> Observable<[SectionOfCityViewModels]> in
                guard
                    let self = self,
                    !query.isEmpty
                else {
                    return .just([])
                }
                self.locationSearchView.startLoadingIndicator()
                return self.presenter.fetchCityList(query: query)
            }
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] cityViewModels in
                self?.locationSearchView.stopLoadingIndicator()
            })
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: viewControllerDisposeBag)
    }
    
}

//MARK: - TableViewDelegate

extension LocationSearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LocationNameTableViewCell.height
    }

}
