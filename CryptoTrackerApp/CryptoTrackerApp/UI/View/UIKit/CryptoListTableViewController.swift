//
//  CryptoListTableView.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 14/08/2025.
//

import SwiftUI
import UIKit

final class CryptoListTableViewController: UITableViewController {
    private var viewModel: CryptoListViewModel
    
    init(viewModel: CryptoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Crypto Track"
        tableView.register(CryptoCell.getNib(), forCellReuseIdentifier: CryptoCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cryptoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CryptoCell.identifier, for: indexPath) as? CryptoCell
        let item = viewModel.cryptoList[indexPath.row]
        cell?.logo.load(url: URL(string: item.image ?? "")!)
        cell?.name.text = item.name
        cell?.symbol.text = item.symbol
        cell?.currentPrice.text = item.currentPrice?.formatCurrency(item.currentPrice ?? 0, currencyCode: "USD")
        cell?.percentage.textColor = item.priceChangePercentage24H ?? 0 > 0 ? UIColor.green : UIColor.red
        cell?.percentage.text = String(format: "%.2f", item.priceChangePercentage24H ?? 0) + "%"
        
        let favList = DataController.shared.fetchFavourite()
        var isFav = favList.filter({ $0.id == item.id }).first != nil
        cell?.tap = {
            
            isFav.toggle()
            guard let id = item.id else { return }
            if isFav {
                //add to favouriste list
                DataController.shared.addFavourite(id: id, name: item.name ?? "", symbol: item.symbol ?? "")
                DataController.shared.saveContext()
            } else {
                //remove from favourite list
                DataController.shared.removeFavourite(id: id)
            }
            self.setButtonImage(button: cell?.favButton, isFav: isFav)
        }
        setButtonImage(button: cell?.favButton, isFav: isFav)

        return cell ?? CryptoCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailview = CryptoDetailView(isFav: false, item: viewModel.cryptoList[indexPath.row])
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
