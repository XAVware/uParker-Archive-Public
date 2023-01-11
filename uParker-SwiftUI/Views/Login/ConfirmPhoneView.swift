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
    @FocusState private var focusField: FocusText?
    @State var phoneNumber: String
    @State var code: String = ""
    @State var timeRemaining: Int = 0
    private let haptic = UIImpactFeedbackGenerator(style: .medium)
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    enum FocusText { case confirmationCode }
    
    
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 15) {
            HeaderView(leftItem: .chevron, title: "Confirm Phone", rightItem: nil)
            
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
            
            HStack(spacing: 15) {
                Text("Didn't receive a text?")
                    .font(.footnote)
                    .fontDesign(.rounded)
                
                if timeRemaining == 0 {
                    Button {
                        timeRemaining = 15
                    } label: {
                        Text("Send Again")
                            .font(.callout)
                    }
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .frame(width: 130, height: 30)
                    .background(backgroundGradient)
                    .opacity(0.9)
                    .clipShape(Capsule())
                    .shadow(radius: 2)
                } else {
                    Text("Please wait \(timeRemaining) seconds")
                        .font(.footnote)
                        .fontDesign(.rounded)
                        .foregroundColor(.gray)
                        .onReceive(timer) { _ in
                            if timeRemaining > 0 {
                                timeRemaining -= 1
                            }
                        }
                }
                
            } //: HStack
            .padding(.vertical)
            .frame(height: 30)
            
            ContinueButton(text: "Continue") {
                //
            }
            .padding(.top)
            
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
