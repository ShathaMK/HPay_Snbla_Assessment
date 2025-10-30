//
//  StripePaymentHandler.swift
//  HPay
//
//  Created by Shatha Almukhaild on 08/05/1447 AH.
//

import Foundation
import StripePaymentSheet

final class StripePaymentHandler: ObservableObject {

    // MARK: - Properties
    private let backendURL = URL(string: "http://127.0.0.1:4242")! // for simulator only 
    @Published var paymentSheet: PaymentSheet?
    @Published var showingAlert = false
    @Published var alertText = ""

    private(set) var configuration = PaymentSheet.Configuration()
    private(set) var clientSecret = ""
    private(set) var paymentIntentID = ""

    // MARK: - Prepare Payment Sheet (creates a PaymentIntent on the backend)
    func preparePaymentSheet() {
        print("🛰️ Preparing payment sheet...")

        var request = URLRequest(url: backendURL.appendingPathComponent("prepare-payment-sheet"))
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            if let error = error {
                print("❌ prepare-payment-sheet error:", error.localizedDescription)
                return
            }

            guard
                let self,
                let data,
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let customerId = json["customer"] as? String,
                let ephKey = json["ephemeralKey"] as? String,
                let clientSecret = json["clientSecret"] as? String,
                let paymentIntentID = json["paymentIntentID"] as? String,
                let publishableKey = json["publishableKey"] as? String
            else {
                print("❌ Failed to decode prepare-payment-sheet response.")
                return
            }

            print("✅ Received PaymentIntent:", paymentIntentID)

            DispatchQueue.main.async {
                STPAPIClient.shared.publishableKey = publishableKey
                self.clientSecret = clientSecret
                self.paymentIntentID = paymentIntentID

                var config = PaymentSheet.Configuration()
                config.merchantDisplayName = "HPay Wallet"
                config.customer = .init(id: customerId, ephemeralKeySecret: ephKey)
                config.allowsDelayedPaymentMethods = true
                config.returnURL = "hpay://stripe-redirect"

                self.configuration = config
                print("✅ PaymentSheet configuration ready.")
            }
        }.resume()
    }

    // MARK: - Update Payment Sheet with new custom amount
    func updatePaymentSheet(with amount: Int) {
        guard !paymentIntentID.isEmpty else {
            print("⚠️ PaymentIntent ID not ready yet. Call preparePaymentSheet() first.")
            return
        }

        print("🛰️ Updating payment intent \(paymentIntentID) to amount \(amount)")

        let body: [String: Any] = [
            "paymentIntentID": paymentIntentID,
            "amount": amount
        ]

        var request = URLRequest(url: backendURL.appendingPathComponent("update-payment-sheet"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let self = self else { return }

            if let error = error {
                print("❌ update-payment-sheet error:", error.localizedDescription)
                return
            }

            if let data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               json["ok"] as? Bool == true {
                DispatchQueue.main.async {
                    print("✅ PaymentIntent updated successfully — creating PaymentSheet.")
                    self.paymentSheet = PaymentSheet(
                        paymentIntentClientSecret: self.clientSecret,
                        configuration: self.configuration
                    )
                }
            } else {
                print("⚠️ Failed to update PaymentIntent.")
            }
        }.resume()
    }

    // MARK: - Handle completion result
    @MainActor
    func onPaymentCompletion(result: PaymentSheetResult) {
        switch result {
        case .completed:
            alertText = "✅ Payment complete!"
        case .canceled:
            alertText = "❌ Payment canceled"
        case .failed(let error):
            alertText = "⚠️ Payment failed: \(error.localizedDescription)"
        }
        showingAlert = true
    }


}
