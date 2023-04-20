//
//  ConfirmPhoneView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 3/27/23.
//

import SwiftUI

struct ConfirmPhoneView: View {
    // MARK: - PROPERTIES
    @FocusState private var focusField: FocusText?
    enum FocusText { case confirmationCode }
    
    let phoneNumber: String
    
    @State var code: String = ""
    @State var timeRemaining: Int = 5
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    // MARK: - BODY
    var body: some View {
        VStack {
            VStack(spacing: 5) {
                Text("A 6-digit confirmation code has been sent to:")
                    .modifier(TextMod(.footnote, .regular))
                
                Text(phoneNumber)
                    .modifier(TextMod(.callout, .semibold))
            }
            .padding(.vertical)
            
            TextField("", text: $code)
                .multilineTextAlignment(.center)
                .frame(width: 275, height: 60)
                .foregroundColor(primaryColor)
                .modifier(TextMod(.title, .semibold))
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
                                .modifier(TextMod(.title, .semibold, primaryColor))
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
                    .modifier(TextMod(.footnote, .regular))
                
                if timeRemaining == 0 {
                    Button {
                        timeRemaining = 5
                    } label: {
                        Text("Send Again")
                            .modifier(TextMod(.callout, .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(width: 130, height: 30)
                    .background(backgroundGradient)
                    .opacity(0.9)
                    .clipShape(Capsule())
                    .shadow(radius: 2)
                } else {
                    Text("Please wait \(timeRemaining) seconds")
                        .modifier(TextMod(.footnote, .regular, .gray))
                        .onReceive(timer) { _ in
                            if timeRemaining > 0 {
                                timeRemaining -= 1
                            }
                        }
                }
                
            } //: HStack
            .padding(.vertical)
            .frame(height: 30)
            
            Button {
//                dismiss.callAsFunction()
                //Log user in
            } label: {
                Text("Continue")
                    .frame(maxWidth: .infinity)
            }
            .modifier(RoundedButtonMod())
            .padding(.top)
            
            Spacer()
        } //: VStack
        .navigationTitle("Confirm Phone Number")
        .padding(.horizontal)
    }
}

struct ConfirmPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmPhoneView(phoneNumber: "201-874-3252")
    }
}
