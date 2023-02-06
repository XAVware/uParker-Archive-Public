//
//  AddPhoneView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/6/23.
//

import SwiftUI

struct AddPhoneView: View {
    // MARK: - PROPERTIES
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var sessionManager: SessionManager
    @FocusState private var focusField: FocusText?
    enum FocusText { case phone, confirmationCode }
    
    @State private var phoneNumber: String = ""
    @State private var isConfirming: Bool = false
    
    @State var code: String = ""
    @State var timeRemaining: Int = 5
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    // MARK: - BODY
    var body: some View {
        VStack {
            // MARK: - ADD PHONE
            if self.isConfirming == false {
                HeaderView(leftItem: .xmark, title: "Add Phone Number", rightItem: nil)
                    .ignoresSafeArea(.keyboard)
                    .padding(.bottom, 30)
                
                AnimatedTextField(boundTo: $phoneNumber, placeholder: "Phone Number")
                    .padding(.top, 20)
                    .keyboardType(.numberPad)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .focused($focusField, equals: .phone)
                    .submitLabel(.continue)
                    .onChange(of: phoneNumber, perform: {
                        phoneNumber = String($0.prefix(14)).applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
                    })
                    .onSubmit {
                        focusField = nil
                    }
                    .onTapGesture {
                        focusField = .phone
                    }
                
                Text("We'll call or text to confirm your number. Standard message and data rates apply.")
                    .font(.caption)
                    .foregroundColor(.black)
                    .opacity(0.7)
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
                
                
                Button {
                    focusField = nil
                    isConfirming = true
//                    dismiss.callAsFunction()
//                    sessionManager.logIn()
                } label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                }
                .modifier(RoundedButtonMod())

            } else {
                // MARK: - CONFIRM PHONE
                HeaderView(leftItem: .chevron, title: "Confirm Phone", rightItem: nil)
                
                VStack(spacing: 5) {
                    Text("A 6-digit confirmation code has been sent to:")
                        .font(.footnote)
                        .fontDesign(.rounded)
                    
                    Text(phoneNumber)
                        .modifier(CalloutTextMod())
                }
                .padding(.vertical)
                
                TextField("", text: $code)
                    .multilineTextAlignment(.center)
                    .frame(width: 275, height: 60)
                    .foregroundColor(primaryColor)
                    .modifier(BigTitleMod())
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
                                    .modifier(BigTitleMod())
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
                            timeRemaining = 5
                        } label: {
                            Text("Send Again")
                                .modifier(CalloutTextMod())
                        }
                        .foregroundColor(.white)
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
                
                Button {
                    dismiss.callAsFunction()
                    sessionManager.logIn()
                } label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                }
                .modifier(RoundedButtonMod())
                .padding(.top)
                
            }
            
            Spacer()
            
        } //: VStack
        .padding(.horizontal)
    }
}

struct AddPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        AddPhoneView()
    }
}
