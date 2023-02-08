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
        NavigationView {
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
                        .modifier(TextMod(.caption, .light, .gray))
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
            .navigationBarBackButtonHidden()
            .toolbar(.hidden)
        } //: NavigationView
    }
}

struct AddPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        AddPhoneView()
    }
}
