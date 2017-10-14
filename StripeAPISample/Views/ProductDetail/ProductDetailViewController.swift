//
//  ProductDetailViewController.swift
//  StripeAPISample
//
//  Created by kensuke-hoshikawa on 2017/10/13.
//  Copyright © 2017年 kensuke-hoshikawa. All rights reserved.
//

import UIKit

final class ProductDetailViewController: UIViewController, Storyboardable {
    var product: StripeAPI.Entity.Product!

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = product.name
        productNameLabel.text = product.name
        captionLabel.text = product.caption
        descriptionLabel.text = product.description
        idLabel.text = product.id

        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ProductDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        let sku = product.skus.data[indexPath.row]
        let skuVC = SKUTableViewController.instantiate()
        skuVC.product = product
        skuVC.sku = sku
        navigationController?.pushViewController(skuVC, animated: true)
    }
}

extension ProductDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "SKUs"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let sku = product.skus.data[indexPath.row]
        cell.textLabel?.text = sku.attributes.description
        var detailText = "\(sku.price)円"
        switch sku.inventory.type {
        case .bucket:
            if let value = sku.inventory.value{
                detailText += " / Bucket: \(value)"
            }
        case .finite:
            if let quantity = sku.inventory.quantity{
                detailText += " / 在庫数: \(quantity)"
            }
        case .infinite:
            detailText += " / 在庫無限"
        }
        cell.detailTextLabel?.text = detailText
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product.skus.data.count
    }
}
