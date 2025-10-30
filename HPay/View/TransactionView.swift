//
//  TransactionView.swift
//  HPay
//
//  Created by Shatha Almukhaild on 07/05/1447 AH.
//

import SwiftUI

//
//  TransactionView.swift
//  HPay
//
//  Created by Shatha Almukhaild on 30/10/2025.
//

import SwiftUI

struct TransactionView: View {
    @Binding var path: NavigationPath


    // Mock data
    let transactions: [TransactionModel] = [
        .init(title: "Wallet Top-up", date: "Oct 30, 2025 • 11:42 AM", amount: "+60 SR", type: .credit),
        .init(title: "Order #243", date: "Oct 29, 2025 • 09:10 PM", amount: "-45 SR", type: .debit),
        .init(title: "Order #242", date: "Oct 28, 2025 • 07:28 PM", amount: "-30 SR", type: .debit),
        .init(title: "Refund", date: "Oct 27, 2025 • 05:15 PM", amount: "+30 SR", type: .credit),
        .init(title: "Wallet Top-up", date: "Oct 30, 2025 • 11:42 AM", amount: "+60 SR", type: .credit),
        .init(title: "Order #243", date: "Oct 29, 2025 • 09:10 PM", amount: "-45 SR", type: .debit),
        .init(title: "Order #242", date: "Oct 28, 2025 • 07:28 PM", amount: "-30 SR", type: .debit),
        .init(title: "Refund", date: "Oct 27, 2025 • 05:15 PM", amount: "+30 SR", type: .credit)
    ]
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Latest Transactions")
                    .font(.title3.bold())
                    .padding(.top)
                    .padding(.horizontal)
                
                List(transactions) { tx in
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(tx.type == .credit ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                                .frame(width: 44, height: 44)
                            Image(systemName: tx.type == .credit ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                                .foregroundColor(tx.type == .credit ? .green : .red)
                                .font(.title3)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(tx.title)
                                .font(.system(size: 16, weight: .semibold))
                            Text(tx.date)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text(tx.amount)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(tx.type == .credit ? .green : .red)
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(.insetGrouped) //  Rounded corners style
            
            }
        }
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        TransactionView(path: .constant(NavigationPath()))
    }
}


