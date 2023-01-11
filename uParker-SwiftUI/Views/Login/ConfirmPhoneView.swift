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
                Text("A confirmation code has been sent to:")
                    .font(.footnote)
                    .fontDesign(.rounded)
                
                Text(phoneNumber)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
            }
            .padding(.vertical)
            
            
            TextField("", text: $code)
                .foregroundColor(.accentColor)
                .font(.title)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
                .tracking(25)
                .padding()
                .frame(width: 275, height: 60)
                .keyboardType(.numberPad)
                .focused($focusField, equals: .confirmationCode)
                .submitLabel(.continue)
//                .onChange(of: code, perform: {
//                    phoneNumber = String($0.prefix(14)).applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
//                })
                .onSubmit {
                    focusField = nil
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.accentColor, lineWidth: 2)
                )
                .overlay(
                    HStack(spacing: 21) {
                        ForEach(0 ..< 6) { charIndex in
                            if code.count <= charIndex {
                                Rectangle()
                                    .frame(width: 22, height: 3)
                            } else {
                                Spacer()
                                    .frame(width: 25, height: 3)
                            }
                        }
                    }
                    .foregroundColor(.accentColor)
                    .opacity(0.7)
                    .frame(maxWidth: .infinity)
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
