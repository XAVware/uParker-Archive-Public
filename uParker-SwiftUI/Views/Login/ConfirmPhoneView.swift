//
//  ConfirmPhoneView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 1/10/23.
//

import SwiftUI

struct ConfirmPhoneView: View {
    // MARK: - PROPERTIES
    @Environment(\.dismiss) var dismiss
    @State var phoneNumber: String
    @State var code: String = ""
    @FocusState private var focusField: FocusText?
    private let haptic = UIImpactFeedbackGenerator(style: .medium)
    enum FocusText { case confirmationCode }
    // MARK: - BODY
    var body: some View {
        VStack() {
            HeaderView(leftItem: .chevron, title: "Confirm Phone", rightItem: nil)
                .padding(.bottom)
            
            VStack(spacing: 5) {
                Text("A 6-digit confirmation code has been sent to:")
                    .font(.footnote)
                    .fontDesign(.rounded)
                
                Text(phoneNumber)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
            }
            .padding(.vertical)
            
            
            TextField("", text: $code)
                .multilineTextAlignment(.center)
                .frame(width: 275, height: 60)
                .foregroundColor(.accentColor)
                .font(.title)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
                .tracking(25)
                .keyboardType(.numberPad)
                .focused($focusField, equals: .confirmationCode)
                .submitLabel(.continue)
                .onChange(of: code, perform: {
                    code = String($0.prefix(6))
                })
                .onSubmit {
                    focusField = nil
                }
                .overlay(
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.accentColor, lineWidth: 2)
                        
                        if code.isEmpty {
                            Text("6-Digit Code")
                                .font(.title)
                                .fontWeight(.semibold)
                                .fontDesign(.rounded)
                                .foregroundColor(.accentColor)
                                .opacity(0.3)
                                .frame(maxWidth: .infinity)
                        }
                    } //: ZStack
                    .onTapGesture {
                        focusField = .confirmationCode
                    }
                )
            
            Spacer()
        } //: VStack
        .padding()
        .onAppear {
            focusField = .confirmationCode
        }
    }
}

// MARK: - PREVIEW
struct ConfirmPhoneView_Previews: PreviewProvider {
    @State static var phoneNumber = "(123) 456-7894"
    static var previews: some View {
        ConfirmPhoneView(phoneNumber: phoneNumber)
    }
}
