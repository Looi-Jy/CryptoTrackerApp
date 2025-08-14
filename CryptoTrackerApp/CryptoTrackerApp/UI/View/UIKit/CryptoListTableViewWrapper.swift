//
//  CryptoListTableViewWrapper.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 14/08/2025.
//

import SwiftUI
import UIKit

struct CryptoListTableViewWrapper: UIViewControllerRepresentable {
    private var vm: CryptoListViewModel
    
    init(vm: CryptoListViewModel) {
        self.vm = vm
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let rootViewController = CryptoListTableViewController(viewModel: vm)
        let navigationController = UINavigationController(rootViewController: rootViewController)
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
    }
}
