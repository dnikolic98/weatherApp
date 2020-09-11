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

protocol LocationSearchDelegate {
    func didTapNewLocation()
}

class LocationSearchViewController: UIViewController {
    
    private var throttleTime: RxTimeInterval = .milliseconds(500)
    private let citiesDisposeBage: DisposeBag = DisposeBag()
    private let searchBarDisposeBag: DisposeBag = DisposeBag()
    private let tableViewDisposeBag: DisposeBag = DisposeBag()
    private var locationSearchDelegate: LocationSearchDelegate?
    private let presenter: LocationSearchPresenter!
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionOfCityViewModels>!
    private var locationSearchView: LocationSearchView {
        view as! LocationSearchView
    }
    private var tableView: UITableView {
        locationSearchView.resultsTableView
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
    
    override func loadView() {
        self.view = LocationSearchView(frame: UIScreen.main.bounds)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setupDelegate(_ delegate: LocationSearchDelegate) {
        locationSearchDelegate = delegate
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
    
    private func setupBackButton() {
        locationSearchView.backButton.addTarget(presenter, action: #selector(presenter.handleBackButtonTapped), for: .touchUpInside)
    }
    
    private func setupDataSource() {
        dataSource = RxTableViewSectionedReloadDataSource<SectionOfCityViewModels>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: LocationNameTableViewCell.typeName, for: indexPath) as! LocationNameTableViewCell
                cell.set(with: item)
                return cell
        })
    }
    
    private func configureTableView() {
        tableView.rx.setDelegate(self).disposed(by: tableViewDisposeBag)
        tableView.register(LocationNameTableViewCell.self, forCellReuseIdentifier: LocationNameTableViewCell.typeName)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
                
                self.presenter.handleCellTap(index: indexPath.row)
                if let delegate = self.locationSearchDelegate {
                    delegate.didTapNewLocation()
                }
            })
            .disposed(by: tableViewDisposeBag)
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
            .disposed(by: citiesDisposeBage)
    }
    
}

extension LocationSearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LocationNameTableViewCell.height
    }

}
