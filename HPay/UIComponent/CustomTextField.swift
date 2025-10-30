import SwiftUI

struct CustomCardTextField: View {
    var title: String
    @Binding var text: String
    var placeholder: String
    var maxLength: Int? = nil
    var showSuffix: Bool = false
    var suffixText: String = ""
    var isInvalid: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color("HPay-DarkGray"))

            HStack {
                TextField("", text: $text)
                    .keyboardType(.numberPad)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                    .overlay(
                        HStack {
                            if text.isEmpty {
                                HStack(spacing: 8) {
                                    Text(placeholder)
                                        .foregroundColor(.gray)
                                        .font(.system(size: 20, weight: .light))
                                    Spacer()
                                    if showSuffix {
                                        Text(suffixText)
                                            .foregroundColor(.gray)
                                            .font(.system(size: 20, weight: .light))
                                    }
                                }
                            }
                            Spacer()
                        }
                            .allowsHitTesting(false)
                    )
                    .onChange(of: text) { newValue in
                        if let max = maxLength, newValue.count > max {
                            text = String(newValue.prefix(max))
                        }
                    }

                if showSuffix {
                    Text(suffixText)
                        .font(.system(size: 20, weight: .light))
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                }
            }
            .padding()
            .frame(height: 52)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        isInvalid ? Color.red : Color("HPay-LightGray"),
                        lineWidth: 2
                    )
            )
        }
        .padding(.horizontal)
    }
}

#Preview {
    CustomCardTextField(
        title: "Card Number",
        text: .constant(""),
        placeholder: "4242 4242 4242 4242",
        maxLength: 16,
        showSuffix: false
    )
}
