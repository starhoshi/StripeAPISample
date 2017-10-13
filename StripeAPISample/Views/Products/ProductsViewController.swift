//
//  ProductsViewController.swift
//  StripeAPISample
//
//  Created by kensuke-hoshikawa on 2017/10/13.
//  Copyright © 2017年 kensuke-hoshikawa. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController {
    let tableView = UITableView()
    var refreshControl = UIRefreshControl()

    var products: [StripeAPI.Entity.Product] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Products"

        view = tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(self.onPulledRefresh(sender:)), for: .valueChanged)

        sendProductAllAPI()
    }

    @objc private func onPulledRefresh(sender: UIRefreshControl) {
        sendProductAllAPI()
        refreshControl.endRefreshing()
    }

    func sendProductAllAPI() {
        StripeAPI.Product.all { [weak self] result in
            switch result {
            case .success(let response):
                self?.products = response.data
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ProductsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productDetailVC = ProductDetailViewController.instantiate()
        productDetailVC.product = products[indexPath.row]
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
}

extension ProductsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = products[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = product.name
        cell.detailTextLabel?.text = product.description
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
}
