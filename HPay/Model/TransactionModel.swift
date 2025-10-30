//
//  TransactionModel.swift
//  HPay
//
//  Created by Shatha Almukhaild on 08/05/1447 AH.
//

import Foundation
struct TransactionModel: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let date: String
    let amount: String
    let type: TransactionType
}

enum TransactionType {
    case credit, debit
}
