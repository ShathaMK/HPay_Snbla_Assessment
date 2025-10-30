//
//  CardView.swift
//  HPay
//
//  Created by Shatha Almukhaild on 30/10/2025.
//

import SwiftUI

struct UserCard: Identifiable, Hashable {
    let id = UUID()
    let brand: String
    let last4: String
    let gradient: [Color]
}

struct CardView: View {
    @Binding var path: NavigationPath
    @State private var savedCards: [UserCard] = [
        UserCard(brand: "Visa", last4: "4242", gradient: [Color.blue, Color.purple]),
        UserCard(brand: "Mastercard", last4: "1234", gradient: [Color.orange, Color.red])
    ]
    
    @State private var cardNumber = ""
    @State private var expDate = ""
    @State private var cvc = ""
    
    // Validation flags
    @State private var isCardValid = false
    @State private var isExpiryValid = false
    @State private var isCVCValid = false

    var body: some View {
        ZStack {
            Color.gray
                .opacity(0.1)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    
                    // MARK: - Saved Cards
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Saved Cards")
                            .font(.title3.bold())
                            .padding(.leading)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(savedCards) { card in
                                    ZStack(alignment: .topLeading) {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(LinearGradient(colors: card.gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                                            .frame(width: 300, height: 180)
                                            .shadow(radius: 5)
                                        
                                        VStack(alignment: .leading, spacing: 20) {
                                            Text(card.brand)
                                                .font(.headline)
                                                .foregroundColor(.white.opacity(0.9))
                                            
                                            Spacer()
                                            
                                            Text("•••• \(card.last4)")
                                                .font(.title3.bold())
                                                .foregroundColor(.white)
                                        }
                                        .padding(24)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 20)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    // MARK: - Add New Card
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Add New Card")
                            .font(.title3.bold())
                            .padding(.leading)
                        
                        VStack(spacing: 16) {
                            CustomCardTextField(
                                title: "Card Number",
                                text: $cardNumber,
                                placeholder: "4242 4242 4242 4242",
                                maxLength: 19,
                                isInvalid: !(isCardValid || cardNumber.isEmpty)
                            )
                            .onChange(of: cardNumber) { newValue in
                                cardNumber = formatCardNumber(newValue)
                                isCardValid = validateCardNumber(cardNumber)
                            }

                            HStack(spacing: 16) {
                                CustomCardTextField(
                                    title: "Expiry",
                                    text: $expDate,
                                    placeholder: "MM/YY",
                                    maxLength: 5,
                                    isInvalid: !(isExpiryValid || expDate.isEmpty)
                                )
                                .onChange(of: expDate) { newValue in
                                    expDate = formatExpiry(newValue)
                                    isExpiryValid = validateExpiry(expDate)
                                }

                                CustomCardTextField(
                                    title: "CVC",
                                    text: $cvc,
                                    placeholder: "123",
                                    maxLength: 4,
                                    isInvalid: !(isCVCValid || cvc.isEmpty)
                                )
                                .onChange(of: cvc) { newValue in
                                    cvc = String(newValue.prefix(4))
                                    isCVCValid = (3...4).contains(cvc.count)
                                }
                            }
                        }
                  

                        
                        Group {
                            if isCardValid {
                                Button("Save Card") {
                                    addNewCard()
                                }
                                .buttonStyle(YellowButton())
                            } else {
                                Button("Save Card") {}
                                .buttonStyle(GrayButton())
                                .disabled(true)
                            }
                        }

                        .padding(.horizontal)
                        .padding(.top, 30)
                    }
                }
            }
        }
        .navigationTitle("My Cards")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Add Card Logic
    func addNewCard() {
        let last4 = String(cardNumber.filter(\.isNumber).suffix(4))
        let newCard = UserCard(brand: detectBrand(from: cardNumber),
                               last4: last4,
                               gradient: [Color.cyan, Color.blue])
        savedCards.append(newCard)
        cardNumber = ""
        expDate = ""
        cvc = ""
        isCardValid = false
        isExpiryValid = false
        isCVCValid = false
    }
    
    // MARK: - Helpers
    func formatCardNumber(_ input: String) -> String {
        let digits = input.filter(\.isNumber)
        var result = ""
        for (index, char) in digits.enumerated() {
            if index != 0 && index % 4 == 0 { result.append(" ") }
            result.append(char)
        }
        return String(result.prefix(19))
    }
    
    func validateCardNumber(_ number: String) -> Bool {
        let digits = number.filter(\.isNumber).compactMap { Int(String($0)) }
        guard digits.count >= 13 else { return false }
        // Luhn algorithm
        var sum = 0
        for (index, digit) in digits.reversed().enumerated() {
            if index % 2 == 1 {
                let doubled = digit * 2
                sum += (doubled > 9) ? doubled - 9 : doubled
            } else {
                sum += digit
            }
        }
        return sum % 10 == 0
    }
    
    func formatExpiry(_ input: String) -> String {
        let digits = input.filter(\.isNumber)
        if digits.count <= 2 { return digits }
        let month = digits.prefix(2)
        let year = digits.suffix(from: digits.index(digits.startIndex, offsetBy: 2))
        return "\(month)/\(year.prefix(2))"
    }
    
    func validateExpiry(_ input: String) -> Bool {
        let parts = input.split(separator: "/")
        guard parts.count == 2,
              let month = Int(parts[0]), let year = Int(parts[1]),
              (1...12).contains(month)
        else { return false }

        let currentYear = Calendar.current.component(.year, from: Date()) % 100
        let currentMonth = Calendar.current.component(.month, from: Date())
        return year > currentYear || (year == currentYear && month >= currentMonth)
    }
    
    func detectBrand(from number: String) -> String {
        let prefix = number.filter(\.isNumber).prefix(2)
        switch prefix {
        case "4": return "Visa"
        case "51"..."55": return "Mastercard"
        case "60": return "Mada"
        default: return "Card"
        }
    }
}
#Preview {
    NavigationStack {
        CardView(path: .constant(NavigationPath()))
    }
}
