//
//  CryptoListTableView.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 14/08/2025.
//

import Combine
import OSLog
import SwiftUI
import UIKit

final class CryptoListTableViewController: UITableViewController {
    private var viewModel: CryptoListViewModel
    private let sectionTitles: [String] = ["Favourite", "Top 50"]
    private let searchController = UISearchController(searchResultsController: nil)
    private var isFav: Bool = false
    private var networkButton: UIButton = UIButton(type: .custom)
    private var cancellables: [AnyCancellable] = []
    
    private var filterListData: [CryptoData] {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else { return viewModel.cryptoList }
        return viewModel.cryptoList.filter {
            $0.name?.localizedCaseInsensitiveContains(searchText) ?? false
        }
    }
    
    private var filterFavListData: [CryptoData] {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else { return favListData }
        return favListData.filter {
            $0.name?.localizedCaseInsensitiveContains(searchText) ?? false
        }
    }
    
    private var favListData: [CryptoData] {
        let favList = DataController.shared.fetchFavourite()
        let favId = favList.map { $0.id }
        return viewModel.cryptoList.filter({ favId.contains($0.id) })
    }
    
    private var sectionData: [[CryptoData]] {
        return [filterFavListData, filterListData]
    }
    
    init(viewModel: CryptoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableReload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Crypto Track"
        tableView.register(CryptoCell.getNib(), forCellReuseIdentifier: CryptoCell.identifier)
        
        setupSearchBar()
        setupPullRefresh()
        setNetworkButton()
        setNetworkButton()
        binding()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionData.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionData[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CryptoCell.identifier, for: indexPath) as? CryptoCell
        let item = sectionData[indexPath.section][indexPath.row]
        cell?.logo.load(url: URL(string: item.image ?? "")!)
        cell?.name.text = item.name
        cell?.symbol.text = item.symbol
        cell?.currentPrice.text = item.currentPrice?.formatCurrency(item.currentPrice ?? 0, currencyCode: "USD")
        cell?.percentage.textColor = item.priceChangePercentage24H ?? 0 > 0 ? UIColor.green : UIColor.red
        cell?.percentage.text = String(format: "%.2f", item.priceChangePercentage24H ?? 0) + "%"
        
        getIsFav(item: item)
        cell?.tap = { [weak self] in
            guard let self else { return }
            getIsFav(item: item)
            self.isFav.toggle()
            guard let id = item.id else { return }
            if self.isFav {
                //add to favouriste list
                DataController.shared.addFavourite(id: id, name: item.name ?? "", symbol: item.symbol ?? "")
                DataController.shared.saveContext()
            } else {
                //remove from favourite list
                DataController.shared.removeFavourite(id: id)
            }
            tableReload()
        }
        setButtonImage(button: cell?.favButton, isFav: isFav)

        return cell ?? CryptoCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailview = CryptoDetailView(isFav: isFav, item: sectionData[indexPath.section][indexPath.row])
        let hostingController = UIHostingController(rootView: detailview)
        
        self.navigationController?.pushViewController(hostingController, animated: true)
    }
    
    private func setButtonImage(button: UIButton?, isFav: Bool) {
        if isFav {
            button?.tintColor = UIColor.red
            button?.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            button?.tintColor = UIColor.gray
            button?.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}

extension CryptoListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        tableReload()
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
    }
    
    private func setupPullRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.tintColor = .gray
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching latest data...")

        self.refreshControl = refreshControl
    }
    
    @objc private func refreshData(_ sender: UIRefreshControl) {
        Task {
            try await viewModel.asyncApply()
            tableReload()
            sender.endRefreshing()
        }
    }
    
    private func binding() {
        NetworkMonitor.shared.$isConnected
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isConnected in
                let image = isConnected ? UIImage(systemName: "wifi") : UIImage(systemName: "wifi.slash")
                let color = isConnected ? UIColor.green : UIColor.red
                self?.networkButton.setImage(image, for: .normal)
                self?.networkButton.tintColor = color
                if isConnected {
                    Task {
                        Logger.cryptoTrack.info("Retry network request")
                        try? await self?.viewModel.asyncApply()
                        self?.tableReload()
                    }
                }
            })
            .store(in: &self.cancellables)
    }
    
    private func setNetworkButton() {
        networkButton = UIButton(type: .custom)
        networkButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        networkButton.setImage(UIImage(systemName: "wifi"), for: .normal)
        networkButton.tintColor = UIColor.green
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: networkButton)
    }
    
    private func getIsFav(item: CryptoData) {
        let favList = DataController.shared.fetchFavourite()
        isFav = favList.filter({ $0.id == item.id }).first != nil
    }
    
    private func tableReload() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.tableView.alpha = 0
        }) { [weak self] _ in
            self?.tableView.reloadData()
            UIView.animate(withDuration: 0.2) {
                self?.tableView.alpha = 1
            }
        }
    }
}
