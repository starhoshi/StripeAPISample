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
    var paymentContext: STPPaymentContext!

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
        let paymentContext = STPPaymentContext(customerContext: customerContext,
                                               configuration: STPPaymentConfiguration.shared(),
                                               theme: .default())
        let userInformation = STPUserInformation()
        paymentContext.prefilledInformation = userInformation
        paymentContext.paymentAmount = sku.price
        paymentContext.paymentCurrency = sku.currency
        self.paymentContext = paymentContext
    }
}

// MARK: STPPaymentContextDelegate

extension SKUTableViewController: STPPaymentContextDelegate {
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        let alertController = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            // Need to assign to _ because optional binding loses @discardableResult value
            // https://bugs.swift.org/browse/SR-1681
            _ = self.navigationController?.popViewController(animated: true)
        })
        let retry = UIAlertAction(title: "Retry", style: .default, handler: { action in
            self.paymentContext.retryLoading()
        })
        alertController.addAction(cancel)
        alertController.addAction(retry)
        self.present(alertController, animated: true, completion: nil)
    }

    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        print(paymentContext)
    }

    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        let title: String
        let message: String
        switch status {
        case .error:
            title = "Error"
            message = error?.localizedDescription ?? ""
        case .success:
            title = "Success"
            message = "You bought a \(self.product)!"
        case .userCancellation:
            return
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        completion(nil) // サーバでの決済が完了した
    }
}
