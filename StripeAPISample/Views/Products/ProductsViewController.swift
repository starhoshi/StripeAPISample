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
        print(indexPath)
    }
}

extension ProductsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sku = products[indexPath.section].skus.data[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = sku.attributes.description
        switch sku.inventory.type {
        case .finite:
            if let quantity = sku.inventory.quantity {
                cell.detailTextLabel?.text = "在庫: \(quantity)"
            }
        case .infinite:
            cell.detailTextLabel?.text = "在庫無限"
        case .bucket:
            if let value = sku.inventory.value {
                cell.detailTextLabel?.text = "Bucket: \(value.rawValue)"
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products[section].skus.data.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return products[section].name
    }
}
