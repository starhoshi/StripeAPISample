//
//  ProductDetailViewController.swift
//  StripeAPISample
//
//  Created by kensuke-hoshikawa on 2017/10/13.
//  Copyright © 2017年 kensuke-hoshikawa. All rights reserved.
//

import UIKit

final class ProductDetailViewController: UITableViewController, Storyboardable {
    var product: StripeAPI.Entity.Product!

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = product.name
        productNameLabel.text = product.name
        captionLabel.text = product.caption
        descriptionLabel.text = product.description

    }
}
