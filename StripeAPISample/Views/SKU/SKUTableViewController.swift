//
//  SKUTableViewController.swift
//  StripeAPISample
//
//  Created by kensuke-hoshikawa on 2017/10/14.
//  Copyright © 2017年 kensuke-hoshikawa. All rights reserved.
//

import UIKit
import Stripe

final class SKUTableViewController: UITableViewController, Storyboardable {
    var product: StripeAPI.Entity.Product!
    var sku: StripeAPI.Entity.SKU!

    @IBOutlet weak var skuLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var ShippingLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = product.name
        skuLabel.text = sku.attributes.description
        priceLabel.text = "\(sku.price)円"

        let customerContext = STPCustomerContext(keyProvider: StripeCustomerKeyAPI.shared)

    }
}
