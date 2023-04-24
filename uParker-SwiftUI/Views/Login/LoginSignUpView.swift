//
//  LoginSignUpView.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 4/24/23.
//

import SwiftUI
import FirebaseAuth

@MainActor class LoginSignUpViewModel: ObservableObject {
    @Published var isSigningUp: Bool = false
    @Published var isRequestInProgress: Bool = false
    @Published var isConfirmingPhone: Bool = false
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    
    @Published var phoneNumber: String = ""
    @Published var smsCode: String = ""
    @Published var timeRemaining: Int = 5
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private var verificationId: String?
    
    func continueTapped() {
        if isConfirmingPhone {
            verifyCode(code: smsCode) {
                print("Successfully verified code")
                UserManager.shared.getCurrentUser {
                    //
                }
            }
            
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
        guard let verificationId = verificationId else { return }
        
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

struct LoginSignUpView: View {
    @StateObject var vm: LoginSignUpViewModel = LoginSignUpViewModel()
    @StateObject var alertManager: AlertManager = AlertManager.shared
    @FocusState private var focusField: FocusText?
    enum FocusText { case email, phone, confirmationCode }
    
    var body: some View {
        NavigationView {
            VStack {
                phoneViews
                
                continueButton
                
                Spacer()
                
            } //: VStack
            .padding(.horizontal)
            .navigationTitle("Login or Sign Up")
        } //: NavigationView
    } //: Body
    
    @ViewBuilder private var phoneViews: some View {
        if vm.isConfirmingPhone {
            confirmPhone
        } else {
            addPhone
        }
    }
    
    private var addPhone: some View {
        VStack(spacing: 20) {
            AnimatedTextField(boundTo: $vm.phoneNumber, placeholder: "Phone Number")
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
            
        } //: VStack
        .padding(.vertical)
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
    
    private var infoFields: some View {
        VStack(spacing: 16) {
            if vm.isSigningUp {
                nameFields
            }
            
            AnimatedTextField(boundTo: $vm.email, placeholder: "Email Address")
                .modifier(EmailFieldMod())
                .focused($focusField, equals: .email)
                .onSubmit {
                    focusField = nil
                }
                .onTapGesture {
                    focusField = .email
                }
            
        } //: VStack
    } //: Info Fields
    
    private var authOptions: some View {
        VStack(spacing: 16) {
            Button {
                //
            } label: {
                Text("Continue with Apple")
                    .frame(maxWidth: .infinity)
            }
            .modifier(OutlinedButtonMod())
            .overlay(
                Image(systemName: "apple.logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .padding(.leading), alignment: .leading
            )
            
            Button {
                //
            } label: {
                Text("Continue with Google")
                    .frame(maxWidth: .infinity)
            }
            .modifier(OutlinedButtonMod())
            .overlay(
                Image("GoogleIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .padding(.leading), alignment: .leading
            )
            
        } //: VStack
    } //: Auth Options
    
    private var continueButton: some View {
        Button {
            vm.continueTapped()
        } label: {
            Text("Continue")
                .frame(maxWidth: .infinity)
        }
        .modifier(RoundedButtonMod())
    } //: Continue Button
    
    private var signUpButton: some View {
        Button {
            vm.isSigningUp.toggle()
        } label: {
            Text(vm.isSigningUp ? "Already have an account? Log in." : "Don't have an account? Sign up now!")
                .underline()
                .modifier(TextMod(.footnote, .regular))
        }
    } //: Sign Up Button
    
    private var nameFields: some View {
        HStack(spacing: 16) {
            AnimatedTextField(boundTo: $vm.firstName, placeholder: "First Name")
            
            AnimatedTextField(boundTo: $vm.lastName, placeholder: "Last Name")
        } //: HStack
    }
}

struct LoginSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSignUpView()
    }
}
