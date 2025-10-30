//
//  ButtonStyle.swift
//  HPay
//
//  Created by Shatha Almukhaild on 08/05/1447 AH.
//

import Foundation
import SwiftUI


/// Primary button style with a pressed effect.
struct YellowButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Color("HPay-Yellow")
            configuration.label
                .font(.system( size: 20, weight: .bold ,design: .default))
                .foregroundColor(.black)
        }
        .frame(height: 52)
        .cornerRadius(8)
        .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        .opacity(configuration.isPressed ? 0.8 : 1.0)
        .animation(.easeInOut, value: configuration.isPressed)
    }
}


/// Secondary button style with a pressed effect.
struct OutlinedGrayButton: ButtonStyle {
    var borderWidth: CGFloat = 2 // to control the thickness of the border
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 20, weight: .light))
            .foregroundColor(Color("HPay-DarkGray")) // Text color
            .frame(height: 52)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color("HPay-LightGray"), lineWidth: borderWidth) // Gray outline
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}





/// Third button style with a pressed effect.
struct GrayButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Color("HPay-LightGray")
            configuration.label
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.gray)
        }
        .frame(height: 52)
        .cornerRadius(8)
        .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        .opacity(configuration.isPressed ? 0.8 : 1.0)
        .animation(.easeInOut, value: configuration.isPressed)
    }
}

/// Radio Button
struct RadioButton: View {
    let isSelected: Bool
    let label: String
    let action: () -> Void
    var borderWidth: CGFloat = 2 // You can control the thickness here

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Radio circle
                ZStack {
                    Circle()
                        .stroke(Color.gray, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(Color("HPay-DarkGray"))
                            .frame(width: 12, height: 12)
                    }
                }
                
                Text(label)
                    .font(.system(size: 20))
                    .foregroundColor(Color("HPay-DarkGray"))
                
                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color("HPay-LightGray"), lineWidth: borderWidth) // Gray outline
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
/// Radio Button
struct SmallRadioButton: View {
    let isSelected: Bool
    let label: String
    let action: () -> Void
    var borderWidth: CGFloat = 2 // You can control the thickness here

    var body: some View {
        Button(action: action) {
            Text(label)
                .padding()
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(isSelected ? .black : .gray)
                .frame(width: 85, height: 40)
                .background(isSelected ? Color("HPay-Yellow") : Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Color.clear : Color("HPay-LightGray"), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 8)) // ✅ consistent rounding
        }
        .buttonStyle(.plain)

    }
}

// Usage
struct Buttons: View {
    @State private var selectedOption: String = "Option 1"
    @State private var amount: String = "amount SR "


    var body: some View {
        
        Button("Yellow Button") {
            
        }.buttonStyle(YellowButton()).padding()
        
        Button("Outlined Gray Button") {
            
        }.buttonStyle(OutlinedGrayButton()).padding()
        
        Button("Gray Button") {
            
        }.buttonStyle(GrayButton()).padding()
        
        RadioButton(
            isSelected: selectedOption == "Option 1",
                      label: "Option 1"
                  ) {
                    selectedOption = "Option 1"
                  }.padding()
        
        SmallRadioButton(
            isSelected: amount == "amount SR",
                      label: "amount SR"
                  ) {
                      amount = "amount SR"
                  }.padding()
    }
    
}



#Preview {
    Buttons()
}
