//
//  WalletView.swift
//  HPay
//
//  Created by Shatha Almukhaild on 07/05/1447 AH.
//

import SwiftUI
import StripePaymentSheet

// Navigation path
// Declaring views paths
enum Route: Hashable  {
    case Card
    case Transaction
}


struct WalletView: View {
    // to navigate through views using path
    @State private var path = NavigationPath()
    // to show sheet when called
    @State private var showTransactionSheet: Bool = false
    @State private var showPaymentSheet: Bool = false
    @State private var selectedOption: String = "Online Payment"
    @State private var amount: String = ""
    @State private var inputString: String = ""
    @State private var walletBalance: Double = 1000.00

    // max amount to top- up
    let maxNumber = 1000
    @StateObject private var stripe = StripePaymentHandler()
    //mockup latest transaction
    @State private var transactions: [TransactionModel] = [
        TransactionModel(title: "Wallet Top-up", date: "Oct 30, 2025", amount: "+60 SR", type: .credit),
        TransactionModel(title: "PrimeCut", date: "Oct 29, 2025", amount: "-70 SR", type: .debit),
        TransactionModel(title: "Macdonald", date: "Oct 28, 2025", amount: "-30 SR", type: .debit)
    ]

    var body: some View {
        NavigationStack(path : $path) {
            
            ZStack {
                Color.gray
                    .opacity(0.1)
                    .ignoresSafeArea()
                
               
                VStack{
                    Spacer().frame(height: 50) // pushes the card lower

                    
                    
                    ZStack{
                        
                        Image("HPayCard").resizable()
                            .frame(width: 350,height: 220)
                            .padding()
                        
                        HStack{
                            VStack(alignment: .leading, spacing: 80) {
                                Text("Wallet")
                                    .font(.system(size: 18, weight: .bold))
                                    .frame(width:105, alignment: .trailing)
                                    .padding(.top, 20)
                                   
                
                                
                                VStack(alignment: .leading){
                                    Text("Total")
                                        .font(.system(size: 16, weight: .light))
                                        .frame(width: 90, alignment: .trailing)
                                        

                                    
                                    HStack(spacing: 4) {
                                        Image("Riyal")
                                            .resizable()
                                            .frame(width: 25, height: 24) .frame(minWidth:80, alignment: .trailing)
                                        Text(String(format: "%.2f", walletBalance))
                                            .font(.system(size: 32, weight: .bold))
                                           
                                    }
                                    .frame(minWidth: 120, alignment: .leading)
                       
                                    .padding(.bottom, 20)
                                }
                            }
                            .foregroundStyle(Color.white)
                            Spacer()
                        }
                    }//End of ZStack
                    
                    
                    HStack{
                        Spacer()
                        Spacer()
                        Spacer()
                        VStack{
                            Button(action:{
                                showPaymentSheet = true // show payment sheet
                            }){
                                ZStack{
                                    
                                    Circle().fill(Color.white).frame(width: 65,height: 65)
                                    Image("empty-wallet-add").resizable().frame(width: 30,height: 30)
                                }//End of ZStack
                            }//End of Button
                            Text("Top-up").font(.system(size:18, weight: .light))
                        }//End of VStack
                        Spacer()
                        VStack{
                            
                            Button(action:{
                                path.append(Route.Card)
                            }){
                                ZStack{
                                    Circle().fill(Color.white).frame(width: 65,height: 65)
                                    Image("card").resizable().frame(width: 30,height: 30)
                                }//End of ZStack
                            }//End of button
                            Text("Cards").font(.system(size:18, weight: .light))
                        }//End of VStack
                        Spacer()
                        Spacer()
                        Spacer()
                    }//End of HStack
                    
                    Spacer()
                    Spacer()
                  //  Spacer()
                    ZStack{
                        // MARK: - Latest Transactions Preview
                        Spacer()
                        VStack(alignment: .leading, spacing: 12) {
                            Spacer()
                            HStack {
                                
                                Text("Transactions")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundStyle(Color.black)
                                Spacer()
                                Button("View All") {
                                    path.append(Route.Transaction)
                                }
                                .foregroundColor(.blue)
                                .bold()
                            }
                            .padding(.horizontal)
                            .padding(.top, 8)
                            .padding()
                        //Spacer()
                            // Show last 3 transactions
                            ForEach(transactions.prefix(3)) { tx in
                                HStack(spacing: 16) {
                                    ZStack {
                                        Circle()
                                            .fill(tx.type == .credit ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
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
                                .padding()
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
                                .padding(.horizontal)
                            }
                            Spacer()
                            Spacer()
                        }
                        .padding(.bottom, 24)

                        
                    }.frame(maxWidth: .infinity) // Makes the VStack expand horizontally
                        .background(Color.white)
                        .cornerRadius(30)
                        .ignoresSafeArea()
                    //End of ZStack
                }//End of VStack
                
                
             
                
            }
            .onAppear {
                stripe.preparePaymentSheet()
            }
            .alert(stripe.alertText, isPresented: $stripe.showingAlert) {
                Button("OK", role: .cancel) {}
            }
                .navigationTitle("HPay")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .Card:
                        CardView(path : $path)
                    case .Transaction:
                        TransactionView(path : $path)
                    }
                }
                .bottomSheet(title: "Top-up", isPresented: $showPaymentSheet){
                   
                    VStack{
                    
                    HStack(alignment: .top, spacing:20){
                       
                        Text("Payment method ").font(.system(size:20, weight: .bold))
                            .foregroundStyle(Color("HPay-DarkGray")).padding(.leading)
                        Spacer()
                    }
                      //  Spacer()
                        RadioButton(
                            isSelected: selectedOption == "Online Payment",
                                      label: "Online Payment"
                                  ) {
                                    selectedOption = "Online Payment"
                                  }.padding()
                        HStack {
                            VStack { Divider() } // Forces the divider to be horizontal
                            Text("Or")
                                .padding(.horizontal)
                            VStack { Divider() } // Forces the divider to be horizontal
                        }.padding()
                        RadioButton(
                            isSelected: selectedOption == "mokafaa Points",
                                      label: "mokafaa Points"
                                  ) {
                                  
                                    selectedOption = "mokafaa Points"
                                  }.padding()
                        
                        HStack(alignment: .top, spacing:20){
                            
                            Text("Top-up Amount ").font(.system(size:20, weight: .bold))
                                .foregroundStyle(Color("HPay-DarkGray")).padding(.leading)
                            Spacer()
                        }
                        HStack{
                            
                            SmallRadioButton(
                                isSelected: amount == "30 SR",
                                          label: "30 SR"
                                      ) {
                                          amount = "30 SR"
                                      }
                            SmallRadioButton(
                                isSelected: amount == "60 SR",
                                          label: "60 SR"
                                      ) {
                                          amount = "60 SR"
                                      }
                            SmallRadioButton(
                                isSelected: amount == "120 SR",
                                          label: "120 SR"
                                      ) {
                                          amount = "120 SR"
                                      }
                            SmallRadioButton(
                                isSelected: amount == "Other",
                                          label: "Other"
                                      ) {
                                          amount = "Other"
                                      }

                        }.padding()
                            // Amount TextField
                        if amount == "Other" {
                            HStack {
                                TextField("", text: $inputString)
                                    .keyboardType(.numberPad)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.primary)
                                    .overlay(
                                        HStack {
                                            if inputString.isEmpty {
                                                HStack(spacing: 8) {
                                                    Text("Top-up Amount")
                                                        .foregroundColor(.gray)
                                                        .font(.system(size: 20, weight: .light))
                                                    
                                                    Spacer()
                                                    
                                                    Text("SR")
                                                        .foregroundColor(.gray)
                                                        .font(.system(size: 20, weight: .light))
                                                }
                                            }
                                            Spacer()
                                        }
                                            .allowsHitTesting(false)
                                    )
                            }
                            .padding()
                            .frame(height: 52)
                            
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        (Int(inputString) ?? 0) > maxNumber ? Color.red : Color("HPay-LightGray"),
                                        lineWidth: 2
                                    )
                            )
                            .padding() // ✅ Add this to match RadioButton padding
                            
                            
                            .onChange(of: inputString) { newValue in
                                // Remove any non-numeric characters
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                
                                // Update to filtered value (whether it's a valid number or empty)
                                inputString = filtered
                                
                                
                            }
                        }
                        
                        // Show error message when exceeding 1000
                        if let number = Int(inputString), number > 1000 {
                            Text("Maximum amount is 1000 SR")
                                .foregroundColor(.red)
                                .font(.system(size: 14))
                                .padding(.leading)
                        }
                        else{
                            Text("Maximum: 1000 SR")
                                .foregroundColor(Color("HPay-DarkGray"))
                                .font(.system(size: 14,weight: .light))
                                .padding(.leading)
                        }
                        
                        
                            
                     
                        // MARK: - Continue / Pay Button Section
                        Group {
                            if selectedOption == "Online Payment" {
                                // If PaymentSheet is ready, show Stripe button
                                if let paymentSheet = stripe.paymentSheet {
                                    PaymentSheet.PaymentButton(
                                        paymentSheet: paymentSheet,
                                        onCompletion: { result in
                                            switch result {
                                            case .completed:
                                                // ✅ Show success alert via Stripe handler (fixed signature)
                                                stripe.onPaymentCompletion(result: result)
                                                
                                                // ✅ Update wallet balance after payment success
                                                var addedAmount: Double = 0
                                                if amount == "30 SR" { addedAmount = 30 }
                                                else if amount == "60 SR" { addedAmount = 60 }
                                                else if amount == "120 SR" { addedAmount = 120 }
                                                else if let custom = Double(inputString) {
                                                    addedAmount = custom
                                                }

                                                withAnimation {
                                                    walletBalance += addedAmount
                                                }

                                            default:
                                                // Handle canceled or failed cases via Stripe handler
                                                stripe.onPaymentCompletion(result: result)

                                            }
                                        }
                                    ) {
                                        Text("Continue")
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                    }
                                    .buttonStyle(YellowButton())
                                    .padding()
                                    .padding(.bottom, 24)
                                }
                                // If PaymentSheet isn't ready, show a loading or setup button
                                else {
                                    if stripe.clientSecret.isEmpty {
                                        // Stripe not ready yet
                                        Button {
                                            print("⏳ Stripe setup not ready yet.")
                                        } label: {
                                            Text("Continue")
                                                .frame(maxWidth: .infinity)
                                                .padding()
                                        }
                                        .buttonStyle(YellowButton())
                                        .disabled(true)
                                        .padding()
                                        .padding(.bottom, 24)
                                    } else {
                                        // Stripe ready — user pressed Continue to prepare payment sheet
                                        Button {
                                            var amountToCharge = 0
                                            if amount == "30 SR" { amountToCharge = 3000 }   // 30 × 100
                                            else if amount == "60 SR" { amountToCharge = 6000 }
                                            else if amount == "120 SR" { amountToCharge = 12000 }
                                            else { amountToCharge = (Int(inputString) ?? 0) * 100 }

                                            if amountToCharge > 0 {
                                                print("⚡️ Setting up Stripe for amount:", amountToCharge)
                                                stripe.updatePaymentSheet(with: amountToCharge)
                                            } else {
                                                print("⚠️ Invalid amount to charge.")
                                            }
                                        } label: {
                                            Text("Continue")
                                                .frame(maxWidth: .infinity)
                                                .padding()
                                        }
                                        .buttonStyle(YellowButton())
                                        .padding()
                                        .padding(.bottom, 24)
                                    }
                                }
                            }
                            // MARK: - Mokafaa Points Fallback
                            else {
                                Button {
                                    // 🏅 Handle Mokafaa points payment flow
                                    print("🏅 Using mokafaa points flow")
                                } label: {
                                    Text("Continue")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                }
                                .buttonStyle(YellowButton())
                                .padding()
                                .padding(.bottom, 24)
                            }
                        }




                   
                        
                        
                    }
                    
                   
                }
               
                .sheet(isPresented: $showTransactionSheet){
                  
                }
              
             //End of ZStack
            
            
            
            
        }// End of NavigationStack
       
    }//End of body
}//End of struct

#Preview {
    WalletView()
}
