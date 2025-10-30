//
//  AddCardView.swift
//  HPay
//
//  Created by Shatha Almukhaild on 08/05/1447 AH.
//

import SwiftUI

import Stripe

struct AddCardView: UIViewRepresentable {
    @Binding var cardParams: STPPaymentMethodCardParams

    func makeUIView(context: Context) -> STPPaymentCardTextField {
        let cardField = STPPaymentCardTextField()
        cardField.delegate = context.coordinator
        return cardField
    }

    func updateUIView(_ uiView: STPPaymentCardTextField, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(cardParams: $cardParams)
    }

    class Coordinator: NSObject, STPPaymentCardTextFieldDelegate {
        @Binding var cardParams: STPPaymentMethodCardParams

        init(cardParams: Binding<STPPaymentMethodCardParams>) {
            _cardParams = cardParams
        }

        func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
            cardParams.number = textField.cardNumber
            cardParams.expMonth = NSNumber(value: Int(textField.formattedExpirationMonth ?? "") ?? 0)
            cardParams.expYear = NSNumber(value: Int(textField.formattedExpirationYear ?? "") ?? 0)
            cardParams.cvc = textField.cvc
        }
    }
}


