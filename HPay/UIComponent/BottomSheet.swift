//
//  BottomSheet.swift
//  HPay
//
//  Created by Shatha Almukhaild on 08/05/1447 AH.
//

import Foundation
import SwiftUI
// Reusable bottom sheet modifier
struct BottomSheet<SheetContent: View>: ViewModifier {
    var title: String  //  title parameter
    @Binding var isPresented: Bool
    @ViewBuilder let sheetContent: () -> SheetContent
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                // Dimmed background
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.35)) {
                            isPresented = false
                        }
                    }
                
                // Bottom sheet
                VStack(spacing: 0) {
                    Spacer()
                    
                    VStack(spacing: 0) {
                        // Header with close button
                        HStack {
                            Text(title)
                                .font(.system(size: 24, weight: .bold))
                                .padding(.leading)
                            Spacer()
                            Button {
                                withAnimation(.spring(response: 0.35)) {
                                    isPresented = false
                                }
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.black)
                                    .frame(width: 30, height: 30)
                            }
                            .padding()
                        }
                        
                        // Content
                        sheetContent()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                }
                .ignoresSafeArea(edges: .bottom)
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: isPresented)
    }
}

// Extension for easy use
extension View {
    func bottomSheet<Content: View>(
        title: String,
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(BottomSheet(title: title, isPresented: isPresented ,sheetContent: content))
    }
}

// Helper for specific corner radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
