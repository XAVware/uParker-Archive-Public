//
//  AddPhoneView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 2/6/23.
//

import SwiftUI
import FirebaseAuth

@MainActor class AddPhoneViewModel: ObservableObject {
    @Published var phoneNumber: String = ""
    @Published var smsCode: String = ""
    @Published var timeRemaining: Int = 5
    @Published var isConfirmingPhone: Bool = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    private var verificationId: String?
    
    func continueTapped() {
        print("Continue tapped")
        if isConfirmingPhone {
            
            
        } else {
//            guard phoneNumber.count == 14 else {
//                AlertManager.shared.showError(title: "Error", message: "Please enter a valid phone number")
//                return
//            }
            let formattedNumber = "+1\(phoneNumber)"
            
            authorizePhone(phoneNum: formattedNumber) {
                print("Successfully authorized number, displaying confirmation page")
                self.isConfirmingPhone.toggle()
            }
        }
        
    }
    
    private func authorizePhone(phoneNum: String, completion: @escaping () -> Void) {
        print("Authorize phone called")
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNum, uiDelegate: nil) { verificationId, error in
            print("Entered Phone Auth Func")
            guard let verificationId = verificationId, error == nil else {
                print("Error: \(error?.localizedDescription)")
                AlertManager.shared.showError(title: "Error", message: error?.localizedDescription ?? "something went wrong - AddPhoneViewModel authorizePhone()")
                return
            }
            self.verificationId = verificationId
            print("About to call completion")
            completion()
        }
    }
    
    private func verifyCode(code: String, completion: @escaping () -> Void) {
        guard let verificationId = verificationId else {
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: code)
        
        Auth.auth().signIn(with: credential) { result, error in
            guard result != nil, error == nil else {
                AlertManager.shared.showError(title: "Error", message: error?.localizedDescription ?? "something went wrong - AddPhoneViewModel authorizePhone()")
                return
            }
            completion()
        }
    }
    
}

struct AddPhoneView: View {
    @StateObject var vm: AddPhoneViewModel = AddPhoneViewModel()
    @FocusState private var focusField: FocusText?
    enum FocusText { case phone, confirmationCode }
    
    var body: some View {
        VStack {
            if vm.isConfirmingPhone {
                confirmPhone
            } else {
                addPhone
            }
            
            navigationButtons
            
            Spacer()
            
        } //: VStack
        .padding(.horizontal)
        .navigationBarTitleDisplayMode(.inline)
    } //: Body
    
    private var addPhone: some View {
        VStack {
            AnimatedTextField(boundTo: $vm.phoneNumber, placeholder: "Phone Number")
                .padding(.top, 20)
                .keyboardType(.numberPad)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .focused($focusField, equals: .phone)
                .submitLabel(.continue)
//                .onChange(of: vm.phoneNumber, perform: {
//                    vm.phoneNumber = $0.formattedAsPhone
//                })
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
            
        }
        .navigationTitle("Add Phone Number")
    } //: Add Phone
    
    private var confirmPhone: some View {
        VStack {
            VStack(spacing: 5) {
                Text("A 6-digit confirmation code has been sent to:")
                    .modifier(TextMod(.footnote, .regular))
                
                Text(vm.phoneNumber)
                    .modifier(TextMod(.callout, .semibold))
            }
            .padding(.vertical)
            
            TextField("", text: $vm.smsCode)
                .multilineTextAlignment(.center)
                .frame(width: 275, height: 60)
                .foregroundColor(primaryColor)
                .modifier(TextMod(.title, .semibold))
                .tracking(25)
                .keyboardType(.numberPad)
                .focused($focusField, equals: .confirmationCode)
                .submitLabel(.continue)
                .onChange(of: vm.smsCode, perform: {
                    vm.smsCode = String($0.prefix(6))
                })
                .onSubmit {
                    focusField = nil
                }
                .overlay(
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.accentColor, lineWidth: 2)
                        
                        if vm.smsCode.isEmpty {
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
                
                if vm.timeRemaining == 0 {
                    Button {
                        vm.timeRemaining = 5
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
                    Text("Please wait \(vm.timeRemaining) seconds")
                        .modifier(TextMod(.footnote, .regular, .gray))
                        .onReceive(vm.timer) { _ in
                            if vm.timeRemaining > 0 {
                                vm.timeRemaining -= 1
                            }
                        }
                        .onAppear {
                            vm.timeRemaining = 5
                        }
                }
                
            } //: HStack
            .padding(.vertical)
            .frame(height: 30)
            
            Spacer()
        } //: VStack
        .navigationTitle("Confirm Phone")
        .padding(.horizontal)
    } //: Confirm Phone
    
    private var navigationButtons: some View {
        VStack(spacing: 16) {
            Button {
                vm.continueTapped()
            } label: {
                Text("Continue")
                    .frame(maxWidth: .infinity)
            }
            .modifier(RoundedButtonMod())
            
            Button {
                UserManager.shared.signIn()
            } label: {
                Text("Add phone later").underline()
                    .modifier(TextMod(.callout, .regular))
            }
            .buttonStyle(PlainButtonStyle())
        } //: VStack
    } //: Navigation Buttons
    
}



struct AddPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        AddPhoneView()
    }
}
