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
    var customerContext: STPCustomerContext!
    var paymentContext: STPPaymentContext!

    @IBOutlet weak var skuLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var ShippingLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var buLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = product.name
        skuLabel.text = sku.attributes.description
        priceLabel.text = "\(sku.price)円"

        customerContext = STPCustomerContext(keyProvider: MyAPI.shared)
        let paymentContext = STPPaymentContext(customerContext: customerContext,
                                               configuration: STPPaymentConfiguration.shared(),
                                               theme: .default())
        let userInformation = STPUserInformation()
        paymentContext.prefilledInformation = userInformation
        paymentContext.paymentAmount = sku.price
        paymentContext.paymentCurrency = sku.currency.rawValue
        self.paymentContext = paymentContext
        self.paymentContext.delegate = self
        paymentContext.hostViewController = self
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [1, 0]:
            paymentContext.pushPaymentMethodsViewController()
        case [1, 1]:
            paymentContext.pushShippingViewController()
        case [2, 0]:
            buLabel.text = "Loading"
            paymentContext.requestPayment()
        default:
            break
        }
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
        debugPrint(paymentContext)
        paymentLabel.text = "Loading"
        if let paymentMethod = paymentContext.selectedPaymentMethod {
            paymentLabel.text = paymentMethod.label
        } else {
            paymentLabel.text = "Select Payment"
        }

        if let shippingMethod = paymentContext.selectedShippingMethod {
            ShippingLabel.text = shippingMethod.label
        } else {
            ShippingLabel.text = "Enter Shipping Info"
        }

        totalLabel.text = "\(paymentContext.paymentAmount)"
    }

    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        buLabel.text = "Buy"
        let title: String
        let message: String
        switch status {
        case .error:
            title = "Error"
            message = error?.localizedDescription ?? ""
        case .success:
            title = "Success"
            message = "You bought a \(self.product.name)!"
        case .userCancellation:
            return
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
//        MyAPI.Charge.create(result: paymentResult,
//                            amount: paymentContext.paymentAmount,
//                            shippingAddress: paymentContext.shippingAddress, shippingMethod: paymentContext.selectedShippingMethod) { result in
//                                switch result {
//                                case .success:
//                                    completion(nil)
//                                case .failure(let error):
//                                    completion(error)
//                                }
//        }

        customerContext.retrieveCustomer { [weak self] success, error in
            guard let strongSelf = self else { return }
            if let error = error {
                completion(error)
                return
            }

            let items = Items(amount: paymentContext.paymentAmount,
                              currency: strongSelf.sku.currency,
                              description: nil,
                              parent: self?.sku.id,
                              quantity: 1,
                              type: "sku")
            // 本当はサーバ側でやる
            let request = StripeAPI.Order.Request.create(currency: strongSelf.sku.currency,
                                                         customer: success?.stripeID,
                                                         email: nil,
                                                         items: items,
                                                         metadata: nil)
            StripeSession.shared.send(request) { result in
                switch result {
                case .success:
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
        }
    }

    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
        let upsGround = PKShippingMethod()
        upsGround.amount = 0
        upsGround.label = "UPS Ground"
        upsGround.detail = "Arrives in 3-5 days"
        upsGround.identifier = "ups_ground"
        let upsWorldwide = PKShippingMethod()
        upsWorldwide.amount = 10.99
        upsWorldwide.label = "UPS Worldwide Express"
        upsWorldwide.detail = "Arrives in 1-3 days"
        upsWorldwide.identifier = "ups_worldwide"
        let fedEx = PKShippingMethod()
        fedEx.amount = 5.99
        fedEx.label = "FedEx"
        fedEx.detail = "Arrives tomorrow"
        fedEx.identifier = "fedex"

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if address.country == nil || address.country == "US" {
                completion(.valid, nil, [upsGround, fedEx], fedEx)
            }
            else if address.country == "AQ" {
                let error = NSError(domain: "ShippingError", code: 123, userInfo: [NSLocalizedDescriptionKey: "Invalid Shipping Address",
                                        NSLocalizedFailureReasonErrorKey: "We can't ship to this country."])
                completion(.invalid, error, nil, nil)
            }
            else {
                fedEx.amount = 20.99
                completion(.valid, nil, [upsWorldwide, fedEx], fedEx)
            }
        }
    }
}
