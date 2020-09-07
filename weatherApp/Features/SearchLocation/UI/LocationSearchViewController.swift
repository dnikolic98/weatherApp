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
    
    private let searchBarDisposeBag: DisposeBag = DisposeBag()
    private let presenter: LocationSearchPresenter!
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
        
//        locationSearchView.searchBar.rx.text
//            .subscribe(onNext: { query in
//                self.presenter.fetch(query: query ?? "")
//            })
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
    }
    
    private func setupSearchBarAnimation() {
        locationSearchView.searchBar.rx
            .textDidBeginEditing
            .subscribe({ [weak self] _ in
                guard let self = self else { return }
                self.locationSearchView.searchBar.setShowsCancelButton(true, animated: true)
            })
            .disposed(by: searchBarDisposeBag)
        
        locationSearchView.searchBar.rx
            .textDidEndEditing
            .subscribe({ [weak self] _ in
                guard let self = self else { return }
                self.locationSearchView.searchBar.setShowsCancelButton(false, animated: true)
            })
            .disposed(by: searchBarDisposeBag)
    }
    
    private func setupSearchButtonInteractions() {
        Observable.combineLatest(
            locationSearchView.searchBar.rx.cancelButtonClicked,
            locationSearchView.searchBar.rx.searchButtonClicked)
            .subscribe({ [weak self] _ in
                guard let self = self else { return }
                self.endEditingSearchBar()
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
}
