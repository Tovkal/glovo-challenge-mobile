//
//  CityListViewController.swift
//  GlovoMaps
//
//  Created by Andrés Pizá Bückmann on 10/02/2019.
//  Copyright © 2019 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxDataSources

class CityListViewController: UIViewController {

    private var tableView: UITableView!
    private var loader: Loader!

    private let viewModel: CityListViewModel
    private let bag = DisposeBag()

    private let dataSource = RxTableViewSectionedReloadDataSource<CountryViewEntity>(configureCell:  { (dataSource, tableView, indexPath, city) -> UITableViewCell in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityListTableViewCell.identifier, for: indexPath) as? CityListTableViewCell else {
            fatalError("Could not find cell with identifier \(CityListTableViewCell.identifier) for indexPath \(indexPath)")
        }

        cell.configure(with: city)

        return cell
    })

    init(viewModel: CityListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = UIView(frame: UIScreen.main.bounds)
        tableView = UITableView(frame: .zero)
        view.addSubview(tableView)

        loader = Loader()
        view.addSubview(loader)

        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        loader.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bindUI()
    }

    private func configureTableView() {
        tableView.register(CityListTableViewCell.self, forCellReuseIdentifier: CityListTableViewCell.identifier)
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].name
        }
    }

    private func bindUI() {
        tableView.rx.modelSelected(CityViewEntity.self)
            .bind(to: viewModel.input.selectedCity)
            .disposed(by: bag)

        viewModel.output.items
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)

        viewModel.output.isLoading
            .subscribe(onNext: { [weak self] (isLoading) in
                self?.loader.animate(isLoading)
            })
            .disposed(by: bag)

        viewModel.output.navigate.subscribe().disposed(by: bag)
    }
}
